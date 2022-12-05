//
//  ChangePasswordViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/27/22.
//
import UIKit
import FirebaseAuth

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
        updateColor()
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
        if checkOldPassword() && checkNewPassword() {
            updatePassword()
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
    
    // check if new password and re-entered password match
    func checkNewPassword() -> Bool {
        if newPassword1.text == newPassword2.text {
            return true
        } else {
            warningLabel.text = "Passwords do not match"
            return false
        }
    }
    
    // set new password in Firebase
    func updatePassword() -> Bool {
        ((Auth.auth().currentUser?.updatePassword(to: newPassword1.text!) {
            error in
            if let error = error as NSError? {
                self.warningLabel.text = "\(error.localizedDescription)"
            } else {
                self.warningLabel.text = "Password changed successfully"
                currentUser.password = self.newPassword1.text!
                self.oldPassword.text = ""
                self.newPassword1.text = ""
                self.newPassword2.text = ""
            }
        }) != nil)
    }
    
    func updateFontSize(resize: CGFloat) {
        enterPassLabel.font = UIFont(name: "Symbol", size: resize*18)
        enterPassLabel2.font = UIFont(name: "Symbol", size: resize*18)
        enterPassLabel3.font = UIFont(name: "Symbol", size: resize*18)
        oldPassword.font = UIFont(name: "Symbol", size: resize*16)
        newPassword1.font = UIFont(name: "Symbol", size: resize*16)
        newPassword2.font = UIFont(name: "Symbol", size: resize*16)
        changePasswordPressed.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: resize*20)
        warningLabel.font = UIFont(name: "Symbol", size: resize*16)
    }
    
    func updateColor() {
        changePasswordPressed.setTitleColor(currentSettings.colorScheme, for: .normal)
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
