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
        print("view did load")
        print(Array(UserDefaults.standard.dictionaryRepresentation()))
        checkForAutoLogin()
        
        // tap gesture
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(recognizeTapGesture(recognizer:)))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view controller, view will appear, checking for auto login ")
        checkForAutoLogin()
        print(Array(UserDefaults.standard.dictionaryRepresentation()))
    }
    
    // check for auto-login before segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("should perform, autoLogin \(autoLogin)")
        if identifier == "HomeSegue4" {
            if autoLogin {
                print("i should be segueing")
                return true
            } else {
                return false
            }
        } else if identifier == "LoginSegue2" {
            print("loginsegue2")
            return true
        } else if identifier == "CASegueIdentifier" {
            return true
        }
        print("no segue identified")
        return false
    }

    func checkForAutoLogin() {
        do {
            // see if current user is logged in
            let autoLogin1 = userDefaults.bool(forKey: "loggedIn")
            print("autoLogin1 \(autoLogin1)")
            // take user to calendar/home page
            if autoLogin1 {
                print("autoLogin1 is true, segue automatically")
                autoLogin = true
                self.performSegue(withIdentifier: "HomeSegue4", sender: nil)
            } else {
                print("autoLogin1 is false")
//                self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
                autoLogin = false
            }
        }
        // have user log in again
        catch {
            print("autoLogin1 is false in catch statement")
            self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
        }
    }

    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer) {
            self.logoButton.alpha = 1.0
            
            UIView.animate(
                withDuration: 3.0,
                animations: {
                    self.logoButton.alpha = 0.0
                }
            )
            sleep(1)
            
            UIView.animate(
                withDuration: 3.0,
                animations: {
                    self.logoButton.alpha = 1.0
                }
            )

    }
}

