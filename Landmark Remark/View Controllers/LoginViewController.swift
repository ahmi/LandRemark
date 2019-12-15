//
//  LoginViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 11/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        
        // Do any additional setup after loading the view.
    }
    func setupUIElements() {
        //Hide error label
        lblError.alpha = 0
        //Style textfield
        Utilities.styleTextField(tfPassword)
        Utilities.styleTextField(tfUserName)
        //style button
        Utilities.styleFilledButton(btnSignin) 
    }
    //MARK:- Button action
    @IBAction func btnSignIn_tapped(_ sender: Any) {
        let error = validateForm()
        if error != nil {
            //There is something wrong with input
            showErrorMessage(err: error!)
        } else {
            //Create clean strings from textfields for creating user in database
            let emailString = tfUserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //show activity indicator
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.darkGray.withAlphaComponent(0.5))
            Auth.auth().signIn(withEmail: emailString, password: password) { (result, error) in
                self.view.activityStopAnimating()
                if error != nil  {
                    self.lblError.text = error?.localizedDescription
                } else {
                    self.transitionToHomeVC()
                }
            }
            
        }
    }
    //MARK:- Helper Funcs
    func validateForm() -> String?{
        
        //Check if all fields are filled
        if tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            !Utilities.isValidEmail(emailStr: tfUserName.text!){
            
            return "Please fill all fields with correct data."
        }
        return nil
    }
    func showErrorMessage(err: String) {
        lblError.text = err
        lblError.alpha = 1
    }
    func transitionToHomeVC()  {
        //set map screen as root view controller, purge login, signup, home screens from memory
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UINavigationController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    //MARK: - Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
