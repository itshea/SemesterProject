//
//  ListsViewController.swift
//  SemesterProject
//
//  Created by Jennifer Wei on 12/2/22.
//

import UIKit

// protocol for adding list
protocol ListAdder {
    func addList()
}

class ListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListAdder {
    // IB outlets
    @IBOutlet weak var listsLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var listsTableView: UITableView!
    
    // cell
    let textCellID = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listsTableView.delegate = self
        listsTableView.dataSource = self
        checkDarkMode()
        updateNavBar()
        updateColor()
        updateFontSize(resize:currentSettings.fontResize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDarkMode()
        updateNavBar()
        listsTableView.reloadData()
        updateColor()
        updateFontSize(resize:currentSettings.fontResize)
    }
    
    // rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.listNames.count
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(currentSettings.fontResize*17))
        cell.textLabel?.text = currentUser.listNames[row]
        return cell
    }
    
    // delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            currentUser.listNames.remove(at: indexPath.row)
            listsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            currentUser.items.remove(at: indexPath.row)
        }
    }
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to add new list
        if segue.identifier == "AddListSegue",
           let nextVC = segue.destination as? NewListViewController {
            nextVC.delegate = self
        }
        
        // segue to show list
        if segue.identifier == "ViewListSegue",
           let nextVC = segue.destination as? ShowListViewController,
           let listIndex = listsTableView.indexPathForSelectedRow?.row {
            nextVC.delegate = self
            nextVC.listName = currentUser.listNames[listIndex]
        }
    }
    
    // reload table via delegate/protocol
    func addList() {
        listsTableView.reloadData()
    }
    
    func updateNavBar() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: currentSettings.colorScheme,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: currentSettings.fontResize*17)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController!.navigationBar.tintColor = currentSettings.colorScheme
    }

    func updateColor() {
        addButton.tintColor = currentSettings.colorScheme
        listsLabel.textColor = currentSettings.colorScheme
    }
    
    func updateFontSize(resize: CGFloat){
        listsLabel.font = UIFont.systemFont(ofSize: CGFloat(resize*22))
    }
    
    func checkDarkMode() {
        if currentSettings.darkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

}
