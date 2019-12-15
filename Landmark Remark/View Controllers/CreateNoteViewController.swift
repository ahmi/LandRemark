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
import CoreLocation
class CreateNoteViewController: UIViewController,UITextViewDelegate {
    //Default switch value/is_public parameter
    var isNotePublic = true
    var current_location:CLLocation = CLLocation()
    //Reference to notes directory at cloud
    let notesRef = Database.database().reference(withPath: "notes") //URL to notes table in db
    @IBOutlet weak var txtView_noteText: UITextView!
    @IBOutlet weak var btnSaveNote_tapped: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAppearance()
    }
    //MARK:- Textview appearance and delegates
    func setAppearance()  {
        self.txtView_noteText.layer.cornerRadius = 10.0
        self.txtView_noteText.backgroundColor = .lightText
        txtView_noteText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        txtView_noteText.layer.borderWidth = 1.0
        txtView_noteText.layer.cornerRadius = 5
        self.txtView_noteText.text = "Enter your note here.."
        txtView_noteText.textColor = UIColor.lightGray
        txtView_noteText.becomeFirstResponder()
        txtView_noteText.selectedTextRange = txtView_noteText.textRange(from: txtView_noteText.beginningOfDocument, to: txtView_noteText.beginningOfDocument)
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Enter your note here.."
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    //MARK:- Action Methods
    @IBAction func btnSaveNote_tapped(_ sender: Any) {
        if !validateForm() {
            showNoteCreated(title: "Error", message: "Please Enter Valid Text..")
            return
        }
        let user = Auth.auth().currentUser!
         self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        self.notesRef.childByAutoId().setValue(["note_text":self.txtView_noteText.text ?? "This note text is placeholder in case of textview failure","addedByUser":user.displayName ?? "Anonymous user", "location":"test location", "uid": user.uid,"is_public":isNotePublic,"lat": -33.884921, "lon":151.215827 ]) {  (error, dbreference)  in
            self.view.activityStopAnimating()
            if error != nil
            {
                self.showNoteCreated(title: "Error", message: "There was a problem in creating your note. Please try later")
                
            }
            else{
               //handle success response here
                //Fire a notification OR listen to change in db
                //Dismiss controller
                 self.showNoteCreated(title: "Success", message: "Your note has been created!")
                
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
//MARK:- HElper methods
    func validateForm() -> Bool {
        if self.current_location != nil {
            return true
        }
        
        let text = self.txtView_noteText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            return true
        }
        
        return false
    }
    func showNoteCreated(title: String, message: String)  {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
}
