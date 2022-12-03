//
//  ViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 10/7/22.
//

// The Welcome screen with two segues
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoButton: UIButton!
    var autoLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Array(UserDefaults.standard.dictionaryRepresentation()))
        checkForAutoLogin()
    }
    
    // check for auto-login before segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "HomeSegue4" {
            if autoLogin {
                return true
            } else {
                return false
            }
        } else if identifier == "LoginSegue2" {
            return true
        }
        return false
    }

    func checkForAutoLogin() {
        do {
            // see if current user is logged in
            let autoLogin = userDefaults.bool(forKey: "loggedIn")
            // take user to calendar/home page
            if autoLogin {
                autoLogin = true
//                self.performSegue(withIdentifier: "HomeSegue4", sender: nil)
            } else {
//                self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
                autoLogin = false
            }
        }
        // have user log in again
        catch {
            self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
        }
    }

    @IBAction func fadeOutAndIn(_ sender: Any) {
        self.logoButton.alpha = 1.0
        
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.logoButton.alpha = 0.0
            }
        )
        sleep(2)
        
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.logoButton.alpha = 1.0
            }
        )
    }
}

