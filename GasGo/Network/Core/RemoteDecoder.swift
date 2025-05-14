//
//  ErrorModel.swift
//  VoiceShiftAI
//
//  Created by Emrah Zorlu on 4.05.2024.
//

import Foundation

protocol RemoteDecoderProtocol {
    func decode<T: Decodable>(data: Data, urlResponse: URLResponse) throws -> T
}

extension Remote {
    struct Decoder {
        struct Json: RemoteDecoderProtocol {
            func decode<T: Decodable>(data: Data, urlResponse: URLResponse) throws -> T {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            }
        }
    }
}
