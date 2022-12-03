//
//  SignUpViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 10/7/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var passCon: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pass.isSecureTextEntry = true
        passCon.isSecureTextEntry = true
        
//        Auth.auth().addStateDidChangeListener(){
//            auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "HomeSegue3", sender: nil)
//                self.email.text = nil
//                self.pass.text = nil
//            }
//        }
        // Do any additional setup after loading the view.
    }

    @IBAction func signupButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.pass.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
            } else {
                self.errorMessage.text = ""
                self.createUser()
                self.setUserDefaults()
                self.performSegue(withIdentifier: "HomeSegue3", sender: nil)
            }
        }
    }
    
    func createUser() {
        // set up user profile
        currentUser.firstName = firstName.text!
        currentUser.lastName = lastName.text!
        currentUser.email = email.text!
        currentUser.password = pass.text!
        currentUser.profilePicture = defaultProfilePic!
        
        // initial settings
        currentSettings.daysBeforeNotification = 3
        currentSettings.muteNotifications = false
        currentSettings.darkMode = false
        currentSettings.color = "Green"
        currentSettings.fontResize = 1.25
        currentSettings.loggedIn = true
        
        // set up user in Firebase
//        let user = Auth.auth().currentUser
//        let uid = user?.uid
//        let storeData = {firstName: currentUser.firstName, lastName: currentUser.lastName}
    }
    
    func setUserDefaults() {
        // save to User Defaults
        userDefaults.set(currentSettings.daysBeforeNotification, forKey: "daysBeforeNotification")
        userDefaults.set(currentSettings.muteNotifications, forKey: "muteNotifications")
        userDefaults.set(currentSettings.darkMode, forKey: "darkMode")
        userDefaults.set(currentSettings.color, forKey: "color")
        userDefaults.set(currentSettings.fontResize, forKey: "fontResize")
        userDefaults.set(currentSettings.loggedIn, forKey: "loggedIn")
        userDefaults.set(currentUser.firstName, forKey: "firstName")
        userDefaults.set(currentUser.lastName, forKey: "lastName")
    }
    
}
