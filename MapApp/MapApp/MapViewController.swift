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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var uniqueKey: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()){
            self.loadStudentLocations()}
        ParseClient.sharedInstance.getCurrentStudent(StudentManager.sharedInstance().currentStudentKey){ success, data, error in}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //uniqueKey = StudentManager.sharedInstance().currentStudentKey
        
    }
    
    @IBAction func addPinButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("LocationEntrySegue", sender: self)
        
        //ParseClient.sharedInstance.postLocation(uniqueKey! as! String){data, error in
            
        //}
        
        
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
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
            
        }
        else{
            pinView?.annotation = annotation
        }
        return pinView!
    }
    func mapView(mapView:MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if control == annotationView.rightCalloutAccessoryView{
            let application = UIApplication.sharedApplication()
            let urlString = annotationView.annotation?.subtitle!
            if urlString!.hasPrefix("www"){
                let urlString = ("http://" + urlString!)
                let url = NSURL(string: urlString)
                if application.canOpenURL(url!){
                    application.openURL(url!)
                }
            }
            else if urlString!.hasPrefix("http://") || urlString!.hasPrefix("https://"){
                let url = NSURL(string: urlString!)
                if application.canOpenURL(url!){
                    application.openURL(url!)
                }
            }
            else{
                let urlString = ("http://www." + urlString!)
                let url = NSURL(string: urlString)
                if application.canOpenURL(url!){
                        application.openURL(url!)
                }
                else{
                    alertView("Error", message: "Cannot Open Website")
                }
            }
        }
    }
    
    func alertView(tite: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {}
}