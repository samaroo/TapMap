//
//  Event.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/19/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import Foundation
import UIKit

class EventType{
    
    var description: String
    var category: String
    var tableViewImage: UIImage
    
    init(category: String, description: String, tableViewImage: UIImage){
        self.description = description
        self.category = category
        self.tableViewImage = tableViewImage
    }
    
}
