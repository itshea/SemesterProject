//
//  ChangePasswordViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/27/22.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterPassLabel: UILabel!
    @IBOutlet weak var enterPassLabel2: UILabel!
    @IBOutlet weak var enterPassLabel3: UILabel!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword1: UITextField!
    @IBOutlet weak var newPassword2: UITextField!
    @IBOutlet weak var changePasswordPressed: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFontSize(resize:currentSettings.fontResize)
        warningLabel.textColor = currentSettings.colorScheme
        checkDarkMode()
        oldPassword.isSecureTextEntry = true
        newPassword1.isSecureTextEntry = true
        newPassword2.isSecureTextEntry = true
        oldPassword.delegate = self
        newPassword1.delegate = self
        newPassword2.delegate = self
        warningLabel.textColor = currentSettings.colorScheme
    }
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveNewPassword(_ sender: Any) {
        if checkOldPassword() && checkNewPassword() && verifyPassword() {
            warningLabel.text = "Password changed successfully"
            currentUser.password = newPassword1.text!
            oldPassword.text = ""
            newPassword1.text = ""
            newPassword2.text = ""
        }
    }
    
    func checkOldPassword() -> Bool {
        if oldPassword.text == currentUser.password {
            return true
        } else {
            warningLabel.text = "Incorrect password"
            return false
        }
    }
    
    func checkNewPassword() -> Bool {
        if verifyPassword() {
            if newPassword1.text == newPassword2.text {
                return true
            } else {
                warningLabel.text = "Passwords do not match"
                return false
            }
        } else {
            warningLabel.text = "New password must be at least 6 characters"
            return false
        }
    }
    
    // password must be at least 6 characters long
    func verifyPassword() -> Bool {
        if newPassword1.text!.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    func updateFontSize(resize: CGFloat) {
        enterPassLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        enterPassLabel2.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        enterPassLabel3.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        oldPassword.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        newPassword1.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        newPassword2.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        // change button size
//        changePasswordPressed.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
//        changePasswordPressed.titleLabel?.numberOfLines = 1
//        changePasswordPressed.titleLabel?.adjustsFontSizeToFitWidth = true
//        changePasswordPressed.titleLabel?.lineBreakMode = .byClipping
        warningLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
    }
    
    // dark mode settings
    func checkDarkMode() {
        if currentSettings.darkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
}
