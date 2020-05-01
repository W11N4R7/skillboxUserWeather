//
//  ViewController.swift
//  14_JSON_Defaults
//
//  Created by Mykyta Pohorielov on 23/02/2020.
//  Copyright © 2020 Mykyta Pohorielov. All rights reserved.
//
/*
 Зарегистрируйтесь на https://openweathermap.org/api. Создайте один проект, в котором будет два контроллера, каждый из которых реализует следующие задачи (в первом контроллере с использованием стандартных средств, во втором – с использованием Alamofire):
 Сделайте показ текущей погоды для Москвы     api.openweathermap.org/data/2.5/weather?id=524901&appid=39e7138d25a95e1dd3f26683ffe4c9fe&lang=ru&units=metric
 Сделайте показ прогноза на ближайшие 5 дней и 3 часа в виде таблицы (тоже для Москвы) api.openweathermap.org/data/2.5/forecast?id=524901&appid=39e7138d25a95e1dd3f26683ffe4c9fe&lang=ru&units=metric
 Изучите, что такое Carthage: https://github.com/Carthage/Carthage.

 Ответьте на следующий вопрос: в чем разница Carthage и Cocoapods?
 Создайте новый проект и интегрируйте в него Alamofire с помощью Carthage
 */
/*
 
 */
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var yableView: UITableView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var categories: [WeatherMain] = []
    var weatherData: [WeatherMain] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        LoaderWeather().loadStandartNow { model in
            self.tempLabel.text = "T: \(String(format: "%.0f", model.temp))"
            self.pressureLabel.text = "P: \(model.pressure)"
            self.humidityLabel.text = "H: \(model.humidity)"
            self.minTempLabel.text = "T min: \(String(format: "%.0f", model.tempMin))"
            self.maxTempLabel.text = "T max: \(String(format: "%.0f", model.tempMax))"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        LoaderWeather().loadStandart5Days { categories in
            self.categories = categories
            self.yableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        let model = categories[indexPath.row]
        cell.categoryNameLabel.text = "T: \(String(format: "%.0f", model.temp))"
        cell.categorySortOrderLabel.text = "P: \(model.pressure)"
        cell.categoryHumidity.text = "H: \(model.humidity)"
        cell.categoryTiempo.text = model.tiempo
        return cell
    }
}

