//
//  APIClient.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Alamofire
import Foundation

/// HTTP client responsible for communicating with the JSONPlaceholder REST API.
///
/// Uses Alamofire with async/await to perform network requests and maps
/// transport errors to `UserVaultError.network`. URLs are constructed
/// using `URLBuilder` (Builder pattern).
///
/// ## Methods
/// - `fetch(url:)`: Fetches and decodes a resource from the given URL string.
final class APIClient {

    /// Fetches a decodable resource from the given URL.
    /// - Parameter url: The full URL string built via `URLBuilder`.
    /// - Returns: The decoded value of the specified type.
    /// - Throws: `UserVaultError.network` if the request fails.
    func fetch<T: Decodable>(url: String) async throws -> T {
        debugPrint("[APIClient] REQUEST: GET \(url)")
        do {
            let response = AF.request(url)
                .validate()
                .serializingDecodable(T.self)
            let value = try await response.value
            debugPrint("[APIClient] RESPONSE: GET \(url) -> SUCCESS")
            return value
        } catch {
            debugPrint("[APIClient] ERROR: GET \(url) -> \(error.localizedDescription)")
            throw UserVaultError.network(error.localizedDescription)
        }
    }
}
