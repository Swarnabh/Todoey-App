//
//  Category.swift
//  test1
//
//  Created by BossmediaNT on 12/12/18.
//  Copyright © 2018 swarnabh. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name:String=""
    let items=List<Item>()
}
