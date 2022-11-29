//
//  SettingsViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 10/14/22.
//

import UIKit

public struct Settings {
    var daysBeforeNotification = 3
    var notificationTime = "8:00 AM"
    var muteNotifications = false
    var darkMode = false
    var colorScheme = greenColor
    var color = "Green"
    var fontResize: CGFloat = 1.5
}

public var currentSettings = Settings()
public var greenColor = UIColor(red: 32/255, green: 159/255, blue: 93/255, alpha: 1.0)
public var blueColor = UIColor(red: 72/255, green: 162/255, blue: 226/255, alpha: 1.0)
public var redColor = UIColor(red: 226/255, green: 81/255, blue: 93/255, alpha: 1.0)

class SettingsViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var muteNotificationsLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var muteNotificationsSwitch: UISwitch!
    @IBOutlet weak var colorSchemeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var colorSchemeLabel: UILabel!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDarkMode()
        updateColor()
        updateFontSize(resize:currentSettings.fontResize)
        
        // set initial switch/slider values
        darkModeSwitch.isOn = currentSettings.darkMode
        muteNotificationsSwitch.isOn = currentSettings.muteNotifications
        fontSizeSlider.setValue(Float(currentSettings.fontResize), animated: true)
        // add functions to switches
        darkModeSwitch.addTarget(self, action: #selector(SettingsViewController.darkModeSwitchIsChanged(mySwitch:)), for: .valueChanged)
        muteNotificationsSwitch.addTarget(self, action: #selector(SettingsViewController.muteSwitchIsChanged(mySwitch:)), for: .valueChanged)
        
        // create menus for buttons
        colorSchemeButton.setTitle("Choose Color", for: .normal)
        colorSchemeButton.showsMenuAsPrimaryAction = true
        var greenState:UIMenuElement.State = .off
        var blueState:UIMenuElement.State = .off
        var redState:UIMenuElement.State = .off
        if currentSettings.color == "Green" {
            greenState = .on
        } else if currentSettings.color == "Blue" {
            blueState = .on
        } else {
            redState = .on
        }
        let green = UIAction(title: "Green", state: greenState) { action in
            currentSettings.colorScheme = greenColor
            currentSettings.color = "Green"
            self.updateColor()
        }
        let blue = UIAction(title: "Blue", state: blueState) { action in
            currentSettings.colorScheme = blueColor
            currentSettings.color = "Blue"
            self.updateColor()
        }
        let red = UIAction(title: "Red", state: redState) { action in
            currentSettings.colorScheme = redColor
            currentSettings.color = "Red"
            self.updateColor()
        }
        let colorMenu = UIMenu(title: "Choose a Color", children: [red, blue, green])
        colorSchemeButton.menu = colorMenu

    }
    
    func updateColor() {
        colorSchemeButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        settingsLabel.textColor = currentSettings.colorScheme
        profileLabel.textColor = currentSettings.colorScheme
        notificationsLabel.textColor = currentSettings.colorScheme
        displayLabel.textColor = currentSettings.colorScheme
        muteNotificationsSwitch.onTintColor = currentSettings.colorScheme
        darkModeSwitch.onTintColor = currentSettings.colorScheme
        fontSizeSlider.minimumTrackTintColor = currentSettings.colorScheme
    }
    
    @objc func darkModeSwitchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            currentSettings.darkMode = true
            overrideUserInterfaceStyle = .dark
        } else {
            currentSettings.darkMode = false
            overrideUserInterfaceStyle = .light
        }
    }
    
    @objc func muteSwitchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            currentSettings.muteNotifications = true
        } else {
            currentSettings.muteNotifications = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProfileSegue" {
            let nextVC = segue.destination as! UserProfileNavigationController
        }
        if segue.identifier == "PasswordSegue" {
            let nextVC = segue.destination as! ChangePasswordViewController
        }
        if segue.identifier == "NotificationSchedulerSegue" {
            let nextVC = segue.destination as! NotificationSchedulerViewController
        }
    }
    
    @IBAction func fontSizeChanged(_ sender: Any) {
        let resizeValue:CGFloat = CGFloat(self.fontSizeSlider.value)
        currentSettings.fontResize = resizeValue
        updateFontSize(resize: resizeValue)
    }
    
    func updateFontSize(resize: CGFloat) {
        // set bold fonts
        settingsLabel.font = UIFont.boldSystemFont(ofSize: resize*45)
        profileLabel.font = UIFont.boldSystemFont(ofSize: resize*20)
        notificationsLabel.font = UIFont.boldSystemFont(ofSize: resize*20)
        displayLabel.font = UIFont.boldSystemFont(ofSize: resize*20)
        // set non-bold fonts
        viewProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        changePassButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        muteNotificationsLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        notificationButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        darkModeLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        colorSchemeLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        fontSizeLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        colorSchemeButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
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
