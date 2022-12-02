//
//  ViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 10/7/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForAutoLogin()
        // Do any additional setup after loading the view.
    }
    
    func checkForAutoLogin() {
        do {
            // see if current user is logged in
            let autoLogin = try userDefaults.bool(forKey: "loggedIn")
            
            // take user to calendar/home page
            if autoLogin {
                self.performSegue(withIdentifier: "CASegueIdentifier", sender: nil)
            }
        }
        // have user log in again
        catch {
            self.performSegue(withIdentifier: "LoginSegueIdentifier", sender: nil)
        }
    }

}

