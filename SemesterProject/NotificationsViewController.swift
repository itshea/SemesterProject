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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTableViewCell
        
        // changes the text based on food item
        cell.foodLabel.text = "Your \(self.foodItems[indexPath.row]) is/are about to expire."
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
