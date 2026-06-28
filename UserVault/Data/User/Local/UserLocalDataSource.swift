//
//  UserLocalDataSource.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation
import RealmSwift

final class UserLocalDataSource {

    private func openRealm() throws -> Realm {
        do {
            let realm = try Realm()
            debugPrint("[Realm] Database path: \(realm.configuration.fileURL?.absoluteString ?? "unknown")")
            return realm
        } catch {
            debugPrint("[Realm] ERROR opening database: \(error.localizedDescription)")
            throw UserVaultError.persistence(error.localizedDescription)
        }
    }

    func fetchActiveUsers() throws -> [User] {
        let realm = try openRealm()
        let objects = realm.objects(RealmUserObject.self)
            .where { $0.isDeleted == false }
        debugPrint("[Realm] FETCH active users: \(objects.count) results")
        return objects.map { $0.toDomain() }
    }

    func hasRemoteUsers() throws -> Bool {
        let realm = try openRealm()
        let count = realm.objects(RealmUserObject.self)
            .where { $0.isLocal == false && $0.isDeleted == false }
            .count
        debugPrint("[Realm] CHECK remote users: \(count) found")
        return count > 0
    }

    func saveUsers(_ users: [User]) throws {
        let realm = try openRealm()
        let deletedIds = Set(
            realm.objects(RealmUserObject.self)
                .where { $0.isDeleted == true }
                .map { $0.id }
        )
        let newUsers = users.filter { !deletedIds.contains($0.id) }
        let objects = newUsers.map { RealmUserObject.fromDomain($0) }
        try realm.write {
            realm.add(objects, update: .modified)
        }
        debugPrint("[Realm] SAVE \(objects.count) users (filtered \(deletedIds.count) deleted)")
    }

    func saveUser(_ user: User) throws {
        let realm = try openRealm()
        let object = RealmUserObject.fromDomain(user)
        try realm.write {
            realm.add(object, update: .modified)
        }
        debugPrint("[Realm] SAVE user id=\(user.id) name=\(user.name)")
    }

    func updateUser(_ user: User) throws {
        let realm = try openRealm()
        guard let object = realm.object(ofType: RealmUserObject.self, forPrimaryKey: user.id) else {
            debugPrint("[Realm] ERROR update: user id=\(user.id) not found")
            throw UserVaultError.persistence("User not found")
        }
        try realm.write {
            object.name = user.name
            object.email = user.email
        }
        debugPrint("[Realm] UPDATE user id=\(user.id) name=\(user.name) email=\(user.email)")
    }

    func deleteUser(withId id: Int) throws {
        let realm = try openRealm()
        guard let object = realm.object(ofType: RealmUserObject.self, forPrimaryKey: id) else {
            debugPrint("[Realm] ERROR delete: user id=\(id) not found")
            throw UserVaultError.persistence("User not found")
        }
        try realm.write {
            object.isDeleted = true
        }
        debugPrint("[Realm] DELETE (logical) user id=\(id)")
    }

    func nextId() throws -> Int {
        let realm = try openRealm()
        let maxId = realm.objects(RealmUserObject.self).max(ofProperty: "id") as Int? ?? 0
        debugPrint("[Realm] NEXT ID: \(maxId + 1)")
        return maxId + 1
    }
}
