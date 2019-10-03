//
//  Category.swift
//  Todoey
//
//  Created by HOLLY A WALLACE on 10/1/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundColor : String = "" // hex string
    // Define relationship between Category and List
    let items = List<Item>()
}
