//
//  MoreWeatherTVC.swift
//  Spotters
//
//  Created by Walter Edgar on 12/27/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit

class MoreWeatherTVC: UITableViewController {

    @IBOutlet var myTableView: UITableView!
    var weatherData: DarkSky?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        myTableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "MoreWeatherTVCell",bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "customCell")
        
//        OperationQueue.main.addOperation {
//            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
//        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherData = weatherData else {
            return 3
        }
        return weatherData.daily.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MoreWeatherTVCell
        myCell.arrowImage.transform = CGAffineTransform.identity
        let weather = weatherData?.daily.data[indexPath.row]
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
        let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            dayFormatter.locale = Locale(identifier: "en_US")
        let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            timeFormatter.locale = Locale(identifier: "en_US")
        let date = weather?.time
            let unixDate = NSDate(timeIntervalSince1970: date!)
            let dateString = dateFormatter.string(from: unixDate as Date)
        let day = weather?.time
            let unixDay = NSDate(timeIntervalSince1970: day!)
            let dayString = dayFormatter.string(from: unixDay as Date)
        let riseTime = weather?.sunriseTime
            let unixRiseTime = NSDate(timeIntervalSince1970: riseTime!)
            let riseTimeString = timeFormatter.string(from: unixRiseTime as Date)
        let setTime = weather?.sunsetTime
            let unixSetTime = NSDate(timeIntervalSince1970: setTime!)
            let setTimeString = timeFormatter.string(from: unixSetTime as Date)
        
        let icon = weather?.icon!
        let windSpeed = String(round((weather?.windSpeed!)! * 10) / 10)
        let windGust = String(round((weather?.windGust!)! * 10) / 10)
//        let visibility = String(Int((weather?.visibility!)!))
        let compassDirection = weather?.windBearing!
//        let humidity = String(Int((weather?.humidity!)! * 100))
        let minTemp = String(Int((weather?.temperatureMin)!))
        let maxTemp = String(Int((weather?.temperatureMax)!))
        let moonPhase = Int((weather?.moonPhase!)! * 100)
        myCell.iconImage.image = UIImage(named: icon!)   //image name "icon" is same as icon name
        myCell.arrowImage.layer.anchorPoint = CGPoint(x: 0.5, y: 2.25)
        UIView.animate(withDuration: 2.0,
                       animations: ({
                        myCell.arrowImage.transform = myCell.arrowImage.transform.rotated(by: CGFloat((compassDirection)! * 0.0175))
                       }))
        myCell.dateLabel.text = dateString
        myCell.windLabel.text = windSpeed
        myCell.gustLabel.text = windGust
        myCell.minTempLabel.text = "Lo Temp: \(minTemp)°F"
        myCell.maxTempLabel.text = "Hi Temp: \(maxTemp)°F"
        myCell.moonPhaseLabel.text = "Moon Phase: \(moonPhase)%"
        myCell.summaryLabel.text = weather?.summary
        let summaryLabelHeight = myCell.summaryLabel.optimalHeight  //function in WeatherModel
        myCell.summaryLabel.frame = CGRect(x: myCell.summaryLabel.frame.origin.x, y: myCell.summaryLabel.frame.origin.y, width: myCell.summaryLabel.frame.width, height: summaryLabelHeight)
        
        myCell.sunLabel.text = "Sun rise/set: \(riseTimeString) / \(setTimeString)"
        myCell.dayLabel.text = dayString
        return myCell
    }
}
