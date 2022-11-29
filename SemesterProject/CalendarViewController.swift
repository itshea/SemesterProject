//
//  CalendarViewController.swift
//  SemesterProject
//
//  Created by Hana Bredstein on 11/28/22.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol DateAdder {
    func addDate (added: MyDate)
}

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DateAdder {
    
    var dateList:[MyDate] = []
    let textCellIdentifier = "dateIdentifier"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectDate: UIDatePicker!
    @IBOutlet weak var itemVIew: UITableView!
    @IBOutlet weak var addItem: UIButton!
    @IBOutlet weak var pastOrderTable: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date(timeInterval: 0, since: Date())
        let month = Calendar.current.component(.month, from: today)
        let day = Calendar.current.component(.day, from: today)
        dateLabel.text = "\(day) \(month)"
        checkDarkMode()
        updateColor()
        updateFontSize(resize:currentSettings.fontResize)
        updateNavBar()
        pastOrderTable.delegate = self
        pastOrderTable.dataSource = self
    
        coreData()


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = indexPath.row
        let newDate = dateList[row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.text = "\(newDate.name!)"
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
                        if result.objectID == toDelete.dateID{
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
           let nextVC = segue.destination as? AddItemViewController{
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
    
    func updateColor() {
            dateLabel.setTitleColor(currentSettings.colorScheme, for: .normal)
            addItem.textColor = currentSettings.colorScheme
        }

    
    func updateFontSize(resize: CGFloat) {
            // update bold fonts
            dateLabel.font = UIFont.boldSystemFont(ofSize: resize*20)
            addItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: resize*20)
            // update non-bold fonts
            dateLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
            addItem.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
    }

    
    func coreData() {
        let fetchedResults = retrieveDates()
        
        for NewItem in fetchedResults {
            let thisDate = MyDate()
            thisDate.name = NewItem.value(forKey: "name") as! String
            thisDate.date = NewItem.value(forKey: "date") as! Date
            thisDate.dateID = NewItem.objectID
            dateList.append(thisDate)
            }
    }
    
    @IBAction func changedate(sender: AnyObject) {
        let chosendate = self.selectDate.date
        dateLabel.text = "\(chosendate)"

    }
    
    func addDate(added: MyDate) {
        dateList.append(added)
        self.pastOrderTable.reloadData()
        
        let storedDate = NSEntityDescription.insertNewObject(forEntityName: "NewItem", into: context)
        
        storedDate.setValue(added.name, forKey: "name")
        storedDate.setValue(added.date, forKey: "date")
        storedDate.setValue(added.dateID, forKey: "dateID")
        
        // commit the changes
        saveContext()    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
