//
//  EventAnnotation.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/20/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/*class EventAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var event: Event
    
    init(event: Event) {
        self.event = event
        self.coordinate = event.location
        super.init()
    }
    
}*/


class EventAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var startTime: TimeInterval
    var endTime: TimeInterval
    var type: String
    var desc: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, startTime: TimeInterval, endTime: TimeInterval, type: String, desc: String) {
        self.coordinate = coordinate
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.desc = desc
        super.init()
    }
    
}
