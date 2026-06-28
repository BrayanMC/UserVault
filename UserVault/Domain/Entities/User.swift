//
//  User.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: Int
    var name: String
    var username: String
    var email: String
    var phone: String
    var city: String
    var street: String
    var suite: String
    var zipcode: String
    var latitude: String
    var longitude: String
    var companyName: String
    var website: String
    var isLocal: Bool
}
