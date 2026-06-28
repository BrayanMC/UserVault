//
//  UserVaultError.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

enum UserVaultError: LocalizedError {
    case network(String)
    case persistence(String)
    case validation(String)
    case locationDenied

    var errorDescription: String? {
        switch self {
        case .network(let message):
            return String(
                localized: "error_network \(message)",
                comment: "Network error with detail message"
            )
        case .persistence(let message):
            return String(
                localized: "error_persistence \(message)",
                comment: "Persistence error with detail message"
            )
        case .validation(let message):
            return String(
                localized: "error_validation \(message)",
                comment: "Validation error with detail message"
            )
        case .locationDenied:
            return String(
                localized: "error_location_denied",
                comment: "Location permission denied error"
            )
        }
    }
}
