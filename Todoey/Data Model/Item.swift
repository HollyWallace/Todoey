//
//  Item.swift
//  Todoey
//
//  An encodable class requires all of its properties to be ordinary
//  data types.  Instead of adding Encodable and Decodable, we can simply
//  use Codable to mean both.
//
//  Created by HOLLY A WALLACE on 9/27/19.
//  Copyright © 2019 Holly A. Wallace. All rights reserved.
//

import Foundation

class Item: Codable {
    
    var title : String = ""
    
    var done : Bool = false
    
}
