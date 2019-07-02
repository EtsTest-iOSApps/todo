//
//  List.swift
//  todo
//
//  Created by Manu on 02/06/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var subtitle: String = ""
    let items = List<Item>()
}
