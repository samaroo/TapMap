//
//  FilterViewController.swift
//  TapMap
//
//  Created by Brandon Samaroo on 1/2/20.
//  Copyright © 2020 Brandon Samaroo. All rights reserved.
//

import UIKit

//used to pass information backwards to the main VC
//any VC that wants to get info from this VC must conform to FilterViewControllerDelegate and implement the below functions
//with this protocol/delegate method, you can essentially call fucntions in other VC's
protocol FilterViewControllerDelegate : NSObjectProtocol{
    func transferActiveTypes(data: [String])
}

class FilterViewController: UIViewController {
    
    //an array of events that are or should be currently selected in the filter view
    var activeTypes: [String] = []
    //array that holds the EventTypes that will be displayed in the collection view
    var possibleEvents: [EventType] = []
    
    weak var delegate: FilterViewControllerDelegate?
    
    //Outlets
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var redCheck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //overrides user interface style to dark if IOS 13.0 or newer
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        
        //resize checkButton
        redCheck.setImage(redCheck.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 50)), for: .normal)

        //initializes possibleEvents array
        possibleEvents = createArray()
        
        //sets delegates for collectionView
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        
    }

    func createArray() -> [EventType]{
            
            var temp: [EventType] = []
            
            let art = EventType(category: "ART", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let causes = EventType(category: "CAUSES", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let comedy = EventType(category: "COMEDY", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let crafts = EventType(category: "CRAFTS", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let dance = EventType(category: "DANCE", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let drinks = EventType(category: "DRINKS", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let film = EventType(category: "FILM", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let fitness = EventType(category: "FITNESS", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let food = EventType(category: "FOOD", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let games = EventType(category: "GAMES", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let gardening = EventType(category: "GARDENING", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let health = EventType(category: "HEALTH", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let home = EventType(category: "HOME", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let literature = EventType(category: "LITERATURE", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let music = EventType(category: "MUSIC", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let networking = EventType(category: "NETWORKING", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let other = EventType(category: "OTHER", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let party = EventType(category: "PARTY", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let religion = EventType(category: "RELIGION", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let shopping = EventType(category: "SHOPPING", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let sports = EventType(category: "SPORTS", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let theater = EventType(category: "THEATER", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            let wellness = EventType(category: "WELLNESS", description: "", tableViewImage: UIImage(named: "CollectionViewPressed")!)
            
            temp.append(art)
            temp.append(causes)
            temp.append(comedy)
            temp.append(crafts)
            temp.append(dance)
            temp.append(drinks)
            temp.append(film)
            temp.append(fitness)
            temp.append(food)
            temp.append(games)
            temp.append(gardening)
            temp.append(health)
            temp.append(home)
            temp.append(literature)
            temp.append(music)
            temp.append(networking)
            temp.append(party)
            temp.append(religion)
            temp.append(shopping)
            temp.append(sports)
            temp.append(theater)
            temp.append(wellness)
            temp.append(other)
            
            return temp
        }

}

//mandatory fucntions for delegate and data source

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return possibleEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tempEvent = possibleEvents[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        
        cell.setEvent(event: tempEvent)
        cell.eventImageView.isHidden = true
        
        for i in activeTypes{
            if(possibleEvents[indexPath.row].category == i){
                cell.select()
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let temp = collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell{
            temp.select()
            //if item was selected, add it to the activeTypes array
            if !temp.eventImageView.isHidden{
                activeTypes.append(temp.eventLabel.text!)
            }
            //if deselected, find where that text value is located in the array and remove it
            else if temp.eventImageView.isHidden{
                var n = 0
                for i in activeTypes{
                    if i == temp.eventLabel.text!{
                        activeTypes.remove(at: n)
                    }
                    n = n + 1
                }
            }
        }
        //alphabetizes array after editing it
        activeTypes.sort()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "finishedFiltering"{
            //should be as! EventCreaterTableView
            self.dismiss(animated: true, completion: nil)
            if let _ = delegate{
                delegate?.transferActiveTypes(data: activeTypes)
            }
            
        }
    }
    
    
}
