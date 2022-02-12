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
//    init(identify : String){
//        self.identify = identify
//    }
//
//    static var timezone = TimeZone(identifier: identify)
    var cityName: String {
        
        return identify.components(separatedBy: "/")[1].replacingOccurrences(of: "_", with: " ")
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
        
//        let currentDateFormatter = DateFormatter()
//        currentDateFormatter.timeZone = .current
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
//
    
//    static func saveInfo(info :[cityInfo]){
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(info) else {return }
//    }
}




