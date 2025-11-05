//
//  APIError.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case noData

    // MARK: - Enhanced Error Cases
    case timeout
    case noInternetConnection
    case requestCancelled
    case tooManyRequests(retryAfter: TimeInterval?)
    case forbidden
    case notFound
    case internalServerError
    case serviceUnavailable
    case badRequest(message: String?)
    case tokenRefreshFailed
    case rateLimitExceeded

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
            return "Không có quyền truy cập. Vui lòng đăng nhập lại"
        case .noData:
            return "Không có dữ liệu"
        case .timeout:
            return "Yêu cầu hết thời gian chờ"
        case .noInternetConnection:
            return "Không có kết nối internet. Vui lòng kiểm tra lại"
        case .requestCancelled:
            return "Yêu cầu đã bị hủy"
        case .tooManyRequests(let retryAfter):
            if let retryAfter = retryAfter {
                return "Quá nhiều yêu cầu. Vui lòng thử lại sau \(Int(retryAfter)) giây"
            }
            return "Quá nhiều yêu cầu. Vui lòng thử lại sau"
        case .forbidden:
            return "Không có quyền truy cập tài nguyên này"
        case .notFound:
            return "Không tìm thấy tài nguyên"
        case .internalServerError:
            return "Lỗi máy chủ nội bộ. Vui lòng thử lại sau"
        case .serviceUnavailable:
            return "Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau"
        case .badRequest(let message):
            return "Yêu cầu không hợp lệ: \(message ?? "Vui lòng kiểm tra dữ liệu")"
        case .tokenRefreshFailed:
            return "Không thể làm mới phiên đăng nhập. Vui lòng đăng nhập lại"
        case .rateLimitExceeded:
            return "Vượt quá giới hạn số lượng yêu cầu"
        }
    }

    // MARK: - Equatable
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized),
             (.noData, .noData),
             (.timeout, .timeout),
             (.noInternetConnection, .noInternetConnection),
             (.requestCancelled, .requestCancelled),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.internalServerError, .internalServerError),
             (.serviceUnavailable, .serviceUnavailable),
             (.tokenRefreshFailed, .tokenRefreshFailed),
             (.rateLimitExceeded, .rateLimitExceeded):
            return true
        case let (.serverError(lhsCode, lhsMessage), .serverError(rhsCode, rhsMessage)):
            return lhsCode == rhsCode && lhsMessage == rhsMessage
        case let (.badRequest(lhsMessage), .badRequest(rhsMessage)):
            return lhsMessage == rhsMessage
        case let (.tooManyRequests(lhsRetry), .tooManyRequests(rhsRetry)):
            return lhsRetry == rhsRetry
        case let (.networkError(lhsError), .networkError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case let (.decodingError(lhsError), .decodingError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }

    // MARK: - Helper Properties

    /// Indicates if the error is recoverable (can retry)
    var isRecoverable: Bool {
        switch self {
        case .timeout, .noInternetConnection, .serviceUnavailable,
             .tooManyRequests, .internalServerError, .networkError:
            return true
        default:
            return false
        }
    }

    /// Indicates if user should be logged out
    var requiresLogout: Bool {
        switch self {
        case .unauthorized, .tokenRefreshFailed:
            return true
        default:
            return false
        }
    }

    /// HTTP status code (if available)
    var statusCode: Int? {
        switch self {
        case .serverError(let code, _):
            return code
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .tooManyRequests:
            return 429
        case .internalServerError:
            return 500
        case .serviceUnavailable:
            return 503
        case .badRequest:
            return 400
        default:
            return nil
        }
    }
}
