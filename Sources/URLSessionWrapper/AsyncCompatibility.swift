//
//  AsyncCompatibility.swift
//  URLSessionWrapper
//
//  Created by Alexander Eichhorn on 17.01.22.
//

import Foundation


#if !os(Linux)

/// Backward compatibility of iOS 15 URLSession async function for older versions
@available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use system functions instead")
@available(tvOS, introduced: 13.0, deprecated: 15.0, message: "Use system functions instead")
@available(watchOS, introduced: 6.0, deprecated: 8.0, message: "Use system functions instead")
@available(macOS, introduced: 10.15, deprecated: 12.0, message: "Use system functions instead")
extension URLSession {
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.unknown)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.unknown)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }
    
}

#endif
