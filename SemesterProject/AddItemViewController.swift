//
//  AddIItemViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 11/25/22.
//

import UIKit

class AddItemViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var textField: UITextField!
    
    // variables
    var delegate: UIViewController!
    var itemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
        if (textField.text!.replacingOccurrences(of: " ", with: "") == "") {
            let controller = UIAlertController(
                title: "Missing Item Name",
                message: "Please enter an item",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        } else {
            items[itemIndex].append(textField.text!)
        }
        
        // reload table via delegate/protocol
        let otherVC = delegate as! ItemAdder
        otherVC.addItem()
    }

}
