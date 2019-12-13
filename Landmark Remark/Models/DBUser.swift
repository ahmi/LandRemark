//
//  DBUser.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 13/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import Firebase
struct DBUser {
    let uid: String
    let email: String
    let firstname:String
    let lastname: String
    
  //  init(authData: Firebase.User) {
//        uid = authData.uid
//        email = authData.email!
//    }
    init(email: String, fname:String, lname: String, uid:String) {
        self.uid = uid
        self.email = email
        self.firstname = fname
        self.lastname = lname
    }
}
