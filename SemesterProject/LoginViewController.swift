//
//  LoginViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 10/7/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passInput: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    var loginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passInput.isSecureTextEntry = true
        
//        Auth.auth().addStateDidChangeListener(){
//            auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "HomeSegueIdentifier2", sender: self)
//                self.emailInput.text = nil
//                self.passInput.text = nil
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
//        if shouldPerformSegue(withIdentifier: "HomeSegueIdentifier2", sender: AnyObject?) {
//            self.performSegue(withIdentifier: "HomeSegueIdentifier2", sender: nil)
//        }
        print("login button pressed")
        Auth.auth().signIn(withEmail: emailInput.text!, password: passInput.text!) {
            authResult, error in
            if let error = error as NSError? {
                print("errors")
                self.errorMessage.text = "\(error.localizedDescription)"
                self.loginSuccess = false
            } else {
                print("no errors")
                self.errorMessage.text = ""
                self.loginSuccess = true
                self.performSegue(withIdentifier: "HomeSegueIdentifier2", sender: nil)
                self.loadUserDefaults()
                self.setUpUser()
            }
        }
    }
    
    func setUpUser() {
//        currentUser.firstName = "\(firstName.text)"
//        currentUser.lastName = "\(lastName.text)"
        currentUser.email = emailInput.text!
        currentUser.password = passInput.text!
    }
    
    // check for credentials before segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("check if segue valid")
        if identifier == "HomeSegueIdentifier2" {
            if loginSuccess {
                return true
            } else {
                return false
            }
        } else if identifier == "CreateAccountSegue" {
            return true
        }
        return false
    }
    
    func loadUserDefaults() {
        currentSettings.daysBeforeNotification = userDefaults.integer(forKey: "daysBeforeNotification")
        currentSettings.muteNotifications = userDefaults.bool(forKey: "muteNotifications")
        currentSettings.darkMode = userDefaults.bool(forKey: "darkMode")
        currentSettings.color = userDefaults.string(forKey: "color")!
        currentSettings.fontResize = CGFloat(userDefaults.float(forKey: "fontResize"))
        currentSettings.loggedIn = userDefaults.bool(forKey: "loggedIn")
        currentUser.firstName = userDefaults.string(forKey: "firstName")!
        currentUser.lastName = userDefaults.string(forKey: "lastName")!
        
        // determine color scheme
        if currentSettings.color == "Red" {
            currentSettings.colorScheme = redColor
        } else if currentSettings.color == "Orange" {
            currentSettings.colorScheme = orangeColor
        } else if currentSettings.color == "Yellow" {
            currentSettings.colorScheme = yellowColor
        } else if currentSettings.color == "Green" {
            currentSettings.colorScheme = greenColor
        } else if currentSettings.color == "Blue" {
            currentSettings.colorScheme = blueColor
        } else {
            currentSettings.colorScheme = purpleColor
        }
    }
}
