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

    @IBAction func fadeOut(_ sender: Any) {
        self.logoButton.alpha = 1.0
        
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.logoButton.alpha = 0.0
            }
        )
    }
}

