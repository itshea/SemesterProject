//
//  CalendarViewController.swift
//  SemesterProject
//
//  Created by Hana Bredstein on 11/28/22.
//

import UIKit
import CoreData
import SwiftUI

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol DateAdder {
    func addDate (added: MyDate)
}

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DateAdder {
    
    public var dateList:[MyDate] = []
    var todayList:[MyDate] = []
    let textCellIdentifier = "dateIdentifier"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectDate: UIDatePicker!
    @IBOutlet weak var addItem: UIButton!
    @IBOutlet weak var pastOrderTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date(timeInterval: 0, since: Date())
        let month = Calendar.current.component(.month, from: today)
        let day = Calendar.current.component(.day, from: today)
        let year = Calendar.current.component(.year, from: today)
        dateLabel.text = "\(month)/\(day)/\(year)"
        checkDarkMode()
        updateFontSize(resize:currentSettings.fontResize)
        updateNavBar()
        updateColor()
        pastOrderTable.register(MyCalendarTableViewCell.self, forCellReuseIdentifier: "dateIdentifier")
        pastOrderTable.delegate = self
        pastOrderTable.dataSource = self
    
        coreData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        updateFontSize(resize:currentSettings.fontResize)
        updateNavBar()
        updateColor()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        populateToday()
        return todayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*17))
        let row = indexPath.row
        let newDate = todayList[row]
    
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.text = "Expiring soon: \(newDate.name!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = dateList.remove(at: indexPath.row)
            pastOrderTable.deleteRows(at: [indexPath], with: .fade)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewItem")
            var fetchedResults:[NSManagedObject]
            
            do {
                try fetchedResults = context.fetch(request) as! [NSManagedObject]
                
                if fetchedResults.count > 0 {
                    for result:AnyObject in fetchedResults {
                        if result.name == toDelete.name{
                            context.delete(result as! NSManagedObject)
                        }
                    }
                }
                saveContext()
                
            } catch {
                // if an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyDateSegue",
           let nextVC = segue.destination as? AddMyItemViewController{
            nextVC.delegate1 = self
        }
    }
    
    func updateNavBar() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: currentSettings.colorScheme,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: currentSettings.fontResize*17)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController!.navigationBar.tintColor = currentSettings.colorScheme
    }

    
    func checkDarkMode() {
        if currentSettings.darkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func updateFontSize(resize: CGFloat) {
            // update bold fonts
            dateLabel.font = UIFont.boldSystemFont(ofSize: resize*45)
            // update non-bold fonts
            addItem.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
    }
    
    func updateColor() {
        dateLabel.textColor = currentSettings.colorScheme
        addItem.setTitleColor(currentSettings.colorScheme, for: .normal)
    }

    func coreData() {
        let fetchedResults = retrieveDates()
        
        for NewItem in fetchedResults {
            let thisDate = MyDate()
            thisDate.name = NewItem.value(forKey: "name") as! String
            thisDate.expirationDate = NewItem.value(forKey: "expirationDate") as! Date
            thisDate.dateID = NewItem.objectID
            dateList.append(thisDate)
            }
    }
    
    @IBAction func changedate(sender: AnyObject) {
        let chosendate = self.selectDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/YYYY"
        dateLabel.text = "\(dateFormatter.string(from: chosendate))"
        populateToday()
        self.pastOrderTable.reloadData()
    }
    
    func addDate(added: MyDate) {
        dateList.append(added)
        self.pastOrderTable.reloadData()
        
        let storedDate = NSEntityDescription.insertNewObject(forEntityName: "NewItem", into: context)
        
        storedDate.setValue(added.name, forKey: "name")
        storedDate.setValue(added.expirationDate, forKey: "expirationDate")
        
        // commit the changes
        saveContext()
        
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieveDates() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewItem")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return(fetchedResults)!
        
    }
    
    func populateToday() {
        todayList = []
        for myItem in dateList{
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd/MM/YY"
            if dateFormatter1.string(from: self.selectDate.date) == dateFormatter1.string(from: myItem.expirationDate){
                todayList.append(myItem)
            }
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
}
