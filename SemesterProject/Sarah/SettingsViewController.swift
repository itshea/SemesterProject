//
//  SettingsViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 10/14/22.
//

import UIKit
import FirebaseAuth

public struct Settings {
    var daysBeforeNotification = 3
    var muteNotifications = false
    var darkMode = false
    var colorScheme = greenColor
    var color = "Green"
    var fontResize: CGFloat = 1.25
    var loggedIn = false
}

public let userDefaults = UserDefaults.standard
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
            self.colorSchemeButton.setTitle(currentSettings.color, for: .normal)
            self.updateColor()
            self.updateNavBar()
            self.updateUserDefaults()
        }
        let blue = UIAction(title: "Blue", state: blueState) { action in
            currentSettings.colorScheme = blueColor
            currentSettings.color = "Blue"
            self.colorSchemeButton.setTitle(currentSettings.color, for: .normal)
            self.updateColor()
            self.updateNavBar()
            self.updateUserDefaults()
        }
        let red = UIAction(title: "Red", state: redState) { action in
            currentSettings.colorScheme = redColor
            currentSettings.color = "Red"
            self.colorSchemeButton.setTitle(currentSettings.color, for: .normal)
            self.updateColor()
            self.updateNavBar()
            self.updateUserDefaults()
        }
        let purple = UIAction(title: "Purple", state: purpleState) { action in
            currentSettings.colorScheme = purpleColor
            currentSettings.color = "Purple"
            self.colorSchemeButton.setTitle(currentSettings.color, for: .normal)
            self.updateColor()
            self.updateNavBar()
            self.updateUserDefaults()
        }
        let orange = UIAction(title: "Orange", state: orangeState) { action in
            currentSettings.colorScheme = orangeColor
            currentSettings.color = "Orange"
            self.colorSchemeButton.setTitle(currentSettings.color, for: .normal)
            self.updateColor()
            self.updateNavBar()
            self.updateUserDefaults()
        }
        let yellow = UIAction(title: "Yellow", state: yellowState) { action in
            currentSettings.colorScheme = yellowColor
            currentSettings.color = "Yellow"
            self.colorSchemeButton.setTitle(currentSettings.color, for: .normal)
            self.updateColor()
            self.updateNavBar()
            self.updateUserDefaults()
        }
        let colorMenu = UIMenu(title: "Choose a Color", children: [purple, blue, green, yellow, orange, red])
        colorSchemeButton.menu = colorMenu
    }
    
    func updateUserDefaults() {
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
    
    func updateColor() {
        colorSchemeButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        settingsLabel.textColor = currentSettings.colorScheme
        profileLabel.textColor = currentSettings.colorScheme
        notificationsLabel.textColor = currentSettings.colorScheme
        displayLabel.textColor = currentSettings.colorScheme
        muteNotificationsSwitch.onTintColor = currentSettings.colorScheme
        darkModeSwitch.onTintColor = currentSettings.colorScheme
        fontSizeSlider.minimumTrackTintColor = currentSettings.colorScheme
        logOutButton.setTitleColor(currentSettings.colorScheme, for: .normal)
    }
    
    @objc func darkModeSwitchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            currentSettings.darkMode = true
            overrideUserInterfaceStyle = .dark
        } else {
            currentSettings.darkMode = false
            overrideUserInterfaceStyle = .light
        }
        self.updateUserDefaults()
    }
    
    @objc func muteSwitchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            currentSettings.muteNotifications = true
        } else {
            currentSettings.muteNotifications = false
        }
        self.updateUserDefaults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        self.updateUserDefaults()
    }
    
    func updateFontSize(resize: CGFloat) {
        // set bold fonts
        settingsLabel.font = UIFont(name: "Helvetica-Bold", size: resize*40)
        profileLabel.font = UIFont(name: "Helvetica-Bold", size: resize*24)
        notificationsLabel.font = UIFont(name: "Helvetica-Bold", size: resize*24)
        displayLabel.font = UIFont(name: "Helvetica-Bold", size: resize*24)
        // set non-bold fonts
        changePassButton.titleLabel?.font = UIFont(name: "Symbol", size: resize*15)
        muteNotificationsLabel.font = UIFont(name: "Symbol", size: resize*15)
        notificationButton.titleLabel?.font = UIFont(name: "Symbol", size: resize*15)
        darkModeLabel.font = UIFont(name: "Symbol", size: resize*15)
        colorSchemeLabel.font = UIFont(name: "Symbol", size: resize*15)
        fontSizeLabel.font = UIFont(name: "Symbol", size: resize*15)
        colorSchemeButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: resize*17)
        logOutButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: resize*17)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        currentSettings.loggedIn = false
        self.updateUserDefaults()
        try! Auth.auth().signOut()
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

