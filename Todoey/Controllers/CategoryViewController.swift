//
//  CategoryViewController.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 9/30/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // initialize Realm (this can fail if resources are constrained)
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    
    // MARK: - TableView data source methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // ?? is the nil coalescing operator, so if categories is not nil it will
        // return the number of categories, but if it is nil, it will return 1
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Add a Category"

        return cell
    }
    
    
    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // trigger segue
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    // gets called automatically before the segue happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        // Get the category that conforms to the selected cell, and assign it
        // to the "selectedCell" variable in the destination view controller
        // (we can't actually do that directly, but we can figure out which row got
        // selected and get at it that way)
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    

    //MARK: - Data manipulation methods
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category context, \(error)")
        }
        
        tableView.reloadData()
        
    } // end of saveItems method
    
    
    //MARK: - Add new categories

    // This method is what will happen when the add new category button is pressed
    // In our case, it shows a popup with a title, a text field and a button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldText = UITextField()
        
        // create a popup
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // create an action button for the popup
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // this is what happens when the user clicks the Add button on our UIAlert
            
            if textFieldText.text == "" {
                // don't store a blank
            }
            else {
                let newCategory = Category()
                newCategory.name = textFieldText.text!

                self.save(category: newCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            // the placeholder is the pale grey text in the field that disappears once the user
            // starts typing
            alertTextField.placeholder = "Create new category"
            textFieldText = alertTextField
        }
        
        // add the action button to the popup
        alert.addAction(action)
        
        // show the popup
        present(alert, animated: true, completion: nil)
        
    } // end of addButtonPressed method
    
    
}
