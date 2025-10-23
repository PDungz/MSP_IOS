//
//  NetworkLogger.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import Foundation

class NetworkLogger {

    // MARK: - Request Logging

    static func logRequest(_ request: URLRequest) {
        var message = """
        [API]-[REQUEST]
        URL: \(request.url?.absoluteString ?? "N/A")
        Method: \(request.httpMethod ?? "N/A")
        Headers: \(formatJSON(request.allHTTPHeaderFields))
        """

        if let body = request.httpBody {
            message += "\nBody: \(formatJSON(body))"
        }

        AppLogger.i(message)
    }

    // MARK: - Response Logging

    static func logResponse(
        data: Data,
        response: URLResponse,
        request: URLRequest,
        duration: TimeInterval
    ) {
        guard let httpResponse = response as? HTTPURLResponse else { return }

        let statusCode = httpResponse.statusCode
        let isSuccess = (200..<300).contains(statusCode)

        let message = """
        [API]-[RESPONSE]
        Status: \(statusCode)
        Duration: \(String(format: "%.2f", duration))s
        URL: \(request.url?.absoluteString ?? "N/A")
        Method: \(request.httpMethod ?? "N/A")
        Response: \(formatJSON(data))
        """

        if isSuccess {
            AppLogger.s(message)
        } else {
            AppLogger.w(message)
        }
    }

    // MARK: - Error Logging

    static func logError(_ error: Error, request: URLRequest) {
        var message = """
        [API]-[ERROR]
        URL: \(request.url?.absoluteString ?? "N/A")
        Method: \(request.httpMethod ?? "N/A")
        Error: \(error.localizedDescription)
        """

        // Log thêm chi tiết cho URLError
        if let urlError = error as? URLError {
            message += "\nError Code: \(urlError.code.rawValue)"
            message += "\nError Type: \(urlError.code)"
        }

        // Log thêm chi tiết cho APIError
        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let code, let msg):
                message += "\nStatus Code: \(code)"
                message += "\nMessage: \(msg ?? "N/A")"
            case .decodingError(let decodingError):
                message += "\nDecoding Error: \(decodingError.localizedDescription)"
            default:
                break
            }
        }

        AppLogger.e(message)
    }

    // MARK: - Helper Methods

    private static func formatJSON(_ data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(
                withJSONObject: json,
                options: []
              ),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return String(data: data, encoding: .utf8) ?? "Unable to format"
        }

        return prettyString
    }

    private static func formatJSON(_ dictionary: [String: Any]?) -> String {
        guard let dict = dictionary,
              let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }

        return string
    }
}
