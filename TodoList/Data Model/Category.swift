//
//  Category.swift
//  TodoList
//
//  Created by Timchang Wuyep on 30/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    //relationship (each category can have multiple items)
    let items = List<Item>()
    
}
