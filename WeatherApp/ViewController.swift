//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aya on 2/21/16.
//  Copyright © 2016 Aya. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController , CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UIAlertViewDelegate
{

    
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
    @IBOutlet weak var ColViewDays: UICollectionView!
    
    
    let locationManager = CLLocationManager ()
    
    
    var weather: Weather?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
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
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse
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
        weather = Weather (lat: crrlocatio.latitude, lon: crrlocatio.longitude, tempunit: TEMPRATURE_UNIT)
       
        weather!.DwonloadWeather { () -> () in
          self.UpdateScreenWithWeatherValues()
        }
            
        
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse
        {
             locationManager.startUpdatingLocation()
        }
        else
        {
           
            manager.requestWhenInUseAuthorization()
           let alertcontroller = UIAlertController (title: "", message: "Please chage the Location settings to 'While Using the App' in order to get user data", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action :UIAlertAction) -> Void in
                
            })
            let SettingAction = UIAlertAction (title: "Settings", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                
                 UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                /*dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                     UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                })*/
               
            })
            
            alertcontroller.addAction(cancelAction)
            alertcontroller.addAction(SettingAction)
            
            presentViewController(alertcontroller, animated: true, completion: nil)
          
           
        }
    }
    
    func UpdateScreenWithWeatherValues( )
    {
        
        if let w = weather
        {
            dispatch_async(dispatch_get_main_queue(),
                {
                    self.lblCity.text = w.City
                    
                    
                    if w.Tempreature5days.count > 0
                    {
                        let todayData = w.Tempreature5days[0]
                        self.lblTempMin.text = String.localizedStringWithFormat("%.0f", self.TempreatureAccordingtoUnit(todayData.Temp_min, _TempUnit: TEMPRATURE_UNIT))
                        self.lblTempMax.text = String.localizedStringWithFormat("%.0f", self.TempreatureAccordingtoUnit(todayData.Temp_max, _TempUnit: TEMPRATURE_UNIT))
                        self.lblPressure.text = String.localizedStringWithFormat("%.0f", todayData.Pressure)
                        self.lblhumedity.text = String.localizedStringWithFormat("%.0f%@", todayData.Humidity,"%")
                        self.lblWind.text = String.localizedStringWithFormat("%.0f", todayData.WindSpeed)
                        self.imgTemp.image = self.ConvertStringToImage(String.localizedStringWithFormat("%.0f", self.TempreatureAccordingtoUnit(todayData.Tempreture, _TempUnit:TEMPRATURE_UNIT) ))
                        self.imgWeatherStatus.image = UIImage (named: todayData.DayLooksLike)
                        self.lblDay.text = self.GetDayFromstring(todayData.Date)
                        self.lblTime.text = self.GetTimeFromSting(NSDate())
                        
                        
                        self.ColViewDays.reloadData()
                    }
                    
                    
                    
            })

        }
       
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
    
    
    func GetDayFromstring (str : NSDate )->String
    {
        let formatter =  NSDateFormatter()
       
        formatter.dateFormat = "EE"
        return  formatter.stringFromDate(str)
       
    }
    func GetTimeFromSting (str : NSDate) ->String
    {
        
        let formatter =  NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        return formatter.stringFromDate(str)
       
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as? DayDataCell
        {
            if weather!.Tempreature5days.count > indexPath.row + 1
            {
                let daydata = weather!.Tempreature5days[indexPath.row + 1 ]
                cell.ConfigureCell(GetDayFromstring(daydata.Date), mintemp: String.localizedStringWithFormat("%0.f", self.TempreatureAccordingtoUnit(daydata.Temp_min, _TempUnit: TEMPRATURE_UNIT)) , maxtemp: String.localizedStringWithFormat("%.0f",self.TempreatureAccordingtoUnit(daydata.Temp_max, _TempUnit: TEMPRATURE_UNIT) ))
                
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let w =  weather
        {
            
            return w.Tempreature5days.count-1
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return CGSizeMake(60.0, 64.0)
    }
    
    func TempreatureAccordingtoUnit(temp: Float, _TempUnit: TempratureUint ) -> Float
    {
        if _TempUnit == TempratureUint.Kelvin
        {
            return temp
        }
        else if _TempUnit == TempratureUint.Metric
        {
            return temp - 273.15
        }
        else
        {
            
            return ((temp - 273.15) * 1.8000) + 32.00
        }
        
    }

  
}

