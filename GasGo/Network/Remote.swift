//
//  ErrorModel.swift
//  VoiceShiftAI
//
//  Created by Emrah Zorlu on 4.05.2024.
//

import Foundation

struct Remote {
    enum Error: LocalizedError {
        case unknown
        case nilResponse
        case noContent
        case decode(data: Data, underlyingError: Swift.Error)
        case methodError(ErrorModel)

        public var errorDescription: String? {
            switch self {
            case .unknown:
                return "Unknown Error"
            case .nilResponse:
                return "No response"
            case .noContent:
                return "No content"
            case .decode(_, let underlyingError):
                return underlyingError.localizedDescription
            case .methodError(let error):
                return error.error
            }
        }
    }
}
