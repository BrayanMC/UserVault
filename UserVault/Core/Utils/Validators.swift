//
//  Validators.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

/// Reusable validation utilities for user input.
///
/// Provides static functions for common validations used
/// across `UserCreateView` and `UserDetailView`.
///
/// ## Methods
/// - `isValidEmail(_:)`: Validates email format using regex.
/// - `isNotEmpty(_:)`: Checks that a string is not blank after trimming.
enum Validators {

    /// Validates that the given string is a well-formed email address.
    static func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: email.trimmed)
    }

    /// Validates that the given string is not empty or whitespace-only.
    static func isNotEmpty(_ text: String) -> Bool {
        !text.isBlank
    }
}
