//
//  DayDataCell.swift
//  WeatherApp
//
//  Created by Aya on 2/25/16.
//  Copyright © 2016 Aya. All rights reserved.
//

import UIKit

class DayDataCell: UICollectionViewCell
{
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    func ConfigureCell( day: String , mintemp: String, maxtemp: String)
    {
        lblDay.text = day
        lblMinTemp.text = mintemp
        lblMaxTemp.text = maxtemp
    }
    
}
