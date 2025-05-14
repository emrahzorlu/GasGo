//
//  ErrorModel.swift
//  VoiceShiftAI
//
//  Created by Emrah Zorlu on 4.05.2024.
//

import Foundation

struct MethodDecoder: RemoteDecoderProtocol {
    struct DateDecodingStrategy {
        static var `default`: JSONDecoder.DateDecodingStrategy {
            .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                guard let date = dateFormatter.date(from: dateString) else {
                    return Date(timeIntervalSinceReferenceDate: 0)
                }
                
                return date
            })
        }
    }
    
    func decode<T: Decodable>(data: Data, urlResponse: URLResponse) throws -> T {
        guard let response = urlResponse as? HTTPURLResponse else { throw Remote.Error.unknown }
        guard response.statusCode == 200 else {
            let decoder = JSONDecoder()
            
            var error: ErrorModel?
            
            do {
                error = try decoder.decode(ErrorModel.self, from: data)
            } catch let error {
                debugPrint("ERROR: -- \(Remote.Error.decode(data: data, underlyingError: error)) --")
                throw Remote.Error.decode(data: data, underlyingError: error)
            }
            
            guard let error = error else {
                debugPrint("ERROR: -- \(Remote.Error.unknown) --")
                throw Remote.Error.unknown
            }
            debugPrint("ERROR: -- \(Remote.Error.methodError(error)) --")
            throw Remote.Error.methodError(error)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = DateDecodingStrategy.default
        return try decoder.decode(T.self, from: data)
    }
}
