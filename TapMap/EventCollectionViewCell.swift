//
//  EventCollectionViewCell.swift
//  TapMap
//
//  Created by Brandon Samaroo on 1/5/20.
//  Copyright © 2020 Brandon Samaroo. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventLabel: UILabel!
    
    
    func setEvent(event: EventType){
        // change eventImageView to one set 'select image' (shadow thing)
        eventImageView.image = event.tableViewImage
        eventImageView.layer.cornerRadius = 10.0
        eventLabel.text = event.category
    }
    
    func select(){
        if(self.eventImageView.isHidden == true){
            self.eventImageView.isHidden = false
        }
        else{
            self.eventImageView.isHidden = true
        }
    }
    
    
}
