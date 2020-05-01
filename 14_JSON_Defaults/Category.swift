//
//  category.swift
//  14_JSON_Defaults
//
//  Created by Mykyta Pohorielov on 24/02/2020.
//  Copyright © 2020 Mykyta Pohorielov. All rights reserved.
//

import Foundation

class WeatherMain {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    let tiempo: String
    
    init?(data: NSDictionary, _ dt: String?){
        guard let temp = data["temp"] as? Double,
            let pressure = data["pressure"] as? Int,
            let humidity = data["humidity"] as? Int,
            let tempMin = data["temp_min"] as? Double,
            let tempMax = data["temp_max"] as? Double,
            let tiempo = (dt != nil) ? dt : "-" else {
                return nil
        }
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.tiempo = tiempo
    }
    
    func getCL() -> NSDictionary {
        let sen: NSDictionary = ["temp": temp, "pressure": pressure, "humidity": humidity, "temp_min": tempMin, "temp_max": tempMax]
        let bye: NSDictionary = ["data": sen, "dt": tiempo]
        return bye
    }
}

class Persistance {
    static let shared = Persistance()
    
    private let kDatosKey       = "Persistance.kDatosKey"
    private let kAhoraKey       = "Persistance.kAhoraKey"

    var ahora: NSDictionary? {
        set { UserDefaults.standard.set(newValue, forKey: kAhoraKey) }
        get { return UserDefaults.standard.dictionary(forKey: kAhoraKey) as NSDictionary? }
    }
    var datos: [NSDictionary]? {
        set { UserDefaults.standard.set(newValue, forKey: kDatosKey) }
        get { return UserDefaults.standard.array(forKey: kDatosKey) as? [NSDictionary] }
    }
}
