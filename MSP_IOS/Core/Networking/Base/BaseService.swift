//
//  BaseService.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import Foundation
import Combine

class BaseService: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var successMessage: String?

    // MARK: - Protected Properties
    let networkManager = NetworkManager.shared
    let secureStorage = SecureStorage.shared

    // MARK: - Helper Methods

    /// Execute async request với loading state
    func executeRequest<T>(
        _ operation: @escaping () async throws -> T
    ) async throws -> T {
        isLoading = true
        error = nil
        successMessage = nil

        defer {
            isLoading = false
        }

        do {
            return try await operation()
        } catch {
            await MainActor.run {
                self.error = error as? APIError
            }
            throw error
        }
    }

    /// Execute request với full response
    func executeRequestWithFullResponse<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> (data: T, message: String?) {
        let response = try await executeRequest {
            try await self.networkManager.requestWithFullResponse(
                endpoint: endpoint,
                responseType: responseType
            )
        }

        let data = try response.getData()

        await MainActor.run {
            successMessage = response.message
        }

        return (data, response.message)
    }
}
