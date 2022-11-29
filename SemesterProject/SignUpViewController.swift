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
        
        Auth.auth().addStateDidChangeListener(){
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "LoginSegueIdentifier", sender: nil)
                self.email.text = nil
                self.pass.text = nil
            }
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signupButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.pass.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
            } else {
                self.errorMessage.text = ""
            }
        }
    }
}
