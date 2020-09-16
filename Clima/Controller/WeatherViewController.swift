//
//  ViewController.swift
//  Clima
//
//  Created by Noel Poo on 19/08/2020.
//  Copyright © 2020 App brewery. All rights reserved.
//

import UIKit
import CoreLocation
//view controller must be a delegate of UItextfield, a protocol, in order for vc to interact with uitextfield
// setting VC as a delegate of weathermanager

//MARK: - UIViewcontroller
class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() // GPS object from Corelocation library
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for text field to communicate with view controller, setting this current VC as delegate for UItextfield
        // to show permision popup for location services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchField.delegate = self
        weatherManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: -UITextFieldDelegate
// creating an extension of WeatherViewcontroller class with UItextfield delegate protocol
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //dismiss keybaord when search is pressed
        searchField.endEditing(true)
        let city = searchField.text
        print(city ?? "")
        weatherManager.fetchWeather(cityName: city ?? "")
    }
    // the funcs below are called by UITextField class, below functions are delegate functions
    // this function is a delegate function, a function that can exist for all UITestFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //dismiss keyboard when return is pressed
        searchField.endEditing(true)
        print(searchField.text ?? "")
        return true
    }
    // when user taps on search or enter during editing, do a check, if pass, end editing and dismiss keyboard
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "please enter city name"
            return false
        }
    }
    
    // function for wad happens after text field editing is done
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        // get weather data from string input
        searchField.text = ""
    }
}

//MARK: - WatherManagerDelegate
// creating an extension of VC class with protocol weathermanager delegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("temp string: \(weather.temperatureString)")
        print("weather string: \(weather.conditionName)")
        print("city string: \(weather.cityName)")
        // updating or reading UI labels should be done in the main thread, not in a background process. to do this call DispatchQueue.main.async method, since didUpdateWeather is called in a completion handler (a bg network process)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        //        self.temperatureLabel.text = weather.temperatureString
        //        self.cityLabel.text = weather.cityName
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeatherWithCoord(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
