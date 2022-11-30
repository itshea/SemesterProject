//
//  ViewListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 11/11/22.
//

import UIKit

// protocol for adding list
protocol ItemAdder {
    func addItem(name: String, index: Int)
}

var items:[[String]] = [[]]

class ViewListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemAdder {
    // IB outlets
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var aListTableView: UITableView!
    
    // variables
    var delegate:UIViewController!
    var listName:String = ""
    var listIndex:Int = 0
    let textCellID = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNameLabel.text = listName
        aListTableView.delegate = self
        aListTableView.dataSource = self
    }
    
    // rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[listIndex].count
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = aListTableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath)
        cell.textLabel?.text = items[listIndex][row]
        return cell
    }
    
    // delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            items[listIndex].remove(at: indexPath.row)
            aListTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    // puts checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if aListTableView.cellForRow(at: indexPath)?.accessoryType == Optional.none {
            aListTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            aListTableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    // add item segue
    @IBAction func addItemButtonPressed(_ sender: Any) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddListItemSegue",
               let nextVC = segue.destination as? AddListItemViewController {
                nextVC.delegate = self
                nextVC.listKey = listName
                nextVC.itemIndex = listIndex
            }
        }
    }
    
    // reload table via delegate/protocol
    func addItem(name: String, index: Int) {
        listNameLabel.text = name
        listIndex = index
        aListTableView.reloadData()
    }

}
