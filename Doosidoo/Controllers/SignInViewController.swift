//
//  SignInViewController.swift
//  Doosidoo
//
//  Created by Komsit Developer on 3/28/2560 BE.
//  Copyright © 2560 Doosidoo. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: Username.text!, password: Password.text!, completion: {
            user, error in
            if error != nil {
                print("incorrect")
            } else {
                print("logged in")
            }
        })
    }
    
    @IBAction func register(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: Username.text!, password: Password.text!, completion: {
            user, error in
            if error != nil {
                print("Can't register")
            } else {
                print("User created")
            }
        })
    }
    
    @IBAction func signinFBAction(_ sender: UIButton) {
        let userModel = UserModel()
        userModel.connectFb(fromViewController: self, completion: { (fbAcccount) in
            if let _ = fbAcccount.fbId {
                self.performSegue(withIdentifier: "signInToRoot", sender: self)
            }
            
        }) { (message) in
            print(message.body)
        }
    }
}
