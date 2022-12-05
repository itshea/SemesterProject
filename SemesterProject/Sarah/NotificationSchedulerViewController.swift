//
//  NotificationSchedulerViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/27/22.
//

import UIKit

var daysList = Array(1...365)
public var days:Int = currentSettings.daysBeforeNotification

// set date picker initial values 
extension UIDatePicker {
   func setDate(from string: String, format: String, animated: Bool = true) {
      let formater = DateFormatter()
      formater.dateFormat = format
      let date = formater.date(from: string) ?? Date()
      setDate(date, animated: animated)
   }
}

class NotificationSchedulerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var notifyMeLabel: UILabel!
    @IBOutlet weak var notificationDelay: UIPickerView!
    @IBOutlet weak var scheduleInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFontSize(resize:currentSettings.fontResize)
        scheduleInfo.textColor = currentSettings.colorScheme
        checkDarkMode()
        updateColor()
        notificationDelay.delegate = self
        notificationDelay.dataSource = self
        notificationDelay.selectRow(currentSettings.daysBeforeNotification-1, inComponent: 0, animated: true)
        // display scheduling info
        updateScheduleInfo()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return daysList.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(daysList[row])"
        } else {
            return "days"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            days = daysList[row]
            currentSettings.daysBeforeNotification = days
            updateScheduleInfo()
        }
    }
    
    func updateScheduleInfo() {
        scheduleInfo.text = "Notifications will be sent \(currentSettings.daysBeforeNotification) day(s) before an item expires"
    }
    
    func updateColor() {
        scheduleInfo.textColor = currentSettings.colorScheme
    }
    
    func updateFontSize(resize: CGFloat) {
        scheduleInfo.font = UIFont(name: "Symbol", size: resize*15)
        var newSize: Float
        if resize*15 > 20 {
            newSize = 20
        } else {
            newSize = Float(resize*15)
        }
        notifyMeLabel.font = UIFont(name: "Symbol", size: CGFloat(newSize))
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
