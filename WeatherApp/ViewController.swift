//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aya on 2/21/16.
//  Copyright © 2016 Aya. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController , CLLocationManagerDelegate {

    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblhumedity: UILabel!
    @IBOutlet weak var lblTempMax: UILabel!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var imgTemp: UIImageView!
    @IBOutlet weak var imgWeatherStatus: UIImageView!
    let locationManager = CLLocationManager ()
    
    var weather: Weather!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let today = NSDate()
        let formatter =  NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        lblTime.text = formatter.stringFromDate(today)
        print(lblTime.text)
        
        formatter.dateFormat = "EE"
        lblDay.text = formatter.stringFromDate(today)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool)
    {
        GetWeatherData()
        
    }

    
    func GetWeatherData()
    {
        
        LocationAuthorizationStatus()

    }
    
    
    
    func LocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            
            locationManager.startUpdatingLocation()
        }
        else
        {
                locationManager.requestWhenInUseAuthorization()
        }
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let crrlocatio = locations[0].coordinate
        
       locationManager.stopUpdatingLocation()
            
        NSUserDefaults.standardUserDefaults().setValue(crrlocatio.latitude, forKey: "Lat")
        NSUserDefaults.standardUserDefaults().setValue(crrlocatio.longitude, forKey: "Lng")
        weather = Weather (lat: crrlocatio.latitude, lon: crrlocatio.longitude, tempunit: TempratureUint.Imperial)
       
        weather.DwonloadWeather { () -> () in
          self.UpdateScreenWithWeatherValues()
        }
            
        
    }
    
    func UpdateScreenWithWeatherValues( )
    {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.lblCity.text = self.weather.City
            
            if self.weather.Tempreature5days.count > 0
            {
                let todayData = self.weather.Tempreature5days[0]
                self.lblTempMin.text = String.localizedStringWithFormat("%.0f", todayData.Temp_min)
                self.lblTempMax.text = String.localizedStringWithFormat("%.0f", todayData.Temp_max)
                self.lblPressure.text = String.localizedStringWithFormat("%.0f", todayData.Pressure)
                self.lblhumedity.text = String.localizedStringWithFormat("%.0f%@", todayData.Humidity,"%")
                self.lblWind.text = String.localizedStringWithFormat("%.0f", todayData.WindSpeed)
                self.imgTemp.image = self.ConvertStringToImage(String.localizedStringWithFormat("%.0f", todayData.Tempreture))
                self.imgWeatherStatus.image = UIImage (named: todayData.DayLooksLike)
                
            }
           
            
        })
    }
    
    func ConvertStringToImage (str:String) ->UIImage
    {
            // 1
            UIGraphicsBeginImageContextWithOptions(CGSize(width: imgTemp.frame.width, height: imgTemp.frame.height), false, 0)
                    
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            
            // 3
            let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 70)!, NSParagraphStyleAttributeName: paragraphStyle]
            
            // 4
            str.drawWithRect(CGRect(x: 0 , y: 0, width: imgTemp.frame.width, height: imgTemp.frame.height), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)
            
            // 5
           /* let mouse = UIImage(named: "mouse")
            mouse?.drawAtPoint(CGPoint(x: 300, y: 150))*/
            
            // 6
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 7
            return img
       
    }
    
}

