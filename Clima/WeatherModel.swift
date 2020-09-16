//
//  WeatherModel.swift
//  Clima
//
//  Created by Noel Poo on 4/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let conditionID: Int
    let cityName: String
    let temperature: Float32
    // conditionName is a computed property than can be assigned using a function with inputs
    var conditionName: String {
        return self.getConditionName(weatherID: self.conditionID)
    }
    // computed property to return temperature as string in 1 decimal place
    var temperatureString: String {
        return String(format: "%.1f", self.temperature)
    }
    
    func getConditionName(weatherID: Int) -> String {
        var weatherString: String
        switch weatherID {
        case 200...232:
            weatherString = "cloud.bolt"
        case 300...321:
            weatherString = "cloud.drizzle"
        case 500...531:
            weatherString = "cloud.drizzle.fill"
        case 600...622:
            weatherString = "cloud.snow"
        case 701...781:
            weatherString = "smoke.fill"
        case 800:
            weatherString = "sun.min"
        case 801...804:
            weatherString = "cloud.fill"
        default:
            weatherString = "cloud"
        }
        return weatherString
    }
    
}



