//
//  NewListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 12/2/22.
//

import UIKit

class NewListViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var textField: UITextField!
    
    // delegate variable
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // add list
    @IBAction func addListButtonPressed(_ sender: Any) {
        // blank
        if (textField.text!.replacingOccurrences(of: " ", with: "") == "") {
            // alert
            let controller = UIAlertController(
                title: "Missing list name",
                message: "Please enter a name",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        }
        // list already exists
        else if listNames.firstIndex(of: textField.text!) != nil {
            // alert
            let controller = UIAlertController(
                title: "List already exists",
                message: "Please enter a new list name",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        } else {
            listNames.append(textField.text!)
            items.append([])
            
            // reload table via delegate/protocol
            let otherVC = delegate as! ListAdder
            otherVC.addList()
            
            // automatically go back
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
