//
//  Tempreature.swift
//  WeatherApp
//
//  Created by Aya on 2/24/16.
//  Copyright © 2016 Aya. All rights reserved.
//




import Foundation


enum TempratureUint: Int
{
    case Kelvin
    case Metric
    case Imperial
}



class Tempreature
{
    private var _Temp: Float!
    private var _Humidity: Float!
    private var _Pressure: Float!
    private var _Temp_min: Float!
    private var _Temp_max: Float!
    private var _WindSpeed: Float!
    
    private var _TempUnit: TempratureUint = TempratureUint.Kelvin
    private var _DayLooksLike: String = "Clear"
    private var _Date = NSDate()
    
    var Tempreture: Float
        {
        get
        {
            return TempreatureAccordingtoUnit(_Temp)
        }
    }
    
    var Humidity : Float
        {
        get
        {
            return _Humidity
        }
    }
    
    var Pressure : Float
        {
        get
        {
            return _Pressure / 100 // convert to pascal
        }
    }
    
    var Temp_min : Float
        {
        get
        {
            return TempreatureAccordingtoUnit( _Temp_min)
        }
    }
    
    var Temp_max : Float
        {
        get
        {
            return TempreatureAccordingtoUnit( _Temp_max)
        }
    }
    
    
    var WindSpeed: Float
        {
            return _WindSpeed
    }
    
    var DayLooksLike: String
    {
        get
        {
            return _DayLooksLike
        }
    }
    
    var Date : NSDate
    {
        get
        {
            return _Date
        }
    }
    
    init (temp: Float, min_temp: Float, max_temp: Float, humdity: Float, pressure: Float, windspeed: Float , temp_unit: TempratureUint , daylookslike: String, date: NSDate)
    {
        _Temp = temp
        _Temp_min = min_temp
        _Temp_max = max_temp
        _Humidity = humdity
        _Pressure = pressure
        _WindSpeed = windspeed
        _TempUnit = temp_unit
        _DayLooksLike = daylookslike
        _Date = date
    }

    private func TempreatureAccordingtoUnit(temp: Float) -> Float
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