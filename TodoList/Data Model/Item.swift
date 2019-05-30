//
//  Item.swift
//  TodoList
//
//  Created by Timchang Wuyep on 30/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
