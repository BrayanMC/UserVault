//
//  Date+Extensions.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

extension Date {
    var shortDateString: String {
        formatted(as: "dd/MM/yyyy")
    }

    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
