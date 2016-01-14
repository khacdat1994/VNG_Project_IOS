//
//  ViewController.swift
//  Map82
//
//  Created by QuangKomodo on 13/01/2016.
//  Copyright © Năm 2016 Nova. All rights reserved.
//

import UIKit
import MapKit
import LocalAuthentication

class ViewController: UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate{

    @IBOutlet weak var viewMap: MKMapView!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var lblNum: UILabel!
    
    
    
    @IBAction func txtInputDidEndOnExit(sender: AnyObject) {
        performSearch()
        lblNum.text = "\(count)"
        
    }
    
    
    @IBAction func btnDraw(sender: AnyObject) {
        var request: MKDirectionsRequest!
        var directions: MKDirections!
        var i = 0
        repeat
        {
            request = MKDirectionsRequest()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(arr[i].coordinate.latitude, arr[i].coordinate.longitude), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(arr[i + 1].coordinate.latitude, arr[i + 1].coordinate.longitude), addressDictionary: nil))
            directions = MKDirections(request: request)
            directions.calculateDirectionsWithCompletionHandler{
                response, error in
                if error != nil {
                    // Handle error
                    print("error")
                } else {
                    self.showRoute(response!)
                }
                
            }
            i++

            
        } while i < arr.count - 1
        
        viewMap.delegate = self
    }
    
    func showRoute(response: MKDirectionsResponse)
    {
        for route in response.routes as [MKRoute]
        {
            viewMap.addOverlay(route.polyline, level: MKOverlayLevel.AboveLabels)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        print("run mapView")
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        return renderer
    }


    var locationManager:CLLocationManager!
    
    var arr :[MKPointAnnotation] = [MKPointAnnotation]()
    var matchingItem :[MKMapItem] = [MKMapItem]()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        viewMap.showsUserLocation = true
        
        let locValue  = locationManager.location?.coordinate
        
        let location = CLLocationCoordinate2DMake(locValue!.latitude, locValue!.longitude)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        
        let region = MKCoordinateRegionMake(location, span)
        viewMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        viewMap.addAnnotation(annotation)
        arr.insert(annotation, atIndex: count)
        count++
    }
   
    func performSearch()
    {
        matchingItem.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = txtInput.text
        request.region = viewMap.region
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler{
            response, error in
            
            guard let response = response else {
                return
            }
            
            for item in response.mapItems{
                
                print("Item name = \(item.name)")
                print("Item phone number = \(item.phoneNumber)")
                print("Item url = \(item.url)")
                print("Item location = \(item.placemark.location)")
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.viewMap.addAnnotation(annotation)
                self.arr.insert(annotation, atIndex: self.count)
                self.count++
                
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

