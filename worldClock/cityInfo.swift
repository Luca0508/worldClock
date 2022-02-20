//
//  cityInfo.swift
//  worldClock
//
//  Created by 蕭鈺蒖 on 2022/2/10.
//

import Foundation
import UIKit
let knownTimeZoneID = TimeZone.knownTimeZoneIdentifiers.filter { ID in
    ID.contains("/")
}


struct cityInfo: Codable{
    
    
    var identify: String
    var cityName: String {
        let fullName = identify.replacingOccurrences(of: "_", with: " ").components(separatedBy: "/")
        if fullName.count > 2{
            return fullName[1] + ", " + fullName[2]
        }
        
        return fullName[1]
    }
    var cityPrefix : String{
        return String(cityName.prefix(1))
    }
    
    var relativeDate : String{
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(identifier: identify)

        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        dateformatter.doesRelativeDateFormatting = true
        
        return dateformatter.string(from: .now) + ","
        
    }
    
    var relativeHour : String {
        
        let hrInterval = (TimeZone(identifier: identify)!.secondsFromGMT() - TimeZone.current.secondsFromGMT())/3600
        if hrInterval == 1 || hrInterval == -1 {
            return hrInterval.description + "HR"
        }
        return hrInterval.description + "HRS"
    }
    
    var localTime : String{
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(identifier: identify)
        dateformatter.dateFormat = "HH:mm"
        return dateformatter.string(from: .now)
    }
    
    // save and load data
    static let documentDictionary = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadData() -> [cityInfo]?{
        let url = documentDictionary.appendingPathComponent("cityList")
        guard let data = try? Data(contentsOf: url) else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode([cityInfo].self, from: data)
        
    }
    
    static func saveInfo(info :[cityInfo]){
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(info) else {return }
        let url = documentDictionary.appendingPathComponent("cityList")
        try? data.write(to: url)
    }
}




