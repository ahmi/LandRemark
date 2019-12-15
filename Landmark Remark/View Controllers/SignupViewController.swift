//
//  SignupViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 11/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class SignupViewController: UIViewController {
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfRePassword: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lblError: UILabel!
    var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        self.ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    func setupUIElements() {
        //Hide error label
        lblError.alpha = 0
        
        //Style textfield
        Utilities.styleTextField(tfFirstName)
        Utilities.styleTextField(tfLastName)
        Utilities.styleTextField(tfPassword)
        Utilities.styleTextField(tfEmail)
        Utilities.styleTextField(tfRePassword)
        
        //style button
        Utilities.styleFilledButton(btnSignup)
        
    }
    
    func validateForm() -> String?{
        
        //Check if all fields are filled
        if tfFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfRePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            !Utilities.isValidEmail(emailStr: tfEmail.text!){
            
            return "Please fill all fields with correct data."
        }
        //Check if both password fields match
        if (tfPassword.text != tfRePassword.text) {
            return "Password doesn't match."
        }
        //Check if both password fields match
        if (tfPassword.text!.count < 6) {
            return "Password should be at least 6 characters."
        }
        //Check if password is strong
        let passwordString = tfPassword.text!
        
        if Utilities.isPasswordValid(passwordString) == false {
            return "Please make sure password is 6 characters long, contains a special characters and atleast a number."
        }
        return nil
    }
    
    func showErrorMessage(err: String) {
        lblError.text = err
        lblError.alpha = 1
    }
    
    //MARK: - Button action
    @IBAction func btnSignup_tapped(_ sender: Any) {
        let error = validateForm()
        //self.createUserWithRealTimeDB()
        if error != nil {
            //There is something wrong with input
            showErrorMessage(err: error!)
        } else {
            //Create clean strings from textfields for creating user in database
            let emailString = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = tfFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastNAme = tfLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Call Firebase Create  user method to create a user account
            Auth.auth().createUser(withEmail: emailString, password: tfPassword.text!) { (result, error) in
                
                if result != nil
                {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = firstName + " " + lastNAme
                    changeRequest?.commitChanges { (error) in
                        if error != nil {
                            //there is something wrong with creating data in user
                            self.lblError.text = error!.localizedDescription
                        }
                        else{
                            self.loginWithCredentials()
                        }
                    }
                }else
                {
                    self.lblError.text = error?.localizedDescription
                }
                
            }
        }
    }
    
    func loginWithCredentials()  {
        
        print("Display name:\(Auth.auth().currentUser?.displayName)")
        Auth.auth().signIn(withEmail: self.tfEmail.text!,
                           password: self.tfPassword.text!){(result, Error) in
                            if result != nil{
                                
                                self.transitionToHomeVC()
                            }else{
                                self.lblError.text = Error?.localizedDescription
                            }
        }
    }
    func transitionToHomeVC()  {
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UINavigationController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
}
