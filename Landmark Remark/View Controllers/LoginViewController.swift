//
//  LoginViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 11/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBAction func btnSignIn_tapped(_ sender: Any) {
        
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
