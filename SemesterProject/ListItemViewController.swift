//
//  ListItemViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 12/2/22.
//

import UIKit

class ListItemViewController: UIViewController {
    // IB outlets
    @IBOutlet weak var newItemLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // variables
    var delegate: ShowListViewController!
    var listKey:String = ""
    var itemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemIndex = listNames.firstIndex(of: listKey) ?? 0
        checkDarkMode()
        updateColor()
        updateFontSize(resize:currentSettings.fontResize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        updateFontSize(resize:currentSettings.fontResize)
        updateColor()
    }
    
    func updateColor() {
        newItemLabel.textColor = currentSettings.colorScheme
        addButton.setTitleColor(currentSettings.colorScheme, for: .normal)
    }
    
    func updateFontSize(resize: CGFloat) {
        newItemLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        textField.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
    }
    
    // add item
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
            
            // reload table via delegate
            delegate.listTableView.reloadData()
            
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
    
}
