//
//  NotificationsViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 11/29/22.
//

import UIKit



/*class Notification {

    var food: String

    

    init(foodItem:String){

        self.food = foodItem

    }

    

}

*/



class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let reuseIdentifier = "MyCell"

    // create an array of names of food items
    public var foodItems = ["apples", "oranges", "pork", "broccoli", "mozzarella cheese", "wheat bread", "milk", "potatos", "creamer", "orange juice", "cheerios"]// [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        checkDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        tableView.reloadData()
    }
    
    // dark mode settings
    func checkDarkMode() {
        if currentSettings.darkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTableViewCell
        cell.addButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        cell.addButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*20))
        // changes the text based on food item
        cell.foodLabel.text = "Expiring soon: \(self.foodItems[indexPath.row])"
        cell.foodLabel.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*20))
        return cell
    }

    // set height of table cell to 90
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            foodItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
