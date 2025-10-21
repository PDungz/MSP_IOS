//
//  ApiResponse.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation

/// Generic API Response wrapper - Sử dụng chung cho toàn bộ dự án
struct ApiResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let timestamp: String
    let code: Int

    // MARK: - Computed Properties
    var isSuccess: Bool {
        return success && code >= 200 && code < 300
    }

    var errorMessage: String {
        return message ?? "Unknown error"
    }
}

// MARK: - Convenience Extensions
extension ApiResponse {
    /// Check if response has data
    var hasData: Bool {
        return data != nil
    }

    /// Get data or throw error
    func getData() throws -> T {
        guard success else {
            throw APIError.serverError(statusCode: code, message: message)
        }

        guard let data = data else {
            throw APIError.noData
        }

        return data
    }
}
