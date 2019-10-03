//
//  TodoListViewController.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 9/27/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    // Whatever you put inside didSet gets run as soon as selectedCategory
    // is given a value
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // this method overrides the one in SwipeTableViewController, so we need
        // access to its cell reference
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // if item is not null
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Use Chameleon to make each subsequent row slightly darker
            // Then let Chameleon figure out whether the text needs to be
            // black or white to be readable
            if let colour = FlatWhite().darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(todoItems!.count ) ) {
                    cell.backgroundColor = colour
                
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
                }
            
            // Use accessory checkmark to indicate selection state
            
            // The Ternary operator in Swift ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "Please add an item."
        }
        
        return cell
    } // end of tableView.cellForRowAt method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // the selected row is highlighted briefly but then reverts to deselected state
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status, \(error)")
            }
        }

        tableView.reloadData()

    } // end of tableView.didSelectRowAt method
    
    //MARK: - Add new items
    
    // This method is what will happen when the add new item button is pressed
    // In our case, it shows a popup with a title, a text field and a button
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
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textFieldText.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch {
                        print("Error saving new item to Realm, \(error)")
                    }
                    
                }
                
                self.tableView.reloadData()
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            // the placeholder is the pale grey text in the field that disappears once the
            // user starts typing
            alertTextField.placeholder = "Create new item"
            textFieldText = alertTextField
        }
        
        // add the action button to the popup
        alert.addAction(action)
        
        // show the popup
        present(alert, animated: true, completion: nil)
        
    } // end of addButtonPressed method
    
    
    
    //MARK: - Model manipulation methods

    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    } // end of loadItems method
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }
            catch {
                print("Error deleting item, \(error)")
            }

        }
    }

    
    
} // end of TodoListViewController class

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // check to see if the search bar is empty, like when the little cross
        // button has been tapped
        if searchBar.text?.count == 0 {
            loadItems()
            // You want keyboard and cursor to go away, but you want to run it on
            // the main thread.  DispatchQueue handles threading.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

} // end of search bar extension
