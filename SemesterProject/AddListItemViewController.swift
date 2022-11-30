//
//  AddListItemViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 11/30/22.
//

import UIKit

class AddListItemViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var textField: UITextField!
    
    // variables
    var delegate: UIViewController!
    var listKey:String = ""
    var itemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // blank
        if (textField.text!.replacingOccurrences(of: " ", with: "") == "") {
            let controller = UIAlertController(
                title: "Missing item name",
                message: "Please enter an item",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        }
        // item already exists
        else if items[itemIndex].firstIndex(of: textField.text!) != nil {
            // alert
            let controller = UIAlertController(
                title: "Item already exists",
                message: "Please enter a new item",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        } else {
            items[itemIndex].append(textField.text!)
            
            // reload table via delegate/protocol
            let otherVC = delegate as! ItemAdder
            otherVC.addItem(name: listKey, index: itemIndex)
            
            // automatically go back
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
