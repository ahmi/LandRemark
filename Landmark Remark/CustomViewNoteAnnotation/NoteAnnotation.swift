//
//  NoteAnnotation.swift
//  TestNotesApp
//
//  Created by Ahmad Waqas on 6/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import MapKit
class NoteAnnotation: NSObject , MKAnnotation{
    var note: DBNote
    var coordinate: CLLocationCoordinate2D {
        let cord = CLLocationCoordinate2DMake(note.lat, note.lon)
        return cord
    }
    
    init(currentNote: DBNote) {
        self.note = currentNote
        super.init()
    }
    
    var note_text: String? {
        
        return note.note_text
    }
    
    var subtitle: String? {
        //As we need to show user name and note according to requirements
        return note.addedByUser
    }
    
}
