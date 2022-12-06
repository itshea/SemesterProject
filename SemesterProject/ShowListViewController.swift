//
//  ShowListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 12/2/22.
//

import UIKit

class ShowListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // IB outlets
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    // variables
    var delegate:UIViewController!
    var listName:String = ""
    var listIndex:Int = 0
    let textCellID = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNameLabel.text = listName
        listIndex = currentUser.listNames.firstIndex(of: listNameLabel.text!) ?? 0
        addButton.layer.cornerRadius = 20
        listTableView.delegate = self
        listTableView.dataSource = self
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
        listNameLabel.textColor = currentSettings.colorScheme
        addButton.setTitleColor(currentSettings.colorScheme, for: .normal)
    }
    
    func updateFontSize(resize: CGFloat) {
        listNameLabel.font = UIFont(name: "Helvetica-Bold", size: CGFloat(resize*20))
        addButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: CGFloat(resize*17))

    }
    
    // rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.items[listIndex].count
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = listTableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath)
//        cell.textLabel?.textColor = currentSettings.colorScheme
        cell.textLabel?.font = UIFont(name: "Symbol", size: CGFloat(currentSettings.fontResize*17))
        cell.textLabel?.text = currentUser.items[listIndex][row]
        cell.tintColor = currentSettings.colorScheme
        return cell
    }
    
    // delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            currentUser.items[listIndex].remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    // puts checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = listTableView.cellForRow(at: indexPath as IndexPath) {
            cell.tintColor = currentSettings.colorScheme
            
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    // add item segue
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddListItemSegue",
           let nextVC = segue.destination as? ListItemViewController {
            nextVC.delegate = self
            nextVC.listKey = listNameLabel.text!
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
