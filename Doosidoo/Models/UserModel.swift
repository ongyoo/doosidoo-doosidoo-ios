//
//  UserModel.swift
//  Doosidoo
//
//  Created by Komsit Developer on 4/9/2560 BE.
//  Copyright © 2560 Doosidoo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserModel: BaseModel {
    
    //MARK : Get local user Info
    static func facebookIdOfSignedInUser() -> String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.facebookId) ?? ""
    }
    
    static func fullNameOfSignedInUser() -> String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.fullName) ?? ""
    }
    
    func updateUser(value: String, forKey: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: forKey)
    }
    
    func connectFb(fromViewController vc: UIViewController, completion: @escaping (_ facebookAccount: GraphFacebook) -> (), failure: @escaping (_ error: ResultMessage) -> ()) {
        let fbSdkLoginManager = FBSDKLoginManager()
        fbSdkLoginManager.logOut()
        fbSdkLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: vc) { result, error in
            if (error != nil) {
                failure(ResultMessage(title: nil, body: error!.localizedDescription))
            } else if (result!.isCancelled) {
                debugPrint("Cancelled")
            } else {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, gender, birthday"]).start(completionHandler: { _, result, error in
                    if (error != nil) {
                        failure(ResultMessage(title: nil, body: error!.localizedDescription))
                    } else {
                        // TODO: send data from Facebook to server
                        debugPrint("signInWithFb : \(result)")
                        let fbResult = result as? Dictionary<String, AnyObject>
                        let facebookAccount = GraphFacebook(json: fbResult!)
                        
                        if let fbId = facebookAccount?.fbId {
                            self.updateUser(value: fbId, forKey: Constants.UserDefaultKeys.facebookId)
                        }
                        
                        if let _ = facebookAccount?.firstName {
                            let fullname = "\(facebookAccount?.firstName ?? "") \(facebookAccount?.lastName ?? "")"
                            self.updateUser(value: fullname, forKey: Constants.UserDefaultKeys.fullName)
                        }
                        
                        completion(facebookAccount!)
                    }
                })
            }
        }
    }

}
