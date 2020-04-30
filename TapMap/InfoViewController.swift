//
//  InfoViewController.swift
//  TapMap
//
//  Created by Brandon Samaroo on 11/23/19.
//  Copyright © 2019 Brandon Samaroo. All rights reserved.
//

import UIKit
import MapKit


class InfoViewController: UIViewController {
    

    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var outterRectangle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Date1: UILabel!
    @IBOutlet weak var Time1: UILabel!
    @IBOutlet weak var Date2: UILabel!
    @IBOutlet weak var Time2: UILabel!
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var Category: UILabel!
    
    @IBOutlet weak var BottomStackView: UIStackView!
    
    
    var annoPassedFromVC1: EventAnnotation = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), title: "", startTime: 0.0, endTime: 0.0, type: "", desc: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //overrides user interface style to light if IOS 13.0 or newer
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        //resize infoButton
        infoButton.setImage(infoButton.image(for: .normal)?.resize(targetSize: CGSize(width: 50, height: 75)), for: .normal)

        let formatter = DateFormatter()
        //formatter.dateStyle = .short
        formatter.dateFormat = "M/d"
        outterRectangle.layer.masksToBounds = true
        outterRectangle.layer.cornerRadius = 25
        Category.layer.masksToBounds = true
        Category.layer.cornerRadius = 25
        titleLabel.text = annoPassedFromVC1.title
        DescriptionText.text = annoPassedFromVC1.desc
        Date1.text = formatter.string(from: Date(timeIntervalSince1970: annoPassedFromVC1.startTime))
        Date2.text = formatter.string(from: Date(timeIntervalSince1970: annoPassedFromVC1.endTime))
        formatter.dateFormat = "HH:mm"
        Time1.text = formatter.string(from: Date(timeIntervalSince1970: annoPassedFromVC1.startTime))
        Time2.text = formatter.string(from: Date(timeIntervalSince1970: annoPassedFromVC1.endTime))
        Category.text = annoPassedFromVC1.type
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneLookingAtInfo"{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "doneLookingAtInfo", sender: self)
    }

}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
