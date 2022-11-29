//
//  NotificationSchedulerViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/27/22.
//

import UIKit

var daysList = Array(1...365)

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
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var notificationTime: UIDatePicker!
    @IBOutlet weak var notificationDelay: UIPickerView!
    @IBOutlet weak var scheduleInfo: UILabel!
    var days:Int = currentSettings.daysBeforeNotification
    var time:String = currentSettings.notificationTime
    var schedule:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFontSize(resize:currentSettings.fontResize)
        checkDarkMode()
        notificationDelay.delegate = self
        notificationDelay.dataSource = self
        // add event to date picker to update scheduling info when value is changed
        notificationTime.addTarget(self, action: #selector(NotificationSchedulerViewController.datePickerValueChanged(_:)), for: .valueChanged)
        updateScheduleInfo()
        // set both pickers to original user settings
        notificationTime.setDate(from: currentSettings.notificationTime, format: "h:mm a")
        notificationDelay.selectRow(currentSettings.daysBeforeNotification-1, inComponent: 0, animated: true)
        // display scheduling info
        schedule = "Notifications will be sent \(days) days(s) before an item expires at \(time)"
        updateScheduleInfo()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "h:mm a"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        time = "\(selectedDate)"
        currentSettings.notificationTime = time
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
        schedule = "Notifications will be sent \(currentSettings.daysBeforeNotification) days(s) before an item expires at \(currentSettings.notificationTime)"
        scheduleInfo.text = schedule
    }
    
    func updateFontSize(resize: CGFloat) {
        scheduleInfo.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        var newSize: Float
        if resize*17 > 22 {
            newSize = 22
        } else {
            newSize = Float(resize*17)
        }
        notifyMeLabel.font = UIFont.systemFont(ofSize: CGFloat(newSize))
        notificationTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(newSize))

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
