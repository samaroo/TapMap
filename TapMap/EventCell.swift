//
//  CityCell.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/19/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {


    //outlets of the elements that make up each cell in the UITableView
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    func setEvent(event: EventType){
        //providing data for the elements of each cell given an eventType
        ImageView.image = event.tableViewImage
        ImageView.layer.cornerRadius = 10.0
        mainLabel.text = event.category
    }
    
}
