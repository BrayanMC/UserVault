//
//  UserDTO.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: AddressDTO
    let company: CompanyDTO

    struct AddressDTO: Decodable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: GeoDTO

        struct GeoDTO: Decodable {
            let lat: String
            let lng: String
        }
    }

    struct CompanyDTO: Decodable {
        let name: String
        let catchPhrase: String
        let bs: String
    }

    func toDomain() -> User {
        User(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            city: address.city,
            street: address.street,
            suite: address.suite,
            zipcode: address.zipcode,
            latitude: address.geo.lat,
            longitude: address.geo.lng,
            companyName: company.name,
            website: website,
            isLocal: false
        )
    }
}
