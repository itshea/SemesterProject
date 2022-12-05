//
//  NewListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 12/2/22.
//

import UIKit

class NewListViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var newListLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // delegate variable
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDarkMode()
        updateColor()
        updateFontSize(resize:currentSettings.fontResize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        updateFontSize(resize:currentSettings.fontResize)
        updateColor()
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
        else if currentUser.listNames.firstIndex(of: textField.text!) != nil {
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
            currentUser.listNames.append(textField.text!)
            currentUser.items.append([])
            
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
    
    // dark mode settings
    func checkDarkMode() {
        if currentSettings.darkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func updateColor() {
        newListLabel.textColor = currentSettings.colorScheme
        addButton.setTitleColor(currentSettings.colorScheme, for: .normal)
    }
    
    func updateFontSize(resize: CGFloat) {
        newListLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        textField.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
    }
    
}
