//
//  SignUpViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 10/7/22.
//

import UIKit
import FirebaseAuth
import CoreData

let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
let context2 = appDelegate.persistentContainer.viewContext

// protocol for saving core data
protocol DataSaver {
    func saveData()
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var passCon: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    var signUpSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pass.isSecureTextEntry = true
        passCon.isSecureTextEntry = true
        
//        Auth.auth().addStateDidChangeListener(){
//            auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "HomeSegue3", sender: nil)
//                self.email.text = nil
//                self.pass.text = nil
//            }
//        }
        // Do any additional setup after loading the view.
    }

    @IBAction func signupButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.pass.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
            } else {
                self.errorMessage.text = ""
                self.createUser()
                self.setUserDefaults()
                self.signUpSuccess = true
//                self.performSegue(withIdentifier: "HomeSegue3", sender: nil)
            }
        }
    }
    
    // check for successful sign up before segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "HomeSegue3" {
            if signUpSuccess {
                return true
            } else {
                return false
            }
        } else if identifier == "LoginSegueIdentifier" {
            return true
        }
        return false
    }
    
    func createUser() {
        // set up user profile
        currentUser.firstName = firstName.text!
        currentUser.lastName = lastName.text!
        currentUser.email = email.text!
        currentUser.password = pass.text!
        currentUser.profilePicture = defaultProfilePic!
        
        // initial settings
        currentSettings.daysBeforeNotification = 3
        currentSettings.muteNotifications = false
        currentSettings.darkMode = false
        currentSettings.color = "Green"
        currentSettings.fontResize = 1.25
        currentSettings.loggedIn = true
        
        // set up user in Firebase
//        let user = Auth.auth().currentUser
//        let uid = user?.uid
//        let storeData = {firstName: currentUser.firstName, lastName: currentUser.lastName}
    }
    
    func setUserDefaults() {
        // save to User Defaults
        userDefaults.set(currentSettings.daysBeforeNotification, forKey: "daysBeforeNotification")
        userDefaults.set(currentSettings.muteNotifications, forKey: "muteNotifications")
        userDefaults.set(currentSettings.darkMode, forKey: "darkMode")
        userDefaults.set(currentSettings.color, forKey: "color")
        userDefaults.set(currentSettings.fontResize, forKey: "fontResize")
        userDefaults.set(currentSettings.loggedIn, forKey: "loggedIn")
        userDefaults.set(currentUser.firstName, forKey: "firstName")
        userDefaults.set(currentUser.lastName, forKey: "lastName")
    }
    
    // save to core data
    func saveCoreData() {
        let user = NSEntityDescription.insertNewObject(forEntityName: "MyUser", into: context)
        
        user.setValue(currentUser.email, forKey: "email")
        user.setValue(currentUser.allergyList, forKey: "allergy")
        user.setValue(currentUser.dietList, forKey: "dietList")
        user.setValue(currentUser.listNames, forKey: "listNames")
        user.setValue(currentUser.items, forKey: "items")
        
        saveContext()
        
    }
    
    // repopulate with fetched core data
    func loadCoreData() {
        let fetchedResults = retrieveCoreData()
        
        let user = fetchedResults[0]
        
        currentUser.email = user.value(forKey: "email") as! String
        currentUser.allergyList = user.value(forKey: "allergyList") as! [Allergy]
        currentUser.dietList = user.value(forKey: "dietList") as! [String]
        currentUser.listNames = user.value(forKey: "listNames") as! [String]
        currentUser.items = user.value(forKey: "items") as! [[String]]
        currentUser.itemList = user.value(forKey: "itemList") as! [MyDate]
    }
    
    // retrieve core data
    func retrieveCoreData() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyUser")
        var fetchedResults:[NSManagedObject]? = nil
                
        // let predicate = NSPredicate(format: "name CONTAINS[c] 'ie'")
        // request.predicate = predicate
                
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

    // clear core data if needed
    func clearCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pisa")
        var fetchedResults:[NSManagedObject]
                    
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
                        
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
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

    // save context
    func saveContext () {
        if context2.hasChanges {
            do {
                try context2.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
