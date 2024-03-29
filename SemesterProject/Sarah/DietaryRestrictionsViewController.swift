//
//  DietaryRestrictionsViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/26/22.
//

import UIKit

//public var dietList: [String] = []
public let dietTypes = ["Vegetarian", "Vegan", "Ketogenic", "Paleo", "Mediterranean", "Intermittent Fasting", "Low Carb", "No Sugar", "Raw", "Pescetarian", "Fruitarian"]
//var dietBool = [Int] (repeating: 0, count: dietTypes.count)

class DietaryRestrictionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dietTableView: UITableView!
    private let cellReuseIdentifier = "DietCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDarkMode()
        dietTableView.delegate = self
        dietTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        dietTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dietTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = dietTypes[row]
        cell.textLabel?.font =
        UIFont(name: "Symbol", size: CGFloat(currentSettings.fontResize*17))
        // previously selected rows have checkmarks
        if currentUser.dietBool[row] == 0 {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    // add or remove checkmark when row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dietTableView.deselectRow(at: indexPath, animated: true)
        if let cell = dietTableView.cellForRow(at: indexPath as IndexPath) {
            cell.tintColor = currentSettings.colorScheme
            // remove checkmark
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                let idx = currentUser.dietList.firstIndex(of: (cell.textLabel?.text)!)
                currentUser.dietList.remove(at: idx!)
                currentUser.dietBool[indexPath.row] = 0
            // add checkmark
            } else {
                cell.accessoryType = .checkmark
                currentUser.dietList.append((cell.textLabel?.text)!)
                currentUser.dietBool[indexPath.row] = 1
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
