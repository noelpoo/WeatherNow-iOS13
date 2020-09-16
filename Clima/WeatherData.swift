//
//  WeatherData.swift
//  Clima
//
//  Created by Noel Poo on 2/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

// codable protocol = decodable + encodable protocols
struct WeatherData: Codable {
    // property names got to match property names in the json response
    let name: String
    let id: Int
    let timezone: Int
    let main: Main
    let weather: [Weather] // weather is a list of objects in the json response
}
// sub struct in json response has to be created here
struct Main: Codable {
    let temp: Float32
    let feels_like: Float32
    let temp_min: Float32
    let temp_max: Float32
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}




