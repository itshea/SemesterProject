//
//  AddItemViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 11/28/22.
//

import UIKit

var itemsDict:[String: [String]] = [:]

class AddItemViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var textField: UITextField!
    
    // variables
    var delegate: UIViewController!
    var listKey:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
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
        else if itemsDict[listKey]?.firstIndex(of: textField.text!) != nil {
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
            if var arr = itemsDict[listKey] {
                arr.append(textField.text!)
                itemsDict[listKey] = arr
            }
            
            // reload table via delegate/protocol
            let otherVC = delegate as! ItemAdder
            otherVC.addItem()
            
            // automatically go back
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
