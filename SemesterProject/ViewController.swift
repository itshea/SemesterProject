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

