//
//  ErrorModel.swift
//  VoiceShiftAI
//
//  Created by Emrah Zorlu on 4.05.2024.
//

import Foundation

struct URLQueryEncoder {
    
    func encode<T: Encodable>(baseUrl: URL?, model: T) throws -> URL {
        guard
            let baseUrl = baseUrl,
            var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
            else {
                throw URLError(.badURL)
        }
        
        let data = try JSONEncoder().encode(model)
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw URLError(.badURL)
        }
        
        var queryItems = components.queryItems ?? [URLQueryItem]()
        
        for (key, value) in json {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
}
