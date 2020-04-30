//
//  FilterTableViewController.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/19/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import UIKit
import MapKit

//supposed to be EventCreartorTableViewController
class FilterTableViewController: UIViewController {
    
    var locationPassedFromVC1: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees())
    var eventSelected = EventType(category: "", description: "", tableViewImage: UIImage(named: "city") ?? UIImage())

    
    @IBOutlet weak var eventTableView: UITableView!
    
    var possibleEvents: [EventType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //overrides user interface style to dark if IOS 13.0 or newer
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        
        possibleEvents = createArray()
        eventTableView.delegate = self
        eventTableView.dataSource = self

    }

    func createArray() -> [EventType]{
        
        var temp: [EventType] = []
        
        let art = EventType(category: "ART", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let causes = EventType(category: "CAUSES", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let comedy = EventType(category: "COMEDY", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let crafts = EventType(category: "CRAFTS", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let dance = EventType(category: "DANCE", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let drinks = EventType(category: "DRINKS", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let film = EventType(category: "FILM", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let fitness = EventType(category: "FITNESS", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let food = EventType(category: "FOOD", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let games = EventType(category: "GAMES", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let gardening = EventType(category: "GARDENING", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let health = EventType(category: "HEALTH", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let home = EventType(category: "HOME", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let literature = EventType(category: "LITERATURE", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let music = EventType(category: "MUSIC", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let networking = EventType(category: "NETWORKING", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let other = EventType(category: "OTHER", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let party = EventType(category: "PARTY", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let religion = EventType(category: "RELIGION", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let shopping = EventType(category: "SHOPPING", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let sports = EventType(category: "SPORTS", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let theater = EventType(category: "THEATER", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        let wellness = EventType(category: "WELLNESS", description: "", tableViewImage: UIImage(named: "TableViewImageSmall")!)
        
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

//mandatory functions for delegate and data source

extension FilterTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempEvent = possibleEvents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.setEvent(event: tempEvent)
        if traitCollection.userInterfaceStyle == .dark {
            cell.mainLabel.shadowColor = .white
        } else if traitCollection.userInterfaceStyle == .light{
            cell.mainLabel.shadowColor = .darkGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        eventSelected = possibleEvents[indexPath.row]
        performSegue(withIdentifier: "goToInfoVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfoVC"{
            let vc = segue.destination as! FormVCViewController
            vc.locationPassedFromVC2 = locationPassedFromVC1
            vc.eventSelectedFromVC2 = eventSelected
            vc.vc2 = self
            //testing
            print("Location Value in VC2: ", locationPassedFromVC1)
            print("Event Selected from VC2: ", eventSelected.category)
            print("Location that is in VC3: ", vc.locationPassedFromVC2)
            print("Event that is in VC3: ", vc.eventSelectedFromVC2.category)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //animation 1
        let rotationTrans = CATransform3DTranslate(CATransform3DIdentity, -200, 10, 0)
        cell.layer.transform = rotationTrans
        cell.alpha = 0.25
        
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
        
    }
    
}

