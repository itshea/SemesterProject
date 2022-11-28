//
//  CalendarViewController.swift
//  SemesterProject
//
//  Created by Hana Bredstein on 11/28/22.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date(timeInterval: 0, since: Date())
        let month = Calendar.current.component(.month, from: today)
        let day = Calendar.current.component(.day, from: today)
        dateLabel.text = "\(month)"

        // Do any additional setup after loading the view.
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
