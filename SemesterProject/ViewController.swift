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
        print("view controller")
        print(Array(UserDefaults.standard.dictionaryRepresentation()))
        checkForAutoLogin()
        // Do any additional setup after loading the view.
    }
    
    func checkForAutoLogin() {
        do {
            // see if current user is logged in
            let autoLogin = userDefaults.bool(forKey: "loggedIn")
            print("autologin \(autoLogin)")
            
            // take user to calendar/home page
            if autoLogin {
                self.performSegue(withIdentifier: "HomeSegue4", sender: nil)
            } else {
                self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
            }
        }
        // have user log in again
        catch {
            self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
        }
    }

}

