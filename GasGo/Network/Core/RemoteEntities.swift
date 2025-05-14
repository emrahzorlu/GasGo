//
//  ErrorModel.swift
//  VoiceShiftAI
//
//  Created by Emrah Zorlu on 4.05.2024.
//

import Foundation

extension Remote {
    enum HttpMethod: String {
        case get
        case post
        case delete
    }
    
    enum ContentType: String {
        case json = "application/json"
        case urlEncoded = "application/x-www-form-urlencoded"
    }
    
    enum HttpHeader {
        case contentType(ContentType)
        case build
        case platform
        case authorization(String)
        case lang
        
        func pair() -> (key: String, value: String) {
            switch self {
            case .contentType(let value):
                return (key: "content-type", value: value.rawValue)
            case .build:
                return (key: "build", value: "217")
            case .platform:
                return (key: "platform", value: "IPHONE")
            case .authorization(let token):
                return (key: "useruuid", value: token)
            case .lang:
                return (key: "lang", value: Locale.current.language.languageCode?.identifier.description ?? "")
            }
        }
    }
}

extension Remote.HttpHeader: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pair().key)
    }
    
    static func == (lhs: Remote.HttpHeader, rhs: Remote.HttpHeader) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
}
