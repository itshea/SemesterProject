//
//  AddMyItemViewController.swift
//  SemesterProject
//
//  Created by Hana Bredstein on 11/28/22.
//

import Foundation
import UIKit
import UserNotifications

class AddMyItemViewController: UIViewController {

    var delegate1:UIViewController!
    var newDate:MyDate = MyDate()
    
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var addItemLabel: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemName: UITextField!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestNotificationAuthorization()
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
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()

        // Add the content to the notification content
        notificationContent.title = "Item added"
        notificationContent.body = "You have added \(itemName.text)"
        notificationContent.badge = NSNumber(value: 3)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: "testNotification",
                                                content: notificationContent,
                                                trigger: trigger)
            
        UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
        }
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
            //read in information about item
            newDate.name = itemName.text
            newDate.expirationDate = self.DatePicker.date
            
            //add notification
            let content = UNMutableNotificationContent()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            content.title = "\(newDate.name)"
            content.body = "Your item expires on: \(dateFormatter.string(from: newDate.expirationDate))"
            
            // Configure the recurring date.
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: DatePicker.date)
            let dayOfMonth = components.day
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "MM"
            let monthString = dateFormatter.string(from: DatePicker.date)
            
            dateComponents.day = dayOfMonth // Tuesday
            dateComponents.month = Int(monthString)   // 14:00 hours
               
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: false)
            
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in}
            
            sendNotification()
            //add new item and reset
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
        addItemLabel.font = UIFont(name: "Helvetica-Bold", size: CGFloat(resize*35))
        // update non-bold fonts
        addButton.titleLabel?.font = UIFont(name: "Symbol", size: CGFloat(resize*17))
        expireLabel.font = UIFont(name: "Symbol", size: CGFloat(resize*18))
        itemNameLabel.font = UIFont(name: "Symbol", size: CGFloat(resize*18))
        itemName.font = UIFont(name: "Symbol", size: CGFloat(resize*16))

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
