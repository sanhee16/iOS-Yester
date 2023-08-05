//
//  AnyRepository.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/17.
//

import Foundation
import RealmSwift

class AnyRepository<RepositoryObject>: Repository
        where RepositoryObject: Entity,
        RepositoryObject.StoreType: Object {
    
    typealias RealmObject = RepositoryObject.StoreType
    
    private let realm: Realm

    init() {
        realm = try! Realm()
    }

    func getAll(where predicate: NSPredicate?) -> [RepositoryObject] {
        var objects = realm.objects(RealmObject.self)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        return objects.compactMap{ ($0).model as? RepositoryObject }
    }
    
    func insert(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toStorable())
        }
    }
    
    func update(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toStorable(), update: .modified)
        }
    }

    func delete(item: RepositoryObject) throws {
        try realm.write {
            let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
            if let productToDelete = realm.objects(RealmObject.self)
                .filter(predicate).first {
                realm.delete(productToDelete)
            }
        }
    }
}


