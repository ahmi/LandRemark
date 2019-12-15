//
//  CreateNoteViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 15/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class CreateNoteViewController: UIViewController {
    //Default switch value/is_public parameter
    var isNotePublic = true
    //Reference to notes directory at cloud
    let notesRef = Database.database().reference(withPath: "notes")
    @IBOutlet weak var txtView_noteText: UITextView!
    @IBOutlet weak var btnSaveNote_tapped: UIBarButtonItem!
   
    
    
    //MARK:- Action Methods
    @IBAction func btnSaveNote_tapped(_ sender: Any) {
        
        let user = Auth.auth().currentUser!
        self.notesRef.childByAutoId().setValue(["note_text":"test note","addedByUser":user.displayName ?? "Anonymous", "location":"test location", "uid": user.uid,"is_public":isNotePublic,"lat": -33.884921, "lon":151.215827 ]) {  (error, dbreference)  in
            if error != nil
            {
                //handle error here
            }
            else{
               //handle success response here
                //Fire a notification OR listen to change in db
                //Dismiss controller
                
            }
        }
    }
    
    @IBAction func btnCancel_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeNotePublic_valueChanged(_ sender: UISwitch) {
        //value will be updated as switch value is changed.
        isNotePublic = sender.isOn
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
