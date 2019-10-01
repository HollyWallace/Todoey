//
//  CategoryViewController.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 9/30/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    // We need a context for use with CoreData, so here is how to get
    // the AppDelegate as an (singleton) object and then get the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    
    // MARK: - TableView data source methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categoryArray[indexPath.row].name

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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    

    //MARK: - Data manipulation methods
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching category data from context: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveCategories() {
        
        do {
            try context.save()
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
                let newCategory = Category(context: self.context)
                newCategory.name = textFieldText.text!
                
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
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
