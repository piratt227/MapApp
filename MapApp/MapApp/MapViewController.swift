//
//  MapViewController.swift
//  MapApp
//
//  Created by Aaron Phillips on 6/22/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var mapView: MKMapView!
    
    var uniqueKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        uniqueKey = StudentManager.sharedInstance().currentStudentKey
        
        
    }
    
    @IBAction func addPinButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("LocationEntrySegue", sender: self)
        ParseClient.sharedInstance.getCurrentStudent(uniqueKey!){ success, data, error in}
        ParseClient.sharedInstance.postLocation(uniqueKey!){data, error in
            
        }
        
        
    }
    
    func loadStudentLocations(){
        ParseClient.sharedInstance.getStudentLocations(){ (success, result, error) in
            self.loadPins(result)
        }
    }
    
    func loadPins(data: [[String:AnyObject]]){
        let students = StudentManager.sharedInstance().students
        var annotations = [MKAnnotation]()
        for student in students{
            let firstName = student.firstName as String!
            let lastName = student.lastName as String!
            let mediaURL = student.mediaURL as String!
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(student.latitude!)), longitude: CLLocationDegrees(Double(student.longitude!)))
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = "\(mediaURL)"
            annotations.append(annotation)
                }
        
        mapView.addAnnotations(annotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let reuseID = "pinID"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        return pinView!
    }
    
}