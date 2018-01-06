//
//  WeatherTVC.swift
//  Spotters
//
//  Created by Walter Edgar on 11/29/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import ForecastIO
import MapKit
import CoreLocation
import Alamofire
import AVFoundation

class WeatherTVC: UITableViewController, UIPickerViewDelegate {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var appTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windGustLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var moonPhaseLabel: UILabel!
    @IBOutlet weak var nextFullMoonLabel: UILabel!
    @IBOutlet weak var moonRiseLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var metarCell: UITableViewCell!
    
    @IBOutlet weak var moonRiseSetTitle: UILabel!
    @IBOutlet var myTableView: UITableView!
    
    
    @IBOutlet weak var compass: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var metarLabel: UILabel!
    @IBOutlet weak var metarTitle: UILabel!
    @IBOutlet weak var metarDecodeLabel: UILabel!
    
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var moreMetar: UIButton!
    
    @IBAction func readSpeech(_ sender: Any) {
//        let voice = AVSpeechSynthesisVoice(language: "en-US")
        let voice = AVSpeechSynthesisVoice()
        let toSay = AVSpeechUtterance(string: speech)
//        let toSay = AVSpeechUtterance(string: "hello there Walter. this is a test")
        toSay.voice = voice
        let spk = AVSpeechSynthesizer()
        spk.speak(toSay)
    }
    
    let locationManager = CLLocationManager()
    
    var tableViewController = UITableViewController(style: .plain)
    var pullRefresh: UIRefreshControl = UIRefreshControl()
    var locations = [String]()
    var airportFull = [String]()
    var speech = ""
    var station = ""
    var weatherCoords = ""
    var weatherData: DarkSky?
    var metars: [Metar]?
    
    
    @IBAction func explainMoon(_ sender: Any) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let moonExplain = UIAlertController(title: "Moon Phases", message: "0% = New Moon \n0->50%: Waxing to Full Moon \n50% = Full Moon \n50->100%: Waning to New Moon", preferredStyle: .alert)
        moonExplain.addAction(okAction)
        
        present(moonExplain, animated: true, completion: nil)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.rowHeight = UITableViewAutomaticDimension
        
