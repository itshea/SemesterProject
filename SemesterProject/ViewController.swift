//
//  ViewController.swift
//  SemesterProject
//
//  Created by Iris Shea on 10/7/22.
//

// The Welcome screen with two segues
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func fadeOut(_ sender: Any) {
        self.logoButton.alpha = 1.0
        
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.logoButton.alpha = 0.0
            }
        )
    }
    
}

