//
//  APIError.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL không hợp lệ"
        case .invalidResponse:
            return "Phản hồi không hợp lệ từ server"
        case .networkError(let error):
            return "Lỗi mạng: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Lỗi phân tích dữ liệu: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Lỗi server (\(code)): \(message ?? "Không xác định")"
        case .unauthorized:
            return "Không có quyền truy cập"
        case .noData:
            return "Không có dữ liệu"
        }
    }
}
