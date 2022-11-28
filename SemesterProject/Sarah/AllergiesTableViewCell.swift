//
//  AllergiesTableViewCell.swift
//  SemesterProject
//
//  Created by Sarah Tsai on 11/11/22.
//

import UIKit

class AllergiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var allergySeverityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontSize(resize:currentSettings.fontResize)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateFontSize(resize: CGFloat) {
        print("updating font")
//        settingsLabel.font = UIFont.boldSystemFont(ofSize: resize*45)
//        viewProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
//        muteNotificationsLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*17))
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
