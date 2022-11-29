//
//  AddAllergyViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/25/22.
//

import UIKit

class AddAllergyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var severityPicker: UIPickerView!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    var delegate: AllergiesTableViewController!
    var newAllergy = Allergy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFontSize(resize:currentSettings.fontResize)
        checkDarkMode()
        severityPicker.delegate = self
        severityPicker.dataSource = self
        foodTextField.delegate = self
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allergySeverityLevels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allergySeverityLevels[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newAllergy.severity = allergySeverityLevels[row]
    }
    
    @IBAction func addAllergyButtonPressed(_ sender: Any) {
        // check if a food has been inputted
        if foodTextField.text!.count <= 0 {
            warningLabel.text = "No food inputted"
        } else {
            // save new allergy to allergy list
            newAllergy.foodName = foodTextField.text!
            currentUser.allergyList.append(newAllergy)
            delegate.tableView.reloadData()
            // clear fields for adding a new allergy
            foodTextField.text = ""
            warningLabel.text = ""
            // Core data
        }
    }
    
    func updateFontSize(resize: CGFloat) {
        print("updating font")
//        settingsLabel.font = UIFont.boldSystemFont(ofSize: resize*45)
//        viewProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
//        muteNotificationsLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
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
