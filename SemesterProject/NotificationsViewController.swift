//
//  NotificationsViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 11/29/22.
//

import UIKit
import CoreData

/*
class Notification {
 
    var food: String
 
    init(foodItem:String){
        self.food = foodItem
    }
 
}
*/

let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
let newContext = myAppDelegate.persistentContainer.viewContext



class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let reuseIdentifier = "MyCell"

    // create an array of names of food items
    public var foodItems:[String] = []// [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        coreData()
        tableView.delegate = self
        tableView.dataSource = self
        checkDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coreData()
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
        cell.addButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*17))
        // changes the text based on food item
        cell.foodLabel.text = "Expiring soon: \(self.foodItems[indexPath.row])"
        cell.foodLabel.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*17))
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
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            let toDelete = foodItems.remove(at: indexPath.row)
            foodItems.remove(at: indexPath.row)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyUser")
            var fetchedResults:[NSManagedObject]
            
            do {
                try fetchedResults = newContext.fetch(request) as! [NSManagedObject]
                
                let user = fetchedResults[0]
                currentUser.itemList = user.value(forKey: "itemList") as! [MyDate]
                
                if currentUser.itemList.count > 0 {
                    for foodItem in currentUser.itemList{
                        if foodItem.name == toDelete{
                            if let itemToRemoveIndex = currentUser.itemList.index(of: foodItem) {
                                    currentUser.itemList.remove(at: itemToRemoveIndex)
                                }
                    }
                }
                }
                saveContext()
                
            } catch {
                // if an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

        
            func saveContext () {
                if newContext.hasChanges {
                    do {
                        try newContext.save()
                    } catch {
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
            }

    func coreData() {
        let fetchedResults = retrieveDates()
        
        let user = fetchedResults[0]
        currentUser.itemList = user.value(forKey: "itemList") as! [MyDate]
        
        let today = Date(timeInterval: 0, since: Date())
        
        for NewItem in currentUser.itemList {
            let expDate = NewItem.expirationDate!
            if expDate > today {
                let itemName = NewItem.name as! String
                if foodItems.contains(itemName) == false{
                    foodItems.append(itemName)
                }
            }
        }
    }
    
    func retrieveDates() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyUser")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = newContext.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return(fetchedResults)!
        
    }
}
