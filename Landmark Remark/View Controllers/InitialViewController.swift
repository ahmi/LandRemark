//
//  InitialViewController.swift
//  Landmark Remark
//
//  Created by Ahmad Waqas on 11/12/19.
//  Copyright © 2019 Ahmad Waqas. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class InitialViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        guard let user = Auth.auth().currentUser else {return}
        self.transitionToHomeVC()
    }
    
    //Set home VC as root controller unless user logs out
    func transitionToHomeVC()  {
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UINavigationController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
    func setupUIElements() {
        //style button
        Utilities.styleFilledButton(btnSignup)
        Utilities.styleHollowButton(btnLogin)
    }
    
}
