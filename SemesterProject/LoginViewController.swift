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
            }
        }
            }
}
