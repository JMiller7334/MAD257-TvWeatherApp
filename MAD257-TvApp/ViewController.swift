//
//  ViewController.swift
//  MAD257-TvApp
//
//  Created by student on 3/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    let LAT = "42.24"
    let LON = "88.31"
    let API_KEY = "1db914c623ec2e5caba5ddfe8e12b0de"
    var incomingData: [String:AnyObject] = [:]
    
    @IBOutlet var currentTemp: UILabel!
    @IBOutlet var currentSummary: UILabel!
    @IBOutlet var tempInfo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.background(background: {
            // do something in background
            self.incomingData = self.updateWeather()
        }, completion:{
            // when background job finished, do something in main thread
            
            print("Weather App: Data retreived!")
            let mainData = self.incomingData["main"]!
            self.currentTemp.text = "\(mainData["temp"]!!)°"
            self.currentSummary.text = "Humidity: \(mainData["humidity"]!!) % | Wind: \(self.incomingData["wind"]!["speed"]!!) mph"
            self.tempInfo.text = "Max: \(mainData["temp_max"]!!)° | Min: \(mainData["temp_min"]!!)° | Feels Like: \(mainData["feels_like"]!!)°"
            
            /*if let main = parsed["main"] as? [String: AnyObject], let weather = main["weather"]{
                currentSummary.text = "\(weather["description"]!!)"
            }*/
        })
    }
    
    
    func updateWeather() -> [String:AnyObject]{
        if let url = NSURL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(LAT)&lon=\(LON)&units=imperial&appid=\(API_KEY)"
        ){ if let data = NSData(contentsOf: url as URL){
            do {
                let parsed = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                    let newDict = parsed
                    print(newDict)
                    return newDict
                }
                catch let error as NSError {
                    print("WeatherApp: \(error)")
                    
                }
            }
        }
        return [:]
    }
}

//MULTI THREADING EXTENSION
extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

