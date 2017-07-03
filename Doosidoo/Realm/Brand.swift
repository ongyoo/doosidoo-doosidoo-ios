//
//  Brand.swift
//  Claim Di
//
//  Created by Kakashi on 09/23/2016.
//  Copyright © 2016 Anywhere 2 Go. All rights reserved.
//

/*
import Foundation
import RealmSwift

class Brand: Object {
    dynamic var id: String? = nil
    dynamic var isActive: Bool = false
    dynamic var logo: String? = nil
    dynamic var name: String? = nil
    dynamic var sort: Int = 0
    let models = List<BrandModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func saveWithGraph(graph: GraphCarBrand) {
        let brand = Brand()
        brand.id = graph.id
        brand.isActive = graph.isActive ?? false
        brand.logo = graph.logo
        brand.name = graph.name
        brand.sort = graph.sort ?? 0
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(brand, update: true)
        }
    }
    
    static func graphWithObject(brand: Brand?) -> GraphCarBrand? {
        if let _brand = brand {
            let graph = GraphCarBrand()
            graph.id = _brand.id
            graph.isActive = _brand.isActive
            graph.logo = _brand.logo
            graph.name = _brand.name
            graph.sort = _brand.sort
            return graph
        }
        return nil
    }
    
    
    static func getBrandWithId(id: String?) -> Brand? {
        if let _ = id {
            let realm = try! Realm()
            return realm.object(ofType: Brand.self, forPrimaryKey: id!)
        }
        
        return nil
    }
    
    static func getList(isActive: Bool?) -> Results<Brand> {
        var predicate: NSPredicate?
        if let _isActive = isActive {
            predicate = NSPredicate(format: "isActive == %@", NSNumber(value: _isActive))
        }
        
        let realm = try! Realm()
        if let _ = predicate {
            return realm.objects(Brand.self).filter(predicate!).sorted(by: [SortDescriptor(property: "sort", ascending: false), "name"])
        } else {
            return realm.objects(Brand.self).sorted(by: [SortDescriptor(property: "sort", ascending: false), "name"])
        }
    }
    
    static func removeAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Brand.self).self)
        }
    }
}
*/
