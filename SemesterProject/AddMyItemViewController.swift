//
//  AddMyItemViewController.swift
//  SemesterProject
//
//  Created by Hana Bredstein on 11/28/22.
//

import UIKit

class AddMyItemViewController: UIViewController {

    var delegate1:UIViewController!
    var newDate:MyDate = MyDate()
    
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var addItemLabel: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemName: UITextField!
    
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
    
    @IBAction func changedate(sender: AnyObject) {
        let chosendate = self.DatePicker.date
        newDate.expirationDate = chosendate
    }
    
    @IBAction func newDoneButton(_ sender: Any) {
        if itemName.text == nil {
            let controller = UIAlertController(
                title: "Missing Item Name",
                message:"Please enter an item name.",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
            return
        } else {
            newDate.name = itemName.text
            newDate.expirationDate = self.DatePicker.date
            
            let mainVC = delegate1 as! DateAdder
            mainVC.addDate(added:newDate)
            newDate = MyDate()
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
    
    func updateFontSize(resize: CGFloat) {
        // update bold fonts
        addItemLabel.font = UIFont.boldSystemFont(ofSize: resize*40)
        // update non-bold fonts
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        expireLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*25))
        itemNameLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*25))
        itemName.font = UIFont.boldSystemFont(ofSize: resize*17)

    }
    
    func updateColor() {
            //DatePicker.setTitleColor(currentSettings.colorScheme, for: .normal)
            //DatePicker.textColor = currentSettings.colorScheme
        expireLabel.textColor = currentSettings.colorScheme
        itemNameLabel.textColor = currentSettings.colorScheme
        addItemLabel.textColor = currentSettings.colorScheme
        addButton.setTitleColor(currentSettings.colorScheme, for: .normal)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
