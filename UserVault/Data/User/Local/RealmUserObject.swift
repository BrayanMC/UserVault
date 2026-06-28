//
//  RealmUserObject.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import RealmSwift

class RealmUserObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var phone: String
    @Persisted var city: String
    @Persisted var street: String
    @Persisted var suite: String
    @Persisted var zipcode: String
    @Persisted var latitude: String
    @Persisted var longitude: String
    @Persisted var companyName: String
    @Persisted var website: String
    @Persisted var isDeleted: Bool = false
    @Persisted var isLocal: Bool = false

    func toDomain() -> User {
        User(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            city: city,
            street: street,
            suite: suite,
            zipcode: zipcode,
            latitude: latitude,
            longitude: longitude,
            companyName: companyName,
            website: website,
            isLocal: isLocal
        )
    }

    static func fromDomain(_ user: User) -> RealmUserObject {
        let object = RealmUserObject()
        object.id = user.id
        object.name = user.name
        object.username = user.username
        object.email = user.email
        object.phone = user.phone
        object.city = user.city
        object.street = user.street
        object.suite = user.suite
        object.zipcode = user.zipcode
        object.latitude = user.latitude
        object.longitude = user.longitude
        object.companyName = user.companyName
        object.website = user.website
        object.isLocal = user.isLocal
        return object
    }
}