        locationSetup()
        pullDownRefresh()
        alignCompassArrow()
        pickerConfig()
        metarRequest()
        moonPhaseRequest()
        sunMoonRequest()
        getDarkSky()
    }

    func refreshWeatherMETAR() {
        self.compass.transform = CGAffineTransform.identity
        getDarkSky()
        moonPhaseRequest()
        sunMoonRequest()
        metarRequest()
        refreshControl?.endRefreshing()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //    send the metars history object to the moreMetar page

        if let destination = segue.destination as? MoreMetarTVC {
            destination.station = station
        }
//        send the weatherData object to the weather forecast page
        if let destination = segue.destination as? MoreWeatherTVC {
            destination.weatherData = weatherData
        }
    }
    
    func alignCompassArrow() {
        self.compass.layer.anchorPoint = CGPoint(x: 0.5, y: 2.4)
    }
    
    func pullDownRefresh() {
        pullRefresh.addTarget(self, action: #selector(WeatherTVC.refreshWeatherMETAR), for: UIControlEvents.valueChanged)
        tableView.refreshControl = pullRefresh
    }
    
    func rotateCompass(compassDirection: Float) {
        UIView.animate(withDuration: 2.0,
                       animations: ({
                        self.compass.transform = self.compass.transform.rotated(by: CGFloat((compassDirection) * 0.0175))
                       }))
    }
   
    func pickerConfig() {
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self as? UIPickerViewDataSource

        let config = AirportPickerConfig()  //Data from Model: Airport.swift
        let airports = config.airports
        let airportNames = config.airportNames
        
        for airport in airports {
            self.locations.append(airport)
        }
        for airportNames in airportNames {
            self.airportFull.append(airportNames)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        self.locationPicker.tag = 1
        switch pickerView.tag {
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.locationPicker.tag = 1
        switch pickerView.tag {
        case 1:
            return locations.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.locationPicker.tag = 1
        switch pickerView.tag {
        case 1:
            return airportFull[row]
        default:
            return "Error"
        }
    }

    
    
    func metarRequest() {
//        let checkwx = "https://api.checkwx.com/metar/"
        let header = ["X-API-Key": "2a62a2bda2157c2576aa87d7c1"] //for checkwx
        
        let checkwx = "http://avwx.rest/api/metar/"
        let options = "?options=info,speech,translate,summary"
        let airportValue = self.locationPicker.selectedRow(inComponent: 0)
        let airport = locations[airportValue]

        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        let coordinates = "\(lat!),\(long!)"
        var metarUrl = String()
        
        if airportValue >= 1 {
            metarUrl = "\(checkwx)\(airport)\(options)"
            self.station = airport
        } else {
            metarUrl = "\(checkwx)\(coordinates)\(options)"
        }
        getMetarDecode(metarUrl: metarUrl, header: header)
    }
    
    func moonPhaseRequest() {
        // Pulls dates & times of next 4 moon phases including today
        let phaseSite = "http://api.usno.navy.mil/moon/phase?date="
        let numPhases = "&nump=4"
        let now = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let today = dateFormatter.string(from: now as Date)
        var todayString = today.components(separatedBy: "/")
        let justMonth = todayString[0]
        let justDay = todayString[1]
        let justYear = todayString[2]
        let todayDate = "\(justMonth)/\(justDay)/20\(justYear)"
        let phaseUrl = "\(phaseSite)\(todayDate)\(numPhases)"
        var nextFullMoon = ""
        
        Alamofire.request(phaseUrl).responseJSON { response in
            switch response.result {
            case .success:
                if let phaseJson = response.result.value {
                    let phaseJsonObject = phaseJson as! [String: AnyObject]
                    let phaseData = phaseJsonObject["phasedata"] as! [Any]
                    for moonPhase in phaseData {
                        var phase1 = moonPhase as! [String: Any]
                        guard let anyPhase = phase1["phase"]  else {
                            return
                        }
                        let stringPhase = anyPhase as! String
                        if (stringPhase == "Full Moon") {
                            nextFullMoon = phase1["date"] as! String
                        }
                        
                        }
                    var nextFullMoonArray = nextFullMoon.components(separatedBy: " ")
                    //                        let nextFullYear = nextFullMoonArray[0]
                    let nextFullMonth = nextFullMoonArray[1]
                    let nextFullDay = nextFullMoonArray[2]
                    let nextFullMoonCorrected = "\(nextFullMonth) \(nextFullDay)"
                    
                    DispatchQueue.main.async {
                        self.nextFullMoonLabel.text = nextFullMoonCorrected
                    }
            }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sunMoonRequest() {
        // Pulls dates & times of next 4 moon phases including today
        let sunMoonSite = "http://api.usno.navy.mil/rstt/oneday?date="
        let loc = "&loc=Houston,TX"
        let now = NSDate()
        var moonRiseTime = ""
        var moonSetTime = ""
        var moonRiseSetTime = ""
        var correctedMoonRiseTime = ""
        var correctedMoonSetTime = ""
        var moonRiseTimeDate: Date = now as Date
        var moonSetTimeDate: Date = now as Date
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
        
        let today = dateFormatter.string(from: now as Date)
        var todayString = today.components(separatedBy: "/")
        let justMonth = todayString[0]
        let justDay = todayString[1]
        let justYear = todayString[2]
        let todayDate = "\(justMonth)/\(justDay)/20\(justYear)"
        let sunMoonUrl = "\(sunMoonSite)\(todayDate)\(loc)"
        
        Alamofire.request(sunMoonUrl).responseJSON { response in
            switch response.result {
            case .success:
                if let sunMoonJson = response.result.value {
                    let sunMoonJsonObject = sunMoonJson as! [String: AnyObject]
                    let moonData = sunMoonJsonObject["moondata"] as! [Any]
                    for moon1 in moonData {                         //looks for moon rise and set times
                        var moonRise = moon1 as! [String: Any]
                        guard let anyMoonRiseTime = moonRise["phen"]  else {
                            return
                        }
                        let stringMoonRiseTime = anyMoonRiseTime as! String
                        if (stringMoonRiseTime == "R") {
                            moonRiseTime = moonRise["time"] as! String
                        }
                        if (stringMoonRiseTime == "S") {
                            moonSetTime = moonRise["time"] as! String
                        }
                    }
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm a"
                    timeFormatter.locale = Locale(identifier: "en_US")
                    
                    if moonRiseTime != "" {
                        let moonRiseTimeArray = moonRiseTime.components(separatedBy: " ")
                        let moonRiseTimeOnly = moonRiseTimeArray[0]
                        let moonRiseAmPmOnly = moonRiseTimeArray[1]
                        let shortAmPm = moonRiseAmPmOnly.dropLast(3)
                        if (shortAmPm == "a") {
                            correctedMoonRiseTime = "\(moonRiseTimeOnly) AM"
                            moonRiseTimeDate = timeFormatter.date(from: correctedMoonRiseTime)!

                        } else {
                            correctedMoonRiseTime = "\(moonRiseTimeOnly) PM"
                            moonRiseTimeDate = timeFormatter.date(from: correctedMoonRiseTime)!

                        }
                    } else {
                        correctedMoonRiseTime = "--:--"
                    }
                   
                    if moonSetTime != "" {
                        let moonSetTimeArray = moonSetTime.components(separatedBy: " ")
                        let moonSetTimeOnly = moonSetTimeArray[0]
                        let moonSetAmPmOnly = moonSetTimeArray[1]
                        let shortSetAmPm = moonSetAmPmOnly.dropLast(3)
                        if (shortSetAmPm == "a") {
                            correctedMoonSetTime = "\(moonSetTimeOnly) AM"
                            moonSetTimeDate = timeFormatter.date(from: correctedMoonSetTime)!
                        } else {
                            correctedMoonSetTime = "\(moonSetTimeOnly) PM"
                            moonSetTimeDate = timeFormatter.date(from: correctedMoonSetTime)!
                        }
                    } else {
                        correctedMoonSetTime = "Moon Set After Midnight"
                    }
                   
                    if moonSetTime != "" {
                        if moonSetTimeDate < moonRiseTimeDate {
                            moonRiseSetTime = "\(correctedMoonSetTime) / \(correctedMoonRiseTime)"
                            self.moonRiseSetTitle.text = "Moon Set/Rise:"
                        } else {
                            moonRiseSetTime = "\(correctedMoonRiseTime) / \(correctedMoonSetTime)"
                        }
                    }
                     DispatchQueue.main.async {
                        self.moonRiseLabel.text = moonRiseSetTime
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMetarDecode(metarUrl: String, header: [String: String]) {
        let urlString = metarUrl
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
            let metarAir = try JSONDecoder().decode(AvMetar.self, from: data)

            let report = metarAir.RawReport
            self.speech = metarAir.Speech
            let name = metarAir.Info.Name
            let rules = metarAir.FlightRules
            let time = metarAir.Time
            let wind = metarAir.Translations.Wind
            let vis = metarAir.Translations.Visibility
            let other = metarAir.Translations.Other
            let clouds = metarAir.Translations.Clouds
            let temp = metarAir.Translations.Temperature
            let dewp = metarAir.Translations.Dewpoint
            let alt = metarAir.Translations.Altimeter
            self.station = metarAir.Info.ICAO
            
            let keys = [String](metarAir.Translations.Remarks.keys)
            let values = [String](metarAir.Translations.Remarks.values)
            var remarkString = ""
            if metarAir.Translations.Remarks.isEmpty {
                remarkString = "No Remarks"
            } else {                                    //convert remarks from dictionary to string
                let numRemarks = metarAir.Translations.Remarks.count - 1
                for remark in 0...numRemarks {
                    remarkString.append(keys[remark])
                    remarkString.append(": ")
                    remarkString.append(values[remark])
                    remarkString.append("\n")
                }
            }
            
            let zuluTimeStr = String(time.dropFirst(2))
            let zuluDateStr = "\(zuluTimeStr)"
            
            let formatter = DateFormatter()
                formatter.dateFormat = "HHmmZ"
                let zuluTime = formatter.date(from: zuluDateStr)
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                formatter.locale = Locale(identifier: "en_US")
            let localTime = formatter.string(from: zuluTime!)
                
            let decoded = ("\(time) = \(localTime)\nWind: \(wind)\nVisibility: \(vis)\nOther: \(other)\nClouds: \(clouds)\nTemp/Dewpoint: \(temp) / \(dewp)\nAltimeter: \(alt)")
            DispatchQueue.main.async {
                self.metarLabel.text = "\(report)"
//                self.metarLabel.layer.borderWidth = 1.0
//                self.metarLabel.layer.cornerRadius = 4
                let metarLabelHeight = self.metarLabel.optimalHeight  //function in WeatherModel
                self.metarLabel.frame = CGRect(x: self.metarLabel.frame.origin.x, y: self.metarLabel.frame.origin.y, width: self.metarLabel.frame.width, height: metarLabelHeight)
                
                self.metarDecodeLabel.text = "METAR DECODED:\n\(name), Rules: \(rules)\n\(decoded)\nRemarks:\n\(remarkString)"
                self.metarDecodeLabel.layer.borderWidth = 0.5
                self.metarDecodeLabel.layer.cornerRadius = 4
                let metarDecodeLabelHeight = self.metarDecodeLabel.optimalHeight  //function in WeatherModel
                self.metarDecodeLabel.frame = CGRect(x: self.metarDecodeLabel.frame.origin.x, y: self.metarDecodeLabel.frame.origin.y, width: self.metarDecodeLabel.frame.width, height: metarDecodeLabelHeight)
                
             }  // end of "do"
        } catch let jsonError {
            self.speech = "Unavailable"
            
            self.station = "KIAH"
            DispatchQueue.main.async {
                self.metarLabel.text = "METAR Not Available for This Airport"
                let metarLabelHeight = self.metarLabel.optimalHeight  //function in WeatherModel
                self.metarLabel.frame = CGRect(x: self.metarLabel.frame.origin.x, y: self.metarLabel.frame.origin.y, width: self.metarLabel.frame.width, height: metarLabelHeight)
                
                self.metarDecodeLabel.text = "METAR Decoding Not Available for This Airport"
                let metarDecodeLabelHeight = self.metarDecodeLabel.optimalHeight  //function in WeatherModel
                self.metarDecodeLabel.frame = CGRect(x: self.metarDecodeLabel.frame.origin.x, y: self.metarDecodeLabel.frame.origin.y, width: self.metarDecodeLabel.frame.width, height: metarDecodeLabelHeight)
                
            }
            print ("json error:",jsonError)
        }
        }.resume()
    }
    
    func locationSwitch() ->(Double, Double) {
        let airportValue = self.locationPicker.selectedRow(inComponent: 0)
        var lat = Double()
        var long = Double()
        
        switch airportValue {
        case 0:
            lat = (locationManager.location?.coordinate.latitude)!
            long = (locationManager.location?.coordinate.longitude)!
            self.metarTitle.text = "CLOSEST METAR:"
        case 1...9:
            if let path = Bundle.main.path(forResource: "Coordinates", ofType: "geojson") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    
                    do {
                        let airports = try JSONDecoder().decode([Airport].self, from: data)
                        
                        lat = airports[airportValue].lat
                        long = airports[airportValue].long
                        self.metarTitle.text = "METAR:"
                    } catch let jsonError {
                        print ("json error:",jsonError)
                    }
                } catch let error {
                    print(error)
                }
            } else {
                print("Didn't enter do")
            }
        default:
            lat = (locationManager.location?.coordinate.latitude)!
            long = (locationManager.location?.coordinate.longitude)!
            
        }
        if lat == 0 {
            lat = (locationManager.location?.coordinate.latitude)!
            long = (locationManager.location?.coordinate.longitude)!
        return (lat, long)
        }
        return (lat, long)
    }
    
    func getDarkSky() {
        let (lat, long) = locationSwitch()
        weatherCoords = "\(lat),\(long)"
        let darkSkyURL = "https://api.darksky.net/forecast/76078d986d8b6d9fbd123281b3d6ed80/"
        let options = "?exclude=hourly%2Cminutely"
        let fullURL = "\(darkSkyURL)\(lat),\(long)\(options)"
        let request = NSMutableURLRequest(url: NSURL(string: fullURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            guard let data = data else { return }
            do {
                
                let weather = try JSONDecoder().decode(DarkSky.self, from: data)
                
                self.weatherData = weather
                
                let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .short
                    dateFormatter.locale = Locale(identifier: "en_US")
                
                let timeFormatter = DateFormatter()
                    timeFormatter.dateStyle = .none
                    timeFormatter.timeStyle = .short
                    timeFormatter.locale = Locale(identifier: "en_US")
                
                let date = weather.currently.time
                    let unixDate = NSDate(timeIntervalSince1970: date)
                    let dateString = dateFormatter.string(from: unixDate as Date)
                let riseTime = weather.daily.data[0].sunriseTime!
                    let unixRiseTime = NSDate(timeIntervalSince1970: riseTime)
                    let riseTimeString = timeFormatter.string(from: unixRiseTime as Date)
                let setTime = weather.daily.data[0].sunsetTime!
                    let unixSetTime = NSDate(timeIntervalSince1970: setTime)
                    let setTimeString = timeFormatter.string(from: unixSetTime as Date)
                
                let icon = String(describing: weather.currently.icon!)
                let windGust = (String(round(weather.currently.windGust! * 10) / 10))
                let visibility = String(Int(weather.currently.visibility!))
                let compassDirection = weather.currently.windBearing!
                let humidity = String(Int(weather.currently.humidity! * 100))
                let temp = String(Int(weather.currently.temperature!))
                let apparentTemp = String(Int(weather.currently.apparentTemperature!))
                let windSpeed = (String(round(weather.currently.windSpeed! * 10) / 10))
                let dewPoint = String(Int(weather.currently.dewPoint!))
                let pressureInHg = String(round(weather.currently.pressure! * 0.02953 * 100) / 100)  // convert hPa to inHg
                let moonPhase = Int(weather.daily.data[0].moonPhase! * 100)

                DispatchQueue.main.async {
                    self.windGustLabel.text = windGust
                    self.summaryLabel.text = weather.currently.summary!
                    self.tempLabel.text = "\(temp)°"
                    self.appTempLabel.text = "\(apparentTemp)°"
                    self.windSpeedLabel.text = windSpeed
                    self.dewPointLabel.text = "\(dewPoint)°"
                    self.pressureLabel.text = "\(pressureInHg)"
                    self.humidityLabel.text = "\(humidity)%"
                    self.moonPhaseLabel.text = "\(moonPhase)%"
                    self.sunRiseLabel.text = "\(riseTimeString) / \(setTimeString)"
                    self.visibilityLabel.text = "\(visibility)"
                    self.timeLabel.text = "\(dateString)"
                    
                    self.iconImage.image = UIImage.init(named: icon)   //image name "icon" is same as icon name
                    self.rotateCompass(compassDirection: compassDirection)
                }
            } catch let jsonError {
                print ("DarkSky json error:",jsonError)
            }
        })
        dataTask.resume()
    }  // ends DarkSky()
    
}  // ends Class

extension WeatherTVC: CLLocationManagerDelegate {
    func locationSetup() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
}


//func weatherRequest() {
//    let client = DarkSkyClient(apiKey: "76078d986d8b6d9fbd123281b3d6ed80")
//    let (lat, long) = locationSwitch()
//
//    client.getForecast(latitude: lat, longitude: long) { result in
//        switch result {
//        case .success(let currentForecast, _):
//            guard let currently = currentForecast.currently else {
//                return
//            }
//
//            guard let daily = currentForecast.daily else {
//                return
//
//            }
//            let formatter = DateFormatter()
//            formatter.dateStyle = .none
//            formatter.timeStyle = .short
//            formatter.locale = Locale(identifier: "en_US")
//
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateStyle = .short
//            timeFormatter.timeStyle = .short
//            timeFormatter.locale = Locale(identifier: "en_US")
//
//            let visibility = String(Int(currently.visibility!))
//            let compassDirection = currentForecast.currently!.windBearing!
//            let humidity = String(Int(currentForecast.currently!.humidity! * 100))
//            let temp = String(Int(currentForecast.currently!.temperature!))
//            let apparentTemp = String(Int(currentForecast.currently!.apparentTemperature!))
//            let windSpeed = (String(round(currentForecast.currently!.windSpeed! * 10) / 10))
//            let dewPoint = String(Int(currentForecast.currently!.dewPoint!))
//            let pressureInHg = String(round(currentForecast.currently!.pressure! * 0.02953 * 100) / 100)  // convert hPa to inHg
//
//            let longIcon = String(describing: currently.icon)
//            let shortIcon = longIcon.dropFirst(25)
//            let icon = String(shortIcon.dropLast(1))
//
//            let dailyForecast = daily.data
//            let moonPhase = Int(dailyForecast[0].moonPhase! * 100)
//            let riseTime = formatter.string(from: dailyForecast[0].sunriseTime!)
//            let setTime = formatter.string(from: dailyForecast[0].sunsetTime!)
//
//            let time = timeFormatter.string(from: currently.time)
//
//            DispatchQueue.main.async {
//                self.summaryLabel.text = currentForecast.currently!.summary!
//                self.tempLabel.text = "\(temp)°"
//                self.appTempLabel.text = "\(apparentTemp)°"
//                self.windSpeedLabel.text = windSpeed
//                self.dewPointLabel.text = "\(dewPoint)°"
//                self.pressureLabel.text = "\(pressureInHg)"
//                self.humidityLabel.text = "\(humidity)%"
//                self.moonPhaseLabel.text = "\(moonPhase)%"
//                self.sunRiseLabel.text = "\(riseTime) / \(setTime)"
//                self.visibilityLabel.text = "\(visibility)"
//                self.timeLabel.text = "\(time)"
//
//                self.iconImage.image = UIImage.init(named: icon)   //image name "icon" is same as icon name
//                self.rotateCompass(compassDirection: compassDirection)
//            }
//        case .failure(let error):
//            print("The error is \(error)")
//        }
//    }
//}

