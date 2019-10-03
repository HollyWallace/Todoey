//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 10/2/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    // Change the cell row height so that the little trash can icon doesn't
    // look squished.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 68.0
    } // end of viewDidLoad method


    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: - Swipe Cell delegate methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    
    //MARK: - Data methods
    func updateModel(at indexPath: IndexPath) {
        // Update the data model.  This will actually be done in the
        // descendent's classes.

    }

} // end of SwipeTableViewController
