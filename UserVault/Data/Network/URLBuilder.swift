//
//  URLBuilder.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

struct NoReply: Decodable {}

enum ServicePath: String {
    case getUsers = "users"
}

/// Constructs API URLs using the Builder pattern.
///
/// Provides a fluent interface for assembling URL strings
/// from a base host, optional path segments, and path parameters.
///
/// ## Usage
/// ```swift
/// let url = URLBuilder()
///     .urlBase()
///     .path(.getUsers)
///     .build()
/// // "https://jsonplaceholder.typicode.com/users"
/// ```
///
/// ## Methods
/// - `urlBase()`: Sets the base host URL.
/// - `path(_:)`: Appends a predefined service path.
/// - `param(_:value:)`: Replaces a `{key}` placeholder in the path.
/// - `build()`: Returns the assembled URL string.
final class URLBuilder {
    private var host = ""
    private var path = ""

    func urlBase() -> URLBuilder {
        self.host = "https://jsonplaceholder.typicode.com/"
        return self
    }

    func path(_ path: ServicePath) -> URLBuilder {
        self.path = path.rawValue
        return self
    }

    func param(_ key: String, value: String) -> URLBuilder {
        self.path = self.path.replacingOccurrences(of: "{\(key)}", with: value)
        return self
    }

    func build() -> String {
        "\(host)\(path)"
    }
}
