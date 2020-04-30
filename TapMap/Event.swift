//
//  Event.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/20/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Event{
    
    var type: EventType
    var location: CLLocationCoordinate2D
    var title: String
    var description: String
    //amound of seconds since 1970
    var startTime: TimeInterval
    var endTime: TimeInterval
    
    init(type: EventType, location: CLLocationCoordinate2D, title: String, description: String, startTime: TimeInterval, endTime: TimeInterval){
        self.type = type
        self.location = location
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
    }
    
}
