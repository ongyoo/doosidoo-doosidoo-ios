//
//  GraphTracking.swift
//  Doosidoo
//
//  Created by Komsit Developer on 4/10/2560 BE.
//  Copyright © 2560 Doosidoo. All rights reserved.
//

import Foundation
import Gloss

struct GraphTracking: Decodable {
    var userId: String?
    var lat: String?
    var long: String?
    var fullName: String?
    
    init?(json: JSON) {
        self.userId = "user_id" <~~ json
        self.lat = "lat" <~~ json
        self.long = "long" <~~ json
        self.fullName = "fullName" <~~ json
        
    }
    
    /*
     {"user_id":"1508594429190732","lat":"13.8805014195658","long":"100.53033498463","fullName":"Ong Chusangthong"}
     */
}
