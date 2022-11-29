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
    var colorScheme = redColor
    var color = "Red"
    var fontResize: CGFloat = 1.25
}

public let defaults = UserDefaults.standard
public var currentSettings = Settings()
public var greenColor = UIColor(red: 32/255, green: 159/255, blue: 93/255, alpha: 1.0)
public var blueColor = UIColor(red: 72/255, green: 162/255, blue: 226/255, alpha: 1.0)
public var redColor = UIColor(red: 226/255, green: 81/255, blue: 93/255, alpha: 1.0)
public var purpleColor = UIColor(red: 182/255, green: 110/255, blue: 207/255, alpha: 1.0)
public var orangeColor = UIColor(red: 207/255, green: 135/255, blue: 46/255, alpha: 1.0)
public var yellowColor = UIColor(red: 193/255, green: 175/255, blue: 12/255, alpha: 1.0)

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
        updateUserDefaults() // this shouldn't be here, it's for the sign up page ONLY where no defaults have been set yet
        loadUserDefaults()  // this should be placed in the home page
        checkDarkMode()
        updateColor()
        updateNavBar()
        updateFontSize(resize:currentSettings.fontResize)
        setUpSwitchesAndSliders()
        setUpColorMenu()
    }
    
    func setUpSwitchesAndSliders() {
        // set initial switch/slider values
        darkModeSwitch.isOn = currentSettings.darkMode
        muteNotificationsSwitch.isOn = currentSettings.muteNotifications
        fontSizeSlider.setValue(Float(currentSettings.fontResize), animated: true)
        // add functions to switches
        darkModeSwitch.addTarget(self, action: #selector(SettingsViewController.darkModeSwitchIsChanged(mySwitch:)), for: .valueChanged)
        muteNotificationsSwitch.addTarget(self, action: #selector(SettingsViewController.muteSwitchIsChanged(mySwitch:)), for: .valueChanged)
    }
    
    func setUpColorMenu() {
        // create menu for color scheme button
        colorSchemeButton.setTitle(currentSettings.color, for: .normal)
        colorSchemeButton.showsMenuAsPrimaryAction = true
        var greenState:UIMenuElement.State = .off
        var blueState:UIMenuElement.State = .off
        var redState:UIMenuElement.State = .off
        var purpleState:UIMenuElement.State = .off
        var orangeState:UIMenuElement.State = .off
        var yellowState:UIMenuElement.State = .off
        if currentSettings.color == "Green" {
            greenState = .on
        } else if currentSettings.color == "Blue" {
            blueState = .on
        } else if currentSettings.color == "Purple" {
            purpleState = .on
        } else if currentSettings.color == "Yellow" {
            yellowState = .on
        } else if currentSettings.color == "Orange" {
            orangeState = .on
        } else {
            redState = .on
        }
        let green = UIAction(title: "Green", state: greenState) { action in
            currentSettings.colorScheme = greenColor
            currentSettings.color = "Green"
            self.updateColor()
            self.updateNavBar()
        }
        let blue = UIAction(title: "Blue", state: blueState) { action in
            currentSettings.colorScheme = blueColor
            currentSettings.color = "Blue"
            self.updateColor()
            self.updateNavBar()
        }
        let red = UIAction(title: "Red", state: redState) { action in
            currentSettings.colorScheme = redColor
            currentSettings.color = "Red"
            self.updateColor()
            self.updateNavBar()
        }
        let purple = UIAction(title: "Purple", state: purpleState) { action in
            currentSettings.colorScheme = purpleColor
            currentSettings.color = "Purple"
            self.updateColor()
            self.updateNavBar()
        }
        let orange = UIAction(title: "Orange", state: orangeState) { action in
            currentSettings.colorScheme = orangeColor
            currentSettings.color = "Orange"
            self.updateColor()
            self.updateNavBar()
        }
        let yellow = UIAction(title: "Yellow", state: yellowState) { action in
            currentSettings.colorScheme = yellowColor
            currentSettings.color = "Yellow"
            self.updateColor()
            self.updateNavBar()
        }
        let colorMenu = UIMenu(title: "Choose a Color", children: [purple, blue, green, yellow, orange, red])
        colorSchemeButton.menu = colorMenu
    }
    
    func loadUserDefaults() {
        currentSettings.daysBeforeNotification = defaults.integer(forKey: "daysBeforeNotification")
        currentSettings.notificationTime = defaults.string(forKey: "notificationTime")!
        currentSettings.muteNotifications = defaults.bool(forKey: "muteNotifications")
        currentSettings.darkMode = defaults.bool(forKey: "darkMode")
        currentSettings.color = defaults.string(forKey: "color")!
        currentSettings.fontResize = CGFloat(defaults.float(forKey: "fontResize"))
        
        // determine color scheme
        if currentSettings.color == "Red" {
            currentSettings.colorScheme = redColor
        } else if currentSettings.color == "Orange" {
            currentSettings.colorScheme = orangeColor
        } else if currentSettings.color == "Yellow" {
            currentSettings.colorScheme = yellowColor
        } else if currentSettings.color == "Green" {
            currentSettings.colorScheme = greenColor
        } else if currentSettings.color == "Blue" {
            currentSettings.colorScheme = blueColor
        } else {
            currentSettings.colorScheme = purpleColor
        }
    }
    
    func updateUserDefaults() {
        defaults.set(currentSettings.daysBeforeNotification, forKey: "daysBeforeNotification")
        defaults.set(currentSettings.notificationTime, forKey: "notificationTime")
        defaults.set(currentSettings.muteNotifications, forKey: "muteNotifications")
        defaults.set(currentSettings.darkMode, forKey: "darkMode")
        defaults.set(currentSettings.color, forKey: "color")
        defaults.set(currentSettings.fontResize, forKey: "fontResize")
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
        self.updateNavBar()
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
        currentUser.loggedIn = false
    }
    
    func updateNavBar() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: currentSettings.colorScheme,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: currentSettings.fontResize*17)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController!.navigationBar.tintColor = currentSettings.colorScheme
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

