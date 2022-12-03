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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passInput.isSecureTextEntry = true
        
        Auth.auth().addStateDidChangeListener(){
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "CASegueIdentifier", sender: nil)
                self.emailInput.text = nil
                self.passInput.text = nil
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailInput.text!, password: passInput.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
            } else {
                self.errorMessage.text = ""
                self.loadUserDefaults()
            }
        }
    }
    
    func loadUserDefaults() {
        currentSettings.daysBeforeNotification = userDefaults.integer(forKey: "daysBeforeNotification")
        currentSettings.muteNotifications = userDefaults.bool(forKey: "muteNotifications")
        currentSettings.darkMode = userDefaults.bool(forKey: "darkMode")
        currentSettings.color = userDefaults.string(forKey: "color")!
        currentSettings.fontResize = CGFloat(userDefaults.float(forKey: "fontResize"))
        currentSettings.loggedIn = userDefaults.bool(forKey: "loggedIn")
        
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
