//
//  NoteDetailMapView.swift
//  TestNotesApp
//
//  Created by Ahmad Waqas on 6/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
protocol noteMapViewDelegate: class {
    //Can be implemented if required, in case functionality needs to be implemented on notes
    func detailsRequestedForNote(note: DBNote)
}
class NoteDetailMapView: UIView {
    
   @IBOutlet weak var lblUserName: UILabel!
       @IBOutlet weak var lblLocation: UILabel!
       @IBOutlet weak var lblNotes: UILabel!
       var note: DBNote!
       weak var delegate: noteMapViewDelegate?
       //Calling this method just before displaying callout view
       func configureWithNote(currentNote: DBNote) {
           self.note = currentNote
           self.lblUserName.text = note.addedByUser
           self.lblLocation.text = note.location
           self.lblNotes.text = note.note_text
           
       }
       override func awakeFromNib() {
           super.awakeFromNib()
           self.lblLocation.numberOfLines = 2
       }
    
}
