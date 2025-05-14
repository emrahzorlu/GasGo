//
//  ErrorModel.swift
//  VoiceShiftAI
//
//  Created by Emrah Zorlu on 4.05.2024.
//

import Foundation

extension Remote {
    
    class Request {
        private(set) var session: URLSessionProtocol = URLSession.shared
        private(set) var headers = Set<HttpHeader>()
        private(set) var url: URL?
        private(set) var method = HttpMethod.post
        private(set) var body: Data?
        private(set) var encoder: RemoteEncoderProtocol = Encoder.Json()
        private(set) var decoder: RemoteDecoderProtocol = Decoder.Json()

        init(with request: Request? = nil) {
            guard let request = request else { return }
            
            session = request.session
            headers = request.headers
            url = request.url
            method = request.method
            body = request.body
            encoder = request.encoder
            decoder = request.decoder
        }
        
        @discardableResult
        func set(session: URLSessionProtocol) -> Self {
            self.session = session
            return self
        }
        
        @discardableResult
        func set(header: HttpHeader) -> Self {
            headers.update(with: header)
            return self
        }
        
        @discardableResult
        func set(url: URL?) -> Self {
            self.url = url
            return self
        }
        
        @discardableResult
        func set<T: Encodable>(url: URL?, query: T) throws -> Self {
            self.url = try URLQueryEncoder().encode(baseUrl: url, model: query)
            return self
        }
        
        @discardableResult
        func set(method: HttpMethod) -> Self {
            self.method = method
            return self
        }
        
        @discardableResult
        func set<T: Encodable>(body: T) throws -> Self {
            self.body = try encoder.encode(model: body)
            return self
        }
        
        @discardableResult
        func set(body: Data) -> Self {
            self.body = body
            return self
        }
        
        @discardableResult
        func set<T: RemoteEncoderProtocol>(encoder: T) -> Self {
            self.encoder = encoder
            return self
        }
        
        @discardableResult
        func set<T: RemoteDecoderProtocol>(decoder: T) -> Self {
            self.decoder = decoder
            return self
        }
        
        func send<T: Decodable>() throws -> T {
            let urlRequest = try createUrlRequest()
            
            var responseError: Swift.Error?
            var responseData: T?
            let semaphore = DispatchSemaphore(value: 0)
            
            debugPrint("URL: -- \(urlRequest) --")
            
            session.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
                defer {
                    semaphore.signal()
                }
                
                guard let `self` = self else { return }
               
                do {
                    responseData = try self.parse(data: data, urlResponse: urlResponse, error: error)
                } catch let error {
                    debugPrint("ERROR: -- \(error.localizedDescription) --")
                    responseError = error
                }
            }.resume()
            semaphore.wait()
            
            if let error = responseError {
                debugPrint("ERROR: -- \(error.localizedDescription) --")
                throw error
            }
            
            if let data = responseData {
                debugPrint("-- SUCCESS --")
                return data
            }
            
            throw Error.noContent
        }
        
        private func createUrlRequest() throws -> URLRequest {
            guard let url = url else {
                throw URLError(.badURL)
            }
            
            var urlRequest = URLRequest(url: url)
            
            for header in headers {
                let pair = header.pair()
                urlRequest.setValue(pair.value, forHTTPHeaderField: pair.key)
            }
            
            urlRequest.httpMethod = method.rawValue
            urlRequest.httpBody = body
            
            return urlRequest
        }
        
        private func parse<T: Decodable>(data: Data?, urlResponse: URLResponse?, error: Swift.Error?) throws -> T {
            if let error = error {
                debugPrint("ERROR: -- \(error.localizedDescription) --")
                throw error
            }
            
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                debugPrint("ERROR: -- \(Remote.Error.nilResponse) --")
                throw Remote.Error.nilResponse
            }
            
            guard let data = data else {
                debugPrint("ERROR: -- \(Remote.Error.noContent) --")
                throw Remote.Error.noContent
            }
            
            do {
                return try self.decoder.decode(data: data, urlResponse: urlResponse)
            } catch let error {
                debugPrint("ERROR: -- \(Remote.Error.decode(data: data, underlyingError: error)) --")
                throw Remote.Error.decode(data: data, underlyingError: error)
            }
        }
    }
    
}
