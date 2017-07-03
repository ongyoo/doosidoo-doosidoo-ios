//
//  MqttModel.swift
//  Claim Di
//
//  Created by Komsit on 9/28/2559 BE.
//  Copyright © 2559 Anywhere 2 Go. All rights reserved.
//

import UIKit
import SwiftMQTT

@objc protocol MqttModelDelegate: class {@objc
    optional func handleMessage(withMessage data:Data,withOnTopic topic: String)
}

class MqttModel: NSObject, MQTTSessionDelegate {
    static let sharedInstance = MqttModel()
    var myToken: String?
    var myMessage: String?
    var taskId: String?
    var partiesToken: String? = ""
    var mqttSession: MQTTSession!
    
    var delegate: MqttModelDelegate?
    func establishConnection() {
        
        /*
        mqttSession = MQTTSession(host: "m20.cloudmqtt.com", port: 15634, clientID: self.clientID(), cleanSession: true, keepAlive: 9999, useSSL: false)
        mqttSession.username = "btfafmli"
        mqttSession.password = "zXwJUmESEiPb"
        mqttSession.delegate = self
         */
        
        
        
        mqttSession = MQTTSession(host: "m12.cloudmqtt.com", port: UInt16(14738), clientID: self.clientID(), cleanSession: true, keepAlive: 9999, useSSL: false)
        mqttSession.username = "lzattmjo"
        mqttSession.password = "p2WjrtRGdqLM"
        mqttSession.delegate = self
        
        
        mqttSession.connect { (succeeded, error) in
            
        }
    }
    
    func subscribeToChannel(subChannel: String, completion: @escaping (_ succeeded: Bool, _ error: Error) -> Void) {
        let _subChannel = "doosidoo/"
        mqttSession.subscribe(to: _subChannel, delivering: .atMostOnce) { (succeeded, error) in
            completion(succeeded, error)
        }
    }
    
    func publish(myToken: String, token: String, message: String, isAccept: Bool, isBusy: Bool, isCancel: Bool) {
        let _subChannel = "doosidoo/\(token)"
        var _message = message
        // is_busy true  = ไม่ว่าง
        var jsonObject = [String: AnyObject]()
        jsonObject["is_accept"] = isAccept as AnyObject
        jsonObject["is_busy"] = isBusy as AnyObject
        jsonObject["is_cancel"] = isCancel as AnyObject
        jsonObject["message"] = message as AnyObject
        jsonObject["token"] = myToken as AnyObject

        /*
        let jsonObject: [String: AnyObject]  = ["is_accept" : isAccept as AnyObject,
                                                "is_busy" : isBusy as AnyObject,
                                                "is_cancel" : isCancel as AnyObject,
                                                "message" : message as AnyObject,
                                                "token" : myToken as AnyObject]
         */
        
        do {
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            _message = jsonString
        }
        
        let data = _message.data(using: .utf8)!
        mqttSession.publish(data, in: _subChannel, delivering: .atMostOnce, retain: false) { (succeeded, error) in
            debugPrint("Published \(message) on channel \(_subChannel)")
            
        }
    }
    
    func publishLocation(userId: String, lat: String, long: String, fullName: String) {
        let _subChannel = "doosidoo/"
        var _message = ""

        var jsonObject = [String: AnyObject]()
        jsonObject["lat"] = lat as AnyObject
        jsonObject["long"] = long as AnyObject
        jsonObject["user_id"] = userId as AnyObject
        jsonObject["fullName"] = fullName as AnyObject

        do {
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            _message = jsonString
        }
        
        let data = _message.data(using: .utf8)!
        mqttSession.publish(data, in: _subChannel, delivering: .atMostOnce, retain: false) { (succeeded, error) in
            debugPrint("Published \(_message) on channel \(_subChannel)")
            
        }
    }
    
    func unSubscribe(subChannel: String) {
        let _subChannel = "claimdi/k4k/\(subChannel)"
        mqttSession.unSubscribe(from: [_subChannel]) { (succeeded, error) in
            self.mqttSession.disconnect()
        }
    }
    
    func mqttSession(session: MQTTSession, received message: Data, in topic: String) {
        let string = String(data: message, encoding: .utf8)!
        debugPrint("data received on topic \(topic) message \(string)")
    }
    
    func mqttSocketErrorOccurred(session: MQTTSession) {
        debugPrint("Socket Error")
        //self.establishConnection()
    }
    
    func mqttDidDisconnect(session: MQTTSession) {
        debugPrint("Session Disconnected.")
        //self.establishConnection()
    }
    
    public func mqttDidReceive(message data: Data, in topic: String, from session: MQTTSession) {
        self.delegate?.handleMessage!(withMessage: data, withOnTopic: topic)
    }
    
    func clientID() -> String {
        
        let userDefaults = UserDefaults.standard
        let clientIDPersistenceKey = "clientID"
        let clientID: String
        
        if let savedClientID = userDefaults.object(forKey: clientIDPersistenceKey) as? String {
            clientID = savedClientID
        } else {
            clientID = randomStringWithLength(5)
            userDefaults.set(clientID, forKey: clientIDPersistenceKey)
            userDefaults.synchronize()
        }
        
        return clientID
    }
    
    func randomStringWithLength(_ len: Int) -> String {
        let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)
        
        var randomString = String()
        for _ in 0..<len {
            let length = UInt32(letters.count)
            let rand = arc4random_uniform(length)
            randomString += String(letters[Int(rand)])
        }
        return String(randomString)
    }
}
