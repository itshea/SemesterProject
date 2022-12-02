//
//  ShowListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 12/2/22.
//

import UIKit

// protocol for adding list
protocol ItemAdder {
    func addItem(name: String, index: Int)
}

class ShowListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemAdder {
    // IB outlets
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    // variables
    var delegate:UIViewController!
    var listName:String = ""
    var listIndex:Int = 0
    let textCellID = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNameLabel.text = listName
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    // rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[listIndex].count
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = listTableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath)
        cell.textLabel?.text = items[listIndex][row]
        return cell
    }
    
    // delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            items[listIndex].remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    // puts checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = listTableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    // add item segue
    @IBAction func addListItemButtonPressed(_ sender: Any) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddListItemSegue",
               let nextVC = segue.destination as? ListItemViewController {
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
        listTableView.reloadData()
    }
    
}