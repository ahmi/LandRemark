//
//  NoteDetailMapView.swift
//  TestNotesApp
//
//  Created by Ahmad Waqas on 6/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
protocol noteMapViewDelegate: class {
    func detailsRequestedForNote(note: DBNote)
}
class NoteDetailMapView: UIView {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtVwNote: UITextView!
    @IBOutlet weak var btnDismiss: UIButton!
    var note: DBNote!
    weak var delegate: noteMapViewDelegate?
    @IBAction func btnDismiss_tapped(_ sender: Any) {
    }
    //Calling this method just before displaying callout view
    func configureWithPerson(currentNote: DBNote) {
        self.note = currentNote
        self.lblUserName.text = note.addedByUser
        self.lblLocation.text = note.location
        self.lblLocation.numberOfLines = 2
        self.txtVwNote.text = note.note_text
        self.txtVwNote.isEditable = false
    }
    //Add arrow direction to
    override func awakeFromNib() {
        super.awakeFromNib()
        // appearance
      //  self.btnDismiss.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
    }
    
}
