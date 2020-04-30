//
//  ViewController.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/18/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GeoFire
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    //location manager object that tells what permissions are given
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    //instantiate GeoFire object
    var geoFire: GeoFire!
    //refrences to real-time database for GeoFire and FireBase
    var geoFireRef: DatabaseReference!
    var ref: DatabaseReference!
    
    //var to hold annotation when sending to info screen
    //instantiating it with default variables so it doesnt throw and error
    var anno : EventAnnotation = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), title: "", startTime: 0.0, endTime: 0.0, type: "", desc: "")
    
    //dictionary to hold current annotations
    //var annos: [String: MKAnnotation] = [:]
    
    //array for types
    var types: [String] = ["ART","CAUSES","COMEDY","CRAFTS","DANCE","DRINKS","FILM","FITNESS","FOOD","GAMES","GARDENING","HEALTH","HOME","LITERATURE","MUSIC","NETWORKING","OTHER","PARTY","RELIGION","SHOPPING","SPORTS","THEATER","WELLNESS",]
    
    //array that holds the filtered list of types the user wants to see
    //will be modified when coming from FilterVC
    var activeTypesMainVC: [String] = ["ART","CAUSES","COMEDY","CRAFTS","DANCE","DRINKS","FILM","FITNESS","FOOD","GAMES","GARDENING","HEALTH","HOME","LITERATURE","MUSIC","NETWORKING","OTHER","PARTY","RELIGION","SHOPPING","SPORTS","THEATER","WELLNESS",]
    //setting vars
    var radius: Double = 5.0

    //IBOutlets for all elements on the home VC
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var greenCheck: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var redX: UIButton!
    @IBOutlet weak var crossHairs: UIImageView!
    @IBOutlet weak var redFilter: UIButton!
    @IBOutlet weak var naviBar: UIImageView!
    @IBOutlet weak var blueSearch: UIButton!
    @IBOutlet weak var zoomIn: UIButton!
    @IBOutlet weak var reCenter: UIButton!
    @IBOutlet weak var zoomOut: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //variables that hold user's screen dimensions
        let bounds = UIScreen.main.bounds
        //let width = bounds.size.width
        let height = bounds.size.height
        
        //overrides user interface style to dark if IOS 13.0 or newer
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        
        //resises NaviBar image
        let resizedImage = naviBar.image?.resize(targetSize: CGSize(width: height/20, height: height/2))
        naviBar.image = resizedImage
        
        //resize naviButtons to match NaviBar
        zoomIn.widthAnchor.constraint(equalToConstant: height/20).isActive = true
        zoomIn.heightAnchor.constraint(equalToConstant: height/6).isActive = true
        
        reCenter.widthAnchor.constraint(equalToConstant: height/20).isActive = true
        reCenter.heightAnchor.constraint(equalToConstant: height/6).isActive = true
        
        zoomOut.widthAnchor.constraint(equalToConstant: height/20).isActive = true
        zoomOut.heightAnchor.constraint(equalToConstant: height/6).isActive = true
        
        //resizes all button images
        //I resize using this function because the button comes out clearer
        let newCenterButton = centerButton.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 50))
        centerButton.setImage(newCenterButton, for: .normal)
        //doing the above but just in one step
        redFilter.setImage(redFilter.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 50)), for: .normal)
        greenCheck.setImage(greenCheck.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 50)), for: .normal)
        redX.setImage(redX.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 50)), for: .normal)
        crossHairs.image = crossHairs.image?.resize(targetSize: CGSize(width: 150, height: 150))
        blueSearch.setImage(blueSearch.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 50)), for: .normal)
        
        //setting this vc as delegate
        mapView.delegate = self
        
        //sets mapview options
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsCompass = false
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //hides buttons that shouldnt be shown yet
        greenCheck.isHidden = true
        redX.isHidden = true
        crossHairs.isHidden = true
        
        //resets GeoFire Refrence
        stepOut()
            }
    
    //Button Presses - IBACTIONS
    
    @IBAction func centerButtonPressed(_ sender: Any) {
        centerButton.isHidden = true
        greenCheck.isHidden = false
        redX.isHidden = false
        crossHairs.isHidden = false
        redFilter.isHidden = true
        
        //DELTE AFTER TESTING
        for i in activeTypesMainVC{
            print(i)
        }

    }
    
    @IBAction func greenCheckClicked(_ sender: Any) {
        greenCheck.isHidden = true
        centerButton.isHidden = false
        redX.isHidden = true
        crossHairs.isHidden = true
        redFilter.isHidden = false
    }
    
    @IBAction func redXPressed(_ sender: Any) {
        greenCheck.isHidden = true
        centerButton.isHidden = false
        redX.isHidden = true
        crossHairs.isHidden = true
        redFilter.isHidden = false
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    //Navigation Buttons - IBACTIONS
    
    @IBAction func zoomInPressed(_ sender: Any) {
        
        //grabbing current zoom data
        let previousRegion = mapView.region
        
        //makes a new MKCoordinateSpan that is more zoomed in based off of the current zoom
        //the *(float) represents how much of the previous view will be shown
        let newSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(exactly: previousRegion.span.latitudeDelta*0.5)!, longitudeDelta: CLLocationDegrees(exactly: previousRegion.span.longitudeDelta*0.5)!)
        
        //used the new MKCoordinateSpan to make a new MKCoordinateRegion that is more zoomed in
        let coordinateRegion = MKCoordinateRegion.init(center: previousRegion.center, span: newSpan)
        
        //sets the mapView region to the new MKCoordinateRegion
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func reCenterPressed(_ sender: Any) {
        centerMapOnLocation(location: locationManager.location!.coordinate, range: 1000.00)
    }
    
    @IBAction func zoomOutPressed(_ sender: Any) {
                
        //grabbing current zoom data
        let previousRegion = mapView.region
        
        //makes a new MKCoordinateSpan that is more zoomed out based off of the current zoom
        //the *(float) represents how much of the previous view will be shown
        let newSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(exactly: previousRegion.span.latitudeDelta*2)!, longitudeDelta: CLLocationDegrees(exactly: previousRegion.span.longitudeDelta*2)!)
        
        //used the new MKCoordinateSpan to make a new MKCoordinateRegion that is more zoomed out
        let coordinateRegion = MKCoordinateRegion.init(center: previousRegion.center, span: newSpan)
        
        //sets the mapView region to the new MKCoordinateRegion
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    //Location-Based Functions
    
    func showEventsOnMap(location: CLLocationCoordinate2D){
        
        mapView.removeAnnotations(mapView.annotations)

        let clLocation = CL2DToCL(input: location)
        
        for t in activeTypesMainVC{
        
            stepIn(child: t)
                let circleQuery = geoFire!.query(at: clLocation, withRadius: radius)
        
                _ = circleQuery.observe(.keyEntered, with: { (key: String!, clLocation: CLLocation!) in

                    if let _ = key, let _ = clLocation{

                        func makeAnno(result: CLLocationCoordinate2D, title: String, startTime: TimeInterval, endTime: TimeInterval, type: String, desc: String) {
                            if Double(endTime) > Double(Date().timeIntervalSince1970) {
                                let anno = EventAnnotation(coordinate: result, title: title, startTime: startTime, endTime: endTime, type: t, desc: desc)
                                self.mapView.addAnnotation(anno)
                               // print(result)
                               // print("ANNOTATION CREATED")
                               // print("Current Time: ", Double(Date().timeIntervalSince1970))
                            }
                            else if Double(endTime) < Double(Date().timeIntervalSince1970){
                                self.ref.child(t).child(key).removeValue()
                            }
                        }
                        self.gatherDataFromKey(key: String(key), category: t, callback: makeAnno)
                    }
                })
            
            stepOut()
        }
    }

    func gatherDataFromKey(key: String, category: String, callback: @escaping (CLLocationCoordinate2D, String, TimeInterval, TimeInterval, String, String) ->()){
        
        
       var lat: CLLocationDegrees = 0.0
       var long: CLLocationDegrees = 0.0
        var title: String = ""
        var endTime: TimeInterval = 0.0
        var startTime: TimeInterval = 0.0
        var desc: String = ""
        
        self.ref.child(category).child(key).observeSingleEvent(of: .value) { (DataSnapshot) in
            title = DataSnapshot.childSnapshot(forPath: "TITLE").value as! String
            lat = DataSnapshot.childSnapshot(forPath: "l").childSnapshot(forPath: "0").value as! CLLocationDegrees
            long = DataSnapshot.childSnapshot(forPath: "l").childSnapshot(forPath: "1").value as! CLLocationDegrees
            endTime = DataSnapshot.childSnapshot(forPath: "END TIME (SECS AFTER 1970)").value as! TimeInterval
            startTime = DataSnapshot.childSnapshot(forPath: "START TIME (SECS AFTER 1970)").value as! TimeInterval
            desc = DataSnapshot.childSnapshot(forPath: "DESCRIPTION").value as! String
            
            
            callback(CLLocationCoordinate2D(latitude: lat, longitude: long), title, startTime, endTime, category, desc)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        if !mapHasCenteredOnce{
            centerMapOnLocation(location: userLocation.coordinate, range: 1000.00)
             mapHasCenteredOnce = true
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            showEventsOnMap(location: locationManager.location!.coordinate)
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            mapView.showsUserLocation = true
        }
    }

    func centerMapOnLocation(location: CLLocationCoordinate2D, range: Double){
        let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: range, longitudinalMeters: range)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func CL2DToCL(input: CLLocationCoordinate2D) -> CLLocation{
        return CLLocation.init(latitude: input.latitude, longitude: input.longitude)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.setCenter(view.annotation!.coordinate, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectEventTypeCreation"{
            //should be as! EventCreaterTableView
            let vc = segue.destination as! FilterTableViewController
            vc.locationPassedFromVC1 = mapView.centerCoordinate
        }
        else if segue.identifier == "showInfo"{
            let vc = segue.destination as! InfoViewController
            vc.annoPassedFromVC1 = self.anno
        }
        else if segue.identifier == "mainToFilterVC"{
            let vc = segue.destination as! FilterViewController
            vc.activeTypes = self.activeTypesMainVC
            vc.delegate = self
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annoView: MKAnnotationView?
        let annoIdentifier = "Event"
        
        
        if annotation.isKind(of: MKUserLocation.self){
            return annoView
        }
        else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier){
            annoView = deqAnno
            annoView?.annotation = annotation
        }
        else{
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            annoView = av
        }
        
        if let annoView = annoView, let _ = annotation as? EventAnnotation {
            annoView.canShowCallout = true
            let btn = UIButton()
            let image = UIImage(named: "LocationMarker")
            let size = CGSize(width: 50, height: 50)
            let size2 = CGSize(width: 23, height: 30)
            let size3 = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
           // image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            annoView.image = image?.resize(targetSize: size)
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "Compass")?.resize(targetSize: size3), for: .normal)
            annoView.rightCalloutAccessoryView = btn
            let info = UIButton()
            info.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            info.setImage(UIImage(named: "Info")?.resize(targetSize: size2), for: .normal)
            annoView.leftCalloutAccessoryView = info
        }
        
        return annoView
    }
    
    //When scrolling, it updates events on map and updates region
    
   /* func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        showEventsOnMap(location: mapView.centerCoordinate)
    }*/
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let anno = view.annotation as? EventAnnotation {
                let place = MKPlacemark(coordinate: anno.coordinate)
                let destination = MKMapItem(placemark: place)
                destination.name = anno.title
                let regionDist: CLLocationDistance = 1000
                let regionSpan = MKCoordinateRegion(center: anno.coordinate, latitudinalMeters: regionDist, longitudinalMeters: regionDist)
                
                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
                
                MKMapItem.openMaps(with: [destination], launchOptions: options)
            }
            
            
        }
        else{
            self.anno = view.annotation as! EventAnnotation
            performSegue(withIdentifier: "showInfo", sender: self)
        }
        
    }
    
    
    
}
extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

}

extension ViewController: FilterViewControllerDelegate{
    func transferActiveTypes(data: [String]) {
        activeTypesMainVC = data
        showEventsOnMap(location: locationManager.location!.coordinate)
    }
}
