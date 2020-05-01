//
//  CategoriesLoader.swift
//  14_JSON_Defaults
//
//  Created by Mykyta Pohorielov on 25/02/2020.
//  Copyright © 2020 Mykyta Pohorielov. All rights reserved.
//

import Foundation
import Alamofire

class LoaderWeather {
    func tiempo(_ dt: TimeInterval) -> String{
        let date = NSDate(timeIntervalSince1970: dt)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM HH:mm"
        return "\(dateFormatterPrint.string(from: date as Date))"
    }
    func loadStandartNow(completion: @escaping (WeatherMain) -> Void ){
        if Persistance.shared.datos != nil {
            let fdata = Persistance.shared.ahora!
            let done = WeatherMain(data: fdata["data"]! as! NSDictionary, fdata["dt"]! as? String)!
            DispatchQueue.main.async { completion(done) }
        }
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?id=524901&appid=39e7138d25a95e1dd3f26683ffe4c9fe&lang=ru&units=metric")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let jsonDict = json as? NSDictionary {
                let fcategory = WeatherMain(data: jsonDict["main"] as! NSDictionary, self.tiempo(jsonDict["dt"] as! TimeInterval))
                
                Persistance.shared.ahora = fcategory!.getCL()
                DispatchQueue.main.async { completion(fcategory!) }
            }
        }
        task.resume()
    }
    func loadStandart5Days(completion: @escaping ([WeatherMain]) -> Void ){
        if Persistance.shared.datos != nil {
            var done: [WeatherMain] = []
            for temp in Persistance.shared.datos! {
                for (_, data) in temp where data is NSDictionary {
                    if let category = WeatherMain(data: data as! NSDictionary, temp["dt"] as? String) { done.append(category) }
                }
            }
            DispatchQueue.main.async { completion(done) }
        }
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=39e7138d25a95e1dd3f26683ffe4c9fe&lang=ru&units=metric")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let jsonDict = json as? NSDictionary, let list = jsonDict["list"] as? [[String: Any]] {
                var categories: [WeatherMain] = []
                var guardar: [NSDictionary] = []
                for temp in list {
                    for (_, data) in temp where data is NSDictionary{
                        if let category = WeatherMain(data: data as! NSDictionary, self.tiempo(temp["dt"] as! TimeInterval))
                        {
                            guardar.append(category.getCL())
                            categories.append(category)
                        }
                    }
                }
                Persistance.shared.datos = guardar
                DispatchQueue.main.async { completion(categories) }
            }
        }
        task.resume()
    }
    
//Alamofire
    func loadAlamofireNow(completion: @escaping (WeatherMain) -> Void ){
        if Persistance.shared.datos != nil {
            let fdata = Persistance.shared.ahora!
            let done = WeatherMain(data: fdata["data"]! as! NSDictionary, fdata["dt"]! as? String)!
            DispatchQueue.main.async { completion(done) }
        }
        AF.request("https://api.openweathermap.org/data/2.5/weather?id=524901&appid=39e7138d25a95e1dd3f26683ffe4c9fe&lang=ru&units=metric").responseJSON {
            response in
            if let objects = response.value,
                let jsonDict = objects as? NSDictionary {
                let fcategory = WeatherMain(data: jsonDict["main"] as! NSDictionary, self.tiempo(jsonDict["dt"] as! TimeInterval))

                Persistance.shared.ahora = fcategory!.getCL()
                DispatchQueue.main.async { completion(fcategory!) }
            }
        }
    }
    
    func loadAlamofire5Days(completion: @escaping ([WeatherMain]) -> Void ){
        if Persistance.shared.datos != nil {
            var done: [WeatherMain] = []
            for temp in Persistance.shared.datos! {
                for (_, data) in temp where data is NSDictionary {
                    if let category = WeatherMain(data: data as! NSDictionary, temp["dt"] as? String) { done.append(category) }
                }
            }
            DispatchQueue.main.async { completion(done) }
        }
        
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=39e7138d25a95e1dd3f26683ffe4c9fe&lang=ru&units=metric").responseJSON {
            response in
            if let objects = response.value,
                let jsonDict = objects as? NSDictionary,
                let list = jsonDict["list"] as? [[String: Any]] {
                var categories: [WeatherMain] = []
                var guardar: [NSDictionary] = []
                for temp in list {
                    for (_, data) in temp where data is NSDictionary{
                        if let category = WeatherMain(data: data as! NSDictionary, self.tiempo(temp["dt"] as! TimeInterval))
                        {
                            guardar.append(category.getCL())
                            categories.append(category)
                        }
                    }
                }
                DispatchQueue.main.async { completion(categories) }
            }
        }
    }
}
