//
//  Item.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 10/1/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    // Define inverse relationship between Category and Item
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
