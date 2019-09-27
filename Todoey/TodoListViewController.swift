//
//  TodoListViewController.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 9/27/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggs", "Impeach Trump"]
    
    // similar to Android's SharedPreferences - stores key/value pairs
    // in a plist file
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // the selected row is highlighted briefly but then reverts to deselected state
        tableView.deselectRow(at: indexPath, animated: true)
        
        // use accessory checkmark to indicate selection
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK: - add new items
    
    // This method is what will happen when the add new item button is pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldText = UITextField()
        
        // create a popup
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        // create an action button for the popup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // this is what happens when the user clicks the Add Item button on our UIAlert
            
            if textFieldText.text == "" {
                // don't store a blank
            }
            else {
                self.itemArray.append(textFieldText.text!)
                // add data to UserDefaults
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            // the placeholder is the pale grey text in the field that disappears once the user
            // starts typing
            alertTextField.placeholder = "Create new item"
            textFieldText = alertTextField
        }
        
        // add the action button to the popup
        alert.addAction(action)
        
        // show the popup
        present(alert, animated: true, completion: nil)
        
    } // end of addButtonPressed method
    

} // end of TodoListViewController class

