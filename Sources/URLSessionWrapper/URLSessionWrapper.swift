//
//  URLSessionWrapper.swift
//  
//
//  Created by Alexander Eichhorn on 28.07.22.
//

import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public struct URLSessionWrapper {
    
    public let handleRequest: ((Request) async throws -> Response)
    
    public struct Request {
        public var url: URL
        public let httpMethod: String
        public var headers: [String: String]
        
        public init(url: URL, httpMethod: String = "get", headers: [String: String] = [:]) {
            self.url = url
            self.httpMethod = httpMethod
            self.headers = headers
        }
    }
    
    public struct Response {
        public let data: Data
        public let url: URL?
        public let statusCode: Int
        
        public init(data: Data, url: URL?, statusCode: Int) {
            self.data = data
            self.url = url
            self.statusCode = statusCode
        }
    }
    
    
    public init(handleRequest: @escaping ((Request) async throws -> Response)) {
        self.handleRequest = handleRequest
    }
    
    public init(handleRequest: @escaping ((Request, @escaping (Result<Response, Error>) -> Void) -> Void)) {
        self.handleRequest = { req in
            try await withCheckedThrowingContinuation { continuation in
                handleRequest(req) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }
    
#if !os(Linux)
    
    public static var `default`: Self {
        Self { request in
            var urlRequest = URLRequest(url: request.url)
            urlRequest.httpMethod = request.httpMethod
            urlRequest.allHTTPHeaderFields = request.headers
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            return Response(data: data, url: response.url, statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
    }
    
#endif
    
    
}
