//
//  ViewController.swift
//  Map7
//
//  Created by QuangKomodo on 12/01/2016.
//  Copyright (c) Năm 2016 Nova. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var viewMap: MKMapView!
    var newAnnotation = MKPointAnnotation()
    var matchingItems : [MKMapItem] = [MKMapItem]()
    var locationManager: CLLocationManager!
    var latitude : CLLocationDegrees = 2.1
    var longtitude : CLLocationDegrees = 2.1
    
    var latitudeTo : CLLocationDegrees = 2.1
    var longtitudeTo : CLLocationDegrees = 2.1

    
    
    @IBAction func btnTim(sender: AnyObject) {
         var request = MKDirectionsRequest()
        request.setSource(MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longtitude), addressDictionary: nil)))
        request.setDestination(MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitudeTo, longtitudeTo), addressDictionary: nil)))
        println("\(longtitude)")
        println("\(longtitudeTo)")
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                // Handle error
                print("error")
            } else {
                println("error = nil")
                println("\(response)")
                self.showRoute(response)
            }
            
        })
        viewMap.delegate = self
        
    }
    
    
    
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        println("run mapView")
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        return renderer    }
    
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes as [MKRoute] {
            
            viewMap.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            println("\(route)")
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func textFromDidEndOnExit(sender: AnyObject) {
        self.performSearchFrom()
        println("aaa")
        println("\(latitude) axo \(longtitude)")
    }
    
    
    @IBAction func textDidEndOnExit(sender: AnyObject) {
        //viewMap.removeAnnotations(viewMap.annotations)
        self.performSearchTo()
        
    }
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       viewMap.showsUserLocation = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func performSearchFrom() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = txtFrom.text
        request.region = viewMap.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response:
            MKLocalSearchResponse!,
            error: NSError!) in
            
            if error != nil {
                println("Error occured in search: \(error.localizedDescription)")
            } else if response.mapItems.count == 0 {
                println("No matches found")
            } else {
                println("Matches found")
                
                for item in response.mapItems as[MKMapItem] {
                    println("Name = \(item.name)")
                    println("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    println("Matching items = \(self.matchingItems.count)")
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.viewMap.addAnnotation(annotation)
                    self.latitude = annotation.coordinate.latitude
                    self.longtitude = annotation.coordinate.longitude
                    
                    
                }
            }
        })
    }

    
    func performSearchTo() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = txtTo.text
        request.region = viewMap.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response:
            MKLocalSearchResponse!,
            error: NSError!) in
            
            if error != nil {
                println("Error occured in search: \(error.localizedDescription)")
            } else if response.mapItems.count == 0 {
                println("No matches found")
            } else {
                println("Matches found")
                
                for item in response.mapItems as[MKMapItem] {
                    println("Name = \(item.name)")
                    println("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    println("Matching items = \(self.matchingItems.count)")
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.viewMap.addAnnotation(annotation)
                    self.latitudeTo = annotation.coordinate.latitude
                    self.longtitudeTo = annotation.coordinate.longitude
                    
                    
                }
            }
        })
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

