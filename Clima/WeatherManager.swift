//
//  WeatherManager.swift
//  Clima
//
//  Created by Noel Poo on 2/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // API address, with API key and default params
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=84c17a57241f846543aad33f41002254&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(self.url)&q=\(cityName)"
        print("url string: \(urlString)")
        self.performRequest(with: urlString)
    }
    
    func fetchWeatherWithCoord(lat: Double, lon: Double){
        let urlString = "\(self.url)&lat=\(lat)&lon=\(lon)"
        print("url string: \(urlString)")
        self.performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. create a url, since this URL method is always option, we use if let
        if let url = URL(string: urlString) {
            //2. create a URLSession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            //task method will call handle method using completionHandler, closure method below
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                // data will be a json formated data
                if let safeData = data {
                    if let weather = self.parseJson(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
        
    }
    func parseJson(weatherData: Data) -> WeatherModel? {
//        let nameData: String?
//        let idData: Int?
//        let tzData: Int?
        
        let decoder = JSONDecoder()
        //decode is a throw method, that can throw an error, put in "do" block and catch the error
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weatherID = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: weatherID, cityName: name, temperature: temp)
            
//            print(weather.cityName)
//            print(weather.temperature)
//            print(weather.conditionName)
//            print(weather.temperatureString)
            
            return weather
        } catch {
            //print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    

    
//    func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
//        //error could be an error code?
//        if error != nil {
//            print(error!)
//            return
//        }
//        // data will be a json formated data
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print("dataString: \(dataString!)")
//        }
//    }

}



