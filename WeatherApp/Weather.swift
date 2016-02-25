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
        print(url)
        
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
                            var crrDay = self.RetrieveDataFromOneItem(list[0])
                            
                            
                            
                            for var i = 1 ; i < list.count ; i++
                            {
                                let tempDay = self.RetrieveDataFromOneItem(list[i])
                                
                                let order = NSCalendar.currentCalendar().compareDate(crrDay.Date, toDate: tempDay.Date, toUnitGranularity: NSCalendarUnit.Day)
                                if order == .OrderedSame
                                {
                                    //if the same reset the max and minimium temp for that day
                                    if tempDay.Temp_min < crrDay.Temp_min
                                    {
                                        crrDay.Temp_min = tempDay.Temp_min
                                    }
                                    
                                    if tempDay.Temp_max > crrDay.Temp_max
                                    {
                                        crrDay.Temp_max = tempDay.Temp_max
                                    }
                                }
                                else // next day
                                {
                                    //we are done with the current day
                                    self._TempData5Days.append(crrDay)
                                    
                                    crrDay = tempDay
                                    
                                }
                            }
                            // add the last one because it wasn't added since it always gonna be the same
                            self._TempData5Days.append(crrDay)
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
    
    
    func RetrieveDataFromOneItem( list:Dictionary <String, AnyObject>) -> Tempreature
    {
        var temp: Float = 0.0
        var min_temp : Float = 0.0
        var max_temp: Float = 0.0
        var Pressure: Float = 0.0
        var humdity:Float = 0.0
        var wind: Float = 0.0
        var Dlooklike: String = "Clear"
        var date = NSDate()
        
        if let weatherdata = list["main"] as? Dictionary<String , AnyObject>
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
        
        if let windData = list["wind"] as? Dictionary<String , AnyObject>
        {
            if let speed = windData["speed"] as? Float
            {
                wind = speed
            }
        }
        
        
        if let WeatherData = list["weather"] as? [Dictionary <String, AnyObject>] where WeatherData.count > 0
        {
            if let daylooklike = WeatherData[0]["main"] as? String
            {
                Dlooklike = daylooklike
            }
        }
        if let datetxt = list["dt_txt"] as? String
        {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
            formatter.timeZone = NSTimeZone(abbreviation: "GMT")
            
            if let d = formatter.dateFromString(datetxt)
            {
                date = d
                print(date)
            }
            
            
        }
        
        let tempDay: Tempreature = Tempreature(temp: temp, min_temp: min_temp, max_temp: max_temp, humdity: humdity, pressure: Pressure, windspeed: wind, temp_unit: self._TempUnit , daylookslike: Dlooklike , date: date)
        return tempDay
    }
}






