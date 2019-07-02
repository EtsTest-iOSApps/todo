//
//  Item.swift
//  todo
//
//  Created by Manu on 02/06/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var created = Date()
    let parentCategory =  LinkingObjects(fromType: Category.self, property: "items")
}
