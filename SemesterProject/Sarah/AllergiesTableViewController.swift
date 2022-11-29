//
//  AllergiesTableViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/11/22.
//

import UIKit

//public var allergyList:[Allergy] = []
public let allergySeverityLevels = ["Mild", "Moderate", "Severe"]

public struct Allergy {
    var foodName = ""
    var severity = allergySeverityLevels[0]
}

class AllergiesTableViewController: UITableViewController {
    
    @IBOutlet weak var allergiesNavBar: UINavigationItem!
    private let cellReuseIdentifier = "AllergyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDarkMode()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.allergyList.count
    }
    
    // create cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell:AllergiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! AllergiesTableViewCell
        let tempCell = currentUser.allergyList[row]
        cell.foodLabel?.text = tempCell.foodName
        cell.allergySeverityLabel?.text = tempCell.severity
        // resize
        cell.foodLabel.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*17))
        cell.allergySeverityLabel.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*17))
        // change text color based on severity level
        if tempCell.severity == "Mild" {
            cell.allergySeverityLabel.textColor = greenColor
        } else if tempCell.severity == "Moderate" {
            cell.allergySeverityLabel.textColor = orangeColor
        } else {
            cell.allergySeverityLabel.textColor = redColor
        }
        return cell
    }
    
    // Add an allergy to the list
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAllergySegue" {
            let nextVC = segue.destination as! AddAllergyViewController
            nextVC.delegate = self
        }
    }
    
    // swipe to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeAllergy = currentUser.allergyList[indexPath.row]
            currentUser.allergyList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // remove from Core Data
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PizzaInfo")
//            var fetchedResults:[NSManagedObject]
//
//            let predicate1 = NSPredicate(format: "crust == %@", "\(removePizza.crust)")
//            let predicate2 = NSPredicate(format: "#size == %@", "\(removePizza.size)")
//            let predicate3 = NSPredicate(format: "cheese == %@", "\(removePizza.cheese)")
//            let predicate4 = NSPredicate(format: "meat == %@", "\(removePizza.meat)")
//            let predicate5 = NSPredicate(format: "veggies == %@", "\(removePizza.veggies)")
//            let predicate:NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2,predicate3,predicate4,predicate5])
//            request.predicate = predicate
//
//            do {
//                try fetchedResults = context.fetch(request) as! [NSManagedObject]
//
//                if fetchedResults.count > 0 {
//                    for result:AnyObject in fetchedResults {
//                        context.delete(result as! NSManagedObject)
//                        print("This pizza has been deleted")
//                    }
//                }
//                saveContext()
//            } catch {
//                // if an error occurs
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
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
