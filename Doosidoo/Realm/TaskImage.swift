//
//  TaskImage.swift
//  Claim Di
//
//  Created by Komsit on 9/26/2559 BE.
//  Copyright © 2559 Anywhere 2 Go. All rights reserved.
//
/*
import Foundation
import RealmSwift

class TaskImage: Object {
    dynamic var damageLevelCode: String? = nil
    dynamic var desc: String? = nil
    dynamic var id: Int = 0
    dynamic var imageName: String = ""
    dynamic var imageSubType: String = ""
    dynamic var imageToken: String? = nil
    dynamic var imageType: String = ""
    dynamic var imageUrl: String? = nil
    dynamic var isRejected: Bool = false
    dynamic var isEdited: Bool = false
    dynamic var latitude: String? = nil
    dynamic var longitude: String? = nil
    dynamic var name: String? = nil
    dynamic var parentId: String? = nil
    dynamic var rejectComment: String? = nil
    dynamic var sequence: Int = 0
    dynamic var serverId: Int64 = 0
    dynamic var taskId: String = ""
    dynamic var thirdPartyCarId: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func idForLocal() -> Int {
        let defaults = UserDefaults.standard
        var id = defaults.integer(forKey: Constants.KeyLocalIdForTaskImage)
        if id == 0 {
            id = 1
        } else {
            id = id + 1
        }
        
        defaults.set(id, forKey: Constants.KeyLocalIdForTaskImage)
        return id
    }
    
    static func save(taskImage: TaskImage) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(taskImage, update: true)
        }
    }
    
    static func saveWithGraph(graph: GraphTaskImage, taskId: String!) {
        let taskImage = TaskImage()
        taskImage.damageLevelCode = graph.damageLevelCode
        taskImage.desc = graph.desc
        taskImage.imageUrl = graph.imageUrl
        
        debugPrint("saveWithGraph graph.imageUrl :\(graph.imageUrl)")
        //taskImage.imageName = ImageModel.imageName(imageType, imageId: taskImage.id)
        //taskImage.imageType = imageType.rawValue
        taskImage.isRejected = !(graph.isApproved ?? true)
        taskImage.latitude = graph.latitude
        taskImage.longitude = graph.longitude
        taskImage.name = graph.name
        taskImage.imageType = (graph.type?.id)!
        taskImage.parentId = graph.parentId
        taskImage.isEdited = graph.isEdited ?? false
        taskImage.rejectComment = graph.rejectComment
        taskImage.sequence = graph.sequence ?? 0
        taskImage.serverId =  Int64(graph.id!)
        taskImage.taskId = taskId
        taskImage.thirdPartyCarId = graph.thirdPartyCarId ?? ""
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(taskImage, update: true)
        }
    }
    
    static func graphWithObject(taskImage: TaskImage?) -> GraphTaskImage? {
        if let _taskImage = taskImage {
            let graph = GraphTaskImage()
            graph.id = _taskImage.id 
            graph.damageLevelCode = _taskImage.damageLevelCode
            graph.desc = _taskImage.desc
            graph.imageToken = _taskImage.imageToken
            graph.imageUrl = _taskImage.imageUrl
            graph.imageName = _taskImage.imageName
            graph.latitude = _taskImage.latitude
            graph.longitude = _taskImage.longitude
            graph.name = _taskImage.name
            graph.parentId = _taskImage.parentId
            graph.rejectComment = _taskImage.rejectComment
            graph.sequence = _taskImage.sequence
            graph.isEdited = _taskImage.isEdited
            graph.serverId = _taskImage.serverId
            let type = GraphImageType()
            type.id = taskImage?.imageType
            graph.type = type
            return graph
        }
        return nil
    }
    
    static func getList() -> Results<TaskImage> {
        let realm = try! Realm()
        return realm.objects(TaskImage.self).sorted(byProperty: "id", ascending: false)
    }
    
    static func getTaskImageWithThirdPartyCarId(taskId: String!) -> Results<TaskImage> {
        
        let predicate = NSPredicate(format: "taskId == '\(taskId)'")
        let realm = try! Realm()
        return realm.objects(TaskImage.self).filter(predicate)
    }
    
    static func getTaskImageWithImageType(imageType: TaskImageType) -> Results<TaskImage> {
        
        let predicate = NSPredicate(format: "imageType == '\(imageType.rawValue)'")
        let realm = try! Realm()
        return realm.objects(TaskImage.self).filter(predicate).sorted(by: [SortDescriptor(property: "imageType", ascending: true)])
    }
    
    static func getListBodyPart() -> Results<TaskImage> {
        let predicate = NSPredicate(format: "imageType CONTAINS[c] %@", "AR")
        
        let realm = try! Realm()
        return realm.objects(TaskImage.self).filter(predicate).sorted(by: [SortDescriptor(property: "imageType", ascending: true)])
    }
    
    static func getListISPDocument() -> Results<TaskImage> {
        let predicate = NSPredicate(format: "imageType CONTAINS[c] %@", "PD")
        
        let realm = try! Realm()
        return realm.objects(TaskImage.self).filter(predicate).sorted(by: [SortDescriptor(property: "imageType", ascending: true)])
    }
    
    static func getListISPDamage() -> Results<TaskImage> {
        let predicate = NSPredicate(format: "imageType == %@", TaskImageType.ISPDamage.rawValue) //TaskImageType
        
        let realm = try! Realm()
        return realm.objects(TaskImage.self).filter(predicate).sorted(by: [SortDescriptor(property: "imageType", ascending: true)])
    }
    
    static func getListISPAccessory() -> Results<TaskImage> {
        let predicate = NSPredicate(format: "imageType CONTAINS[c] %@", "AC")
        
        let realm = try! Realm()
        return realm.objects(TaskImage.self).filter(predicate).sorted(by: [SortDescriptor(property: "imageType", ascending: true)])
    }
    
    static func getTaskImageWithId(id: Int?) -> TaskImage? {
        if let _ = id {
            let realm = try! Realm()
            return realm.object(ofType: TaskImage.self, forPrimaryKey: id!)
        }
        
        return nil
    }
    
    static func updateServerIdForTaskImageWithId(id: Int, serverId: Int64) {
        let realm = try! Realm()
        try! realm.write {
            let taskImage = self.getTaskImageWithId(id: id)
            if let _ = taskImage {
                taskImage!.serverId = serverId
                taskImage!.isRejected = false
                taskImage!.isEdited = false
                realm.add(taskImage!, update: true)
            }
        }
    }
    
    /*
    static func deleteSignatureForTaskWithId(taskId: String) {
        let realm = try! Realm()
        try! realm.write {
            let signature = self.getListForTaskWithId(taskId, imageType: .Signature)
            realm.delete(signature)
        }
    }
     */
    
    static func deleteTaskImageWithId(id: Int) {
        let realm = try! Realm()
        try! realm.write {
            let taskImage = self.getTaskImageWithId(id: id)
            debugPrint("getTaskImageWithId : \(id)")
            debugPrint("taskImage : \(taskImage)")
            if let _ = taskImage {
                realm.delete(taskImage!)
            }
        }
    }
    
    static func removeAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(TaskImage.self).self)
        }
    }
}
 */
