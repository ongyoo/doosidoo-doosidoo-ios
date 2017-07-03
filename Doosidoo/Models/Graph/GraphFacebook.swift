//
//  GraphFacebook.swift
//  Doosidoo
//
//  Created by Komsit Developer on 4/9/2560 BE.
//  Copyright © 2560 Doosidoo. All rights reserved.
//

import Foundation
import Gloss

struct GraphFacebook: Decodable {
    var fbId: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var birthday: String?
    
    init?(json: JSON) {
        self.fbId = "id" <~~ json
        self.email = "email" <~~ json
        self.firstName = "first_name" <~~ json
        self.lastName = "last_name" <~~ json
        self.gender = "gender" <~~ json
        self.birthday = "birthday" <~~ json
        
    }
}
