//
//  Weather.swift
//  WeatherApp
//
//  Created by Aya on 2/21/16.
//  Copyright © 2016 Aya. All rights reserved.
//




import Foundation


class Weather
{
    
    private var _lat: Double!
    private var _lon: Double!
    private var _city: String!
    private var _TempUnit: TempratureUint = TempratureUint.Kelvin
    private var _TempData5Days = [Tempreature]()
    
    var City: String
    {
        get
        {
            if _city == nil
            {
                return ""
            }
            return _city
        }
    }
    
    
    var Tempreature5days: [Tempreature]
    {
        get
        {
            return _TempData5Days
        }
    }
    
    
    init (lat: Double , lon: Double , tempunit: TempratureUint)
    {
        self._lat = lat
        self._lon = lon
        _TempUnit = tempunit
    }
    
       
    
    
    func DwonloadWeather (completed : Completed)
    {
        let urlstr = "\(BASE_URL)lat=\(_lat)&lon=\(_lon)&appid=\(API_KEY)"
        let url = NSURL(string: urlstr)!
        
        let  session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
         
            
            if let responseData = data
            {
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                   
                    if let dict = json as? Dictionary <String , AnyObject>
                    {
                       
                        if let city = dict["city"] as? Dictionary<String , AnyObject>
                        {
                            if let cityname = city["name"] as? String
                            {
                                self._city = cityname
                            }
                        }
                        self._TempData5Days = [Tempreature]()
                        if let list = dict["list"] as? [Dictionary <String ,AnyObject>] where list.count > 0
                        {
                            print("\(list.count)")
                            
                            for var i = 0 ; i < list.count ; i += 7
                            {
                                print("\(i)")
                                var temp: Float = 0.0
                                var min_temp : Float = 0.0
                                var max_temp: Float = 0.0
                                var Pressure: Float = 0.0
                                var humdity:Float = 0.0
                                var wind: Float = 0.0
                                var Dlooklike: String = "Clear"
                                var date = NSDate()
                                
                                if let weatherdata = list[i]["main"] as? Dictionary<String , AnyObject>
                                {
                                    if let Temp = weatherdata["temp"] as? Float
                                    {
                                       temp  = Temp
                                        
                                    }
                                    if let temp_min = weatherdata["temp_min"] as? Float
                                    {
                                        min_temp = temp_min
                                        
                                    }
                                    if let temp_max = weatherdata["temp_max"] as? Float
                                    {
                                        max_temp = temp_max
                                    }
                                    if let press = weatherdata["pressure"] as? Float
                                    {
                                        Pressure = press
                                    }
                                    if let hum = weatherdata["humidity"] as? Float
                                    {
                                        humdity = hum
                                    }
                                }
                                
                                if let windData = list[i]["wind"] as? Dictionary<String , AnyObject>
                                {
                                    if let speed = windData["speed"] as? Float
                                    {
                                        wind = speed
                                    }
                                }
                                
                                
                                if let WeatherData = list[i]["weather"] as? [Dictionary <String, AnyObject>] where WeatherData.count > 0
                                {
                                    if let daylooklike = WeatherData[0]["main"] as? String
                                    {
                                        Dlooklike = daylooklike
                                    }
                                }
                                if let datetxt = list[i]["dt_txt"] as? String
                                {
                                    let formatter = NSDateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
                                    formatter.timeZone = NSTimeZone(abbreviation: "GMT")
                                    
                                    if let d = formatter.dateFromString(datetxt)
                                    {
                                        date = d
                                        
                                    }
                                    
                                    
                                }
                                
                                let tempDay: Tempreature = Tempreature(temp: temp, min_temp: min_temp, max_temp: max_temp, humdity: humdity, pressure: Pressure, windspeed: wind, temp_unit: self._TempUnit , daylookslike: Dlooklike , date: date)
                                
                                self._TempData5Days.append(tempDay)
                            }
                        }
                        
                        completed()
                    }
                }
                catch
                {
                    print("error")
                }
                
            }

        }.resume()
      
    }
}






