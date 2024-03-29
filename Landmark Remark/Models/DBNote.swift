//
//  DBNote.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 13/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct DBNote {
    let ref: DatabaseReference?
    let note_text :String
    let lat: Double
    let lon:Double
    let location:String
    let addedByUser: String
    var is_public:Bool
    let key:String
    //in case we want to create whole object by value
    init(note_text: String, addedByUser: String,lat:Double,lon:Double, is_public: Bool, key: String = "", location: String) {
        self.ref = nil
        self.key = key
        self.note_text = note_text
        self.addedByUser = addedByUser
        self.is_public = is_public
        self.lat = lat
        self.location = location
        self.lon = lon
    }
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let note_text = value["note_text"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let location = value["location"] as? String,
            let lat = value["lat"] as? Double,
            let lon = value["lon"] as? Double,
            let is_public = value["is_public"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.lat = lat
        self.lon = lon
        self.location = location
        self.addedByUser = addedByUser
        self.is_public = is_public
        self.note_text = note_text
    }
 
    init?(dict: [String: Any], key:String) {
        guard
            let note_text = dict["note_text"] as? String,
            let addedByUser = dict["addedByUser"] as? String,
            let location = dict["location"] as? String,
            let lat = dict["lat"] as? Double,
            let lon = dict["lon"] as? Double,
            let is_public = dict["is_public"] as? Bool else {
                return nil
        }
        self.ref = nil
        self.key = key
        self.lat = lat
        self.lon = lon
        self.location = location
        self.addedByUser = addedByUser
        self.is_public = is_public
        self.note_text = note_text
    }

}
