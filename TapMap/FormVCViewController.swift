//
//  FormVCViewController.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/20/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GeoFire
import CoreLocation

class FormVCViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var formOutterRectangle: UILabel!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var timeScroll1: UIDatePicker!
    @IBOutlet weak var timeScroll2: UIDatePicker!
    @IBOutlet weak var checkButton: UIButton!
    
    //GeoFire vars
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var ref: DatabaseReference!
    
    
    //Place holder initializations for when a value hasnt been set
    var locationPassedFromVC2: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees())
    var eventSelectedFromVC2 = EventType(category: "", description: "", tableViewImage: UIImage(named: "city") ?? UIImage())
    var finalEventPost = Event(type: EventType(category: "", description: "", tableViewImage: UIImage(named: "city") ?? UIImage()), location: CLLocationCoordinate2D(latitude: CLLocationDegrees(), longitude: CLLocationDegrees()), title: "", description: "", startTime: TimeInterval(0.0), endTime: TimeInterval(0.0))
    var vc2 = FilterTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //overrides user interface style to light if IOS 13.0 or newer
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        formOutterRectangle.layer.masksToBounds = true
        formOutterRectangle.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        stepOut()
        checkButton.frame(forAlignmentRect: CGRect(x: view.center.x, y: ((UIScreen.main.bounds.height - 555) / 2), width: 50, height: 50))
        print((UIScreen.main.bounds.height - 555) / 2)
    }
    
    func stepIn(child: String){
        geoFireRef = Database.database().reference().child(child)
        geoFire = GeoFire(firebaseRef: geoFireRef)
        ref = Database.database().reference().child(child)
    }
    
    func stepOut(){
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        ref = Database.database().reference()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func uploadToDatabase(event: Event){
        guard let key = ref.child(event.type.category).childByAutoId().key else { return }
        self.ref.child(event.type.category).child(key).child("TITLE").setValue(event.title)
        self.ref.child(event.type.category).child(key).child("DESCRIPTION").setValue(event.description)
        self.ref.child(event.type.category).child(key).child("START TIME (SECS AFTER 1970)").setValue(Double(event.startTime))
        self.ref.child(event.type.category).child(key).child("END TIME (SECS AFTER 1970)").setValue(Double(event.endTime))
        
        stepIn(child: event.type.category)
        geoFire.setLocation(CL2DToCL(input: event.location) , forKey: key)
        stepOut()
        
        
        print(key)
    }
    
    func CL2DToCL(input: CLLocationCoordinate2D) -> CLLocation{
        return CLLocation.init(latitude: input.latitude, longitude: input.longitude)
    }
    
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        if textFieldOne.text != ""{
            textFieldOne.backgroundColor = UIColor.clear
            if textFieldTwo.text != ""{
                textFieldTwo.backgroundColor = UIColor.clear
                //create Event object
                finalEventPost = Event(type: eventSelectedFromVC2, location: locationPassedFromVC2, title: textFieldOne.text!, description: textFieldTwo.text!, startTime: timeScroll1.date.timeIntervalSince1970, endTime: timeScroll2.date.timeIntervalSince1970)
                uploadToDatabase(event: finalEventPost)
                performSegue(withIdentifier: "afterCheckGoBackToMain", sender: self)
            }
            else{
                textFieldTwo.backgroundColor = UIColor.systemRed
            }
        }
        else{
            textFieldOne.backgroundColor = UIColor.systemRed
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afterCheckGoBackToMain"{
            self.dismiss(animated: true, completion: nil)
            vc2.dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
