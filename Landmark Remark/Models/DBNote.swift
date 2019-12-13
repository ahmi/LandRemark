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
    let lat: NSNumber
    let lon:NSNumber
    let location:String
    let addedByUser: String
    var is_public:Bool
    let key:String
    
    init(note_text: String, addedByUser: String,lat:NSNumber,lon:NSNumber, is_public: Bool, key: String = "", location: String) {
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
            let lat = value["lat"] as? NSNumber,
            let lon = value["lon"] as? NSNumber,
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
    
    func toAnyObject() -> Any {
      return [
        "lat": lat,
        "addedByUser": addedByUser,
        "is_public": is_public,
        "lon": lon,
        "location": location,
        "note_text": note_text
      ]
    }
}
