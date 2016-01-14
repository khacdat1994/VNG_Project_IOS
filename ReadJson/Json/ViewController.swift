//
//  ViewController.swift
//  Json
//
//  Created by QuangKomodo on 14/01/2016.
//  Copyright © Năm 2016 Nova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var latitudeFrom : Double!
    var LongtitudeFrom : Double!
    var latitudeTo : Double!
    var LongtitudeTo : Double!
   
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://vngmap-anhdat.rhcloud.com/MapVNGWS/data/json/location")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                do {
                    let jsonResult:NSArray = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
                    
                    let locaFrom = jsonResult[0]
                    self.latitudeFrom = locaFrom["latitude"] as! Double
                    self.LongtitudeFrom = locaFrom["longitude"] as! Double
                    //print("\(self.latitudeFrom)  \(self.LongtitudeFrom)")
                    let locaTo = jsonResult[0]
                    self.latitudeTo = locaTo["latitude"] as! Double
                    self.LongtitudeTo = locaTo["longitude"] as! Double
                    //print("\(self.latitudeTo)  \(self.LongtitudeTo)")
                    self.lblFrom.text = self.lblFrom.text! + "\(self.latitudeFrom)  \(self.LongtitudeFrom)"
                    self.lblTo.text = self.lblTo.text! + "\(self.latitudeTo)  \(self.LongtitudeTo)"
                    
                    
                    //  Code for unwrapping 'jsonResult'
                    
                    //  End of unwrapping 'If you worked it out, thank you!!!!!!!!!
                } catch {
                    print("Error")
                }
                
            }
        }
        task.resume()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

