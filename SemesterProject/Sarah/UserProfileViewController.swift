//
//  UserProfileViewController.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 10/14/22.
//

import UIKit
import AVFoundation

public struct User {
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var allergyList:[Allergy] = []
    var dietList: [String] = []
    var dietBool = [Int] (repeating: 0, count: dietTypes.count)
    var profilePicture:UIImage = defaultProfilePic!
}

public var currentUser = User()
public let defaultProfilePic = UIImage(named: "defaultProfilePic.png")

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var dietButton: UIButton!
    @IBOutlet weak var allergiesButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    let picker = UIImagePickerController()
    var chosenImage = defaultProfilePic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFontSize(resize:currentSettings.fontResize)
        checkDarkMode()
        updateNavBar()
        updateColor()
        picker.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        // hide buttons for editing profile, prevent user from interacting with editing buttons
        disableUserEdits()
        // original user profile
        firstNameField.text = currentUser.firstName
        lastNameField.text = currentUser.lastName
        emailField.text = currentUser.email
        // circular profile picture
        setUpProfilePicture()
    }
    
    // circular profile picture
    func setUpProfilePicture() {
        profilePicture.layer.borderWidth = 7
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = currentSettings.colorScheme.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        profilePicture.image = currentUser.profilePicture
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFontSize(resize:currentSettings.fontResize)
        checkDarkMode()
        updateColor()
        updateNavBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        updateFontSize(resize:currentSettings.fontResize)
        checkDarkMode()
        updateColor()
        updateNavBar()
    }
    
    func updateColor() {
        allergiesButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        dietButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        firstNameLabel.textColor = currentSettings.colorScheme
        lastNameLabel.textColor = currentSettings.colorScheme
        emailLabel.textColor = currentSettings.colorScheme
        editButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        profilePicButton.setTitleColor(currentSettings.colorScheme, for: .normal)
        profilePicture.layer.borderColor = currentSettings.colorScheme.cgColor
    }
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Edit allergy list
        if segue.identifier == "AllergiesSegue" {
            let nextVC = segue.destination as! AllergiesTableViewController
        }
        // Edit dietary restrictions
        if segue.identifier == "DietaryRestrictonsSegue" {
            let nextVC = segue.destination as! DietaryRestrictionsViewController
        }
    }
    
    @IBAction func allergiesButtonPressed(_ sender: Any) {
        updateFontSize(resize:currentSettings.fontResize)
    }
    
    @IBAction func dietButtonPressed(_ sender: Any) {
        updateFontSize(resize:currentSettings.fontResize)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        enableUserEdits()
        updateFontSize(resize:currentSettings.fontResize)
    }
 
    @IBAction func saveButtonPressed(_ sender: Any) {
        // check if first and last name are not blank
        if firstNameField.text!.count > 0 && lastNameField.text!.count > 0 {
            disableUserEdits()
            // save new user data
            currentUser.firstName = firstNameField.text!
            currentUser.lastName = lastNameField.text!
            updateFontSize(resize:currentSettings.fontResize)
            // save profile picture
            currentUser.profilePicture = self.chosenImage!
            // update profile picture
            DispatchQueue.main.async {
                self.profilePicture.image = currentUser.profilePicture
                self.profilePicture.setNeedsDisplay()
            // update user defaults
                self.updateUserDefaults()
            }
            // Core Data
        } else {
            // alert
            let alertVC = UIAlertController(
                title: "Warning",
                message: "Name fields cannot be blank",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
            title: "OK",
            style: .default)
            alertVC.addAction(okAction)
            present(alertVC, animated:true)
        }
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
    
    @IBAction func discardButtonPressed(_ sender: Any) {
        disableUserEdits()
        updateFontSize(resize:currentSettings.fontResize)
        // reset text fields
        firstNameField.text = currentUser.firstName
        lastNameField.text = currentUser.lastName
        
        // update profile picture
        DispatchQueue.main.async {
            self.profilePicture.image = currentUser.profilePicture
            self.profilePicture.setNeedsDisplay()
        }
    }
    
    // brings up camera or image library
    @IBAction func profilePictureButtonPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Edit Profile Picture",
            message: "Select a picture from your library or take a picture",
            preferredStyle: .alert)
        controller.addAction(UIAlertAction(
            title: "Select Photo",
            style: .default,
            handler: {
                (paramAction:UIAlertAction!) in
                // access photo library
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true)
            }))
        controller.addAction(UIAlertAction(
            title: "Camera",
            style: .default,
            handler: {
                (paramAction:UIAlertAction!) in
                // go to camera
                // check if device has a rear camera
                if UIImagePickerController.availableCaptureModes(for: .front) != nil {
                    // use the front camera
                    switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .notDetermined:
                        // we don't know
                        AVCaptureDevice.requestAccess(for: .video) {
                            accessGranted in
                            guard accessGranted == true else { return }
                        }
                    case .authorized:
                        // we already have permission
                        break
                    default:
                        // we know we don't have access
                        print("Access denied")
                        return
                    }
                    self.picker.allowsEditing = false
                    self.picker.sourceType = .camera
                    self.picker.cameraCaptureMode = .photo
                    self.present(self.picker, animated: true)
                            
                    } else {
                    // no rear camera is available
                    let alertVC = UIAlertController(
                        title: "No camera",
                        message: "This device has no front camera",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated:true)
                    }
            }))
        controller.addAction(UIAlertAction(
            title: "Delete Photo",
            style: .destructive,
            handler: {
                (paramAction:UIAlertAction!) in
                self.chosenImage = defaultProfilePic!
                // update profile picture
                DispatchQueue.main.async {
                    self.profilePicture.image = self.chosenImage
                    self.profilePicture.setNeedsDisplay()
                }
            }))
        present(controller, animated: true)
    }
    
    // set selected image as profile picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        chosenImage = info[.originalImage] as? UIImage
        // update profile picture
        DispatchQueue.main.async {
            self.profilePicture.image = self.chosenImage
            self.profilePicture.setNeedsDisplay()
        }
        
        // Core Data
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func updateFontSize(resize: CGFloat) {
        firstNameLabel.font = UIFont(name: "Symbol", size: resize*15)
        lastNameLabel.font = UIFont(name: "Symbol", size: resize*15)
        emailLabel.font = UIFont(name: "Symbol", size: resize*15)
        firstNameField.font = UIFont(name: "Symbol", size: resize*15)
        lastNameField.font = UIFont(name: "Symbol", size: resize*15)
        emailField.font = UIFont(name: "Symbol", size: resize*15)
        allergiesButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: resize*16)
        dietButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: resize*16)
//        discardButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
//        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
        profilePicButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: CGFloat(resize*14))
        editButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: CGFloat(resize*14))
    }
    
    func updateNavBar() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: currentSettings.colorScheme,
            NSAttributedString.Key.font:
                UIFont(name: "Symbol", size: currentSettings.fontResize*17)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController!.navigationBar.tintColor = currentSettings.colorScheme
    }
    
    func disableUserEdits() {
        firstNameField.isUserInteractionEnabled = false
        lastNameField.isUserInteractionEnabled = false
        saveButton.isUserInteractionEnabled = false
        discardButton.isUserInteractionEnabled = false
        profilePicButton.isUserInteractionEnabled = false
        editButton.isHidden = false
        saveButton.isHidden = true
        discardButton.isHidden = true
        profilePicButton.isHidden = true
    }
    
    func enableUserEdits() {
        firstNameField.isUserInteractionEnabled = true
        lastNameField.isUserInteractionEnabled = true
        saveButton.isUserInteractionEnabled = true
        discardButton.isUserInteractionEnabled = true
        profilePicButton.isUserInteractionEnabled = true
        editButton.isHidden = true
        saveButton.isHidden = false
        discardButton.isHidden = false
        profilePicButton.isHidden = false
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
