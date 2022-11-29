//
//  ListViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 11/11/22.
//

import UIKit

// protocol for adding list
protocol ListAdder {
    func addList()
}

// list names
var listNames:[String] = []
var itemsDict:[String: [String]] = [:]

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListAdder {
    // IB Outlets
    @IBOutlet weak var listsTableView: UITableView!
    
    // cell
    let textCellID = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listsTableView.delegate = self
        listsTableView.dataSource = self
    }
    
    // rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath)
        cell.textLabel?.text = listNames[row]
        return cell
    }
    
    // delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            listNames.remove(at: indexPath.row)
            listsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to add new list
        if segue.identifier == "AddListSegue",
           let nextVC = segue.destination as? AddListViewController {
            nextVC.delegate = self
        }
        
        // segue to view list
        if segue.identifier == "ViewListSegue",
           let nextVC = segue.destination as? ViewListViewController,
           let listIndex = listsTableView.indexPathForSelectedRow?.row {
            nextVC.delegate = self
            nextVC.listName = listNames[listIndex]
        }
    }
    
    // reload table via delegate/protocol
    func addList() {
        listsTableView.reloadData()
    }

}
