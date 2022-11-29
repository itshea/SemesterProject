//
//  AddListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 11/25/22.
//

import UIKit

class AddListViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var textField: UITextField!
    
    // delegate variable
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addListButtonPressed(_ sender: Any) {
        if (textField.text!.replacingOccurrences(of: " ", with: "") == "") {
            let controller = UIAlertController(
                title: "Missing List Name",
                message: "Please enter a name",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        } else {
            listNames.append(textField.text!)
        }
        
        // reload table via delegate/protocol
        let otherVC = delegate as! ListAdder
        otherVC.addList()
    }

}
