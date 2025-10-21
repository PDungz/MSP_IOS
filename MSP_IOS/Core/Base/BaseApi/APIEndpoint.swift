//
//  APIEndpoint.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

extension APIEndpoint {
    var baseURL: String {
        return APIConfig.gatewayBaseURL
    }

    var headers: [String: String]? {
        return APIConfig.defaultHeaders
    }

    var parameters: [String: Any]? { nil }
    var body: Data? { nil }

    func asURLRequest() throws -> URLRequest {
        var urlString = baseURL + path

        if method == .get, let params = parameters {
            var components = URLComponents(string: urlString)
            components?.queryItems = params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            guard let url = components?.url else {
                throw APIError.invalidURL
            }
            urlString = url.absoluteString
        }

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = APIConfig.requestTimeout

        // Merge headers (custom headers override defaults)
        var allHeaders = APIConfig.defaultHeaders
        if let customHeaders = headers {
            allHeaders.merge(customHeaders) { _, new in new }
        }
        request.allHTTPHeaderFields = allHeaders

        if method != .get {
            if let body = body {
                request.httpBody = body
            } else if let params = parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}
