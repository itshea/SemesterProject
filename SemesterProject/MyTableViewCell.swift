//
//  MyTableViewCell.swift
//  SemesterProject
//
//  Created by Iris Shea on 11/28/22.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var foodLabel: UILabel!
    
    var delegate: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
