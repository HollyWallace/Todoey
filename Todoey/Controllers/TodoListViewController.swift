//
//  TodoListViewController.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 9/27/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // Whatever you put inside didSet gets run as soon as selectedCategory
    // is given a value
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // We need a context for use with CoreData, so here is how to get
    // the AppDelegate as a (singleton) object and then get the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        // To see where the data is stored
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Use accessory checkmark to indicate selection state
        
        // The Ternary operator in Swift
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // the selected row is highlighted briefly but then reverts to deselected state
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Delete the item from the list when you click on it
 //       context.delete(itemArray[indexPath.row])  // MUST do this first
 //       itemArray.remove(at: indexPath.row)
        
        // OR
        
        // toggle the Item object's done state
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

    }
    
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
                let newItem = Item(context: self.context)
                newItem.title = textFieldText.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
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
    
    //MARK: - Model manipulation methods
    
    func saveItems() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    } // end of saveItems method
    
    // In here, with is the external parameter, meaning you can use it
    // when calling the method, and request is the internal parameter
    // that will be used inside the method.  You might want an external
    // parameter so that your method calls read more like English
    //
    // We set up the method to have a default request for when you just
    // want to retrieve everything.  That's the equal sign and the thing
    // after it.  So, the request equals Item.fetchRequest() unless you
    // specify something else when you call the method.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
    

        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()

    } // end of loadItems method

    
    
} // end of TodoListViewController class

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // To query the database you set up a request and use an NSPredicate
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // String comparisons are by default case and diacritic sensitive.  Using c
        // for case and d for diacritic allows you to ignore case and diacritical marks
        // respectively
        // Add the query to the request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort the results
        // Add the sort descriptor to the request as well; notice that it is
        // sortDescriptors PLURAL and that it expects an array of sort descriptors
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Here, we use the external parameter to the loadItems method because
        // it is more readable
        loadItems(with: request, predicate: predicate)
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
