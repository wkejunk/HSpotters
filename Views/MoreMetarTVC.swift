//
//  MoreMetarTVC.swift
//  Spotters
//
//  Created by Walter Edgar on 12/17/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit

class MoreMetarTVC: UITableViewController 
{
    var metars: [Metar]?
    var station = ""   //this variable passed from the WeatherTVC
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        myTableView.rowHeight = UITableViewAutomaticDimension
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        fetchData()
 
    }

    private func fetchData() {
        let feedParser = FeedParser()

        let avUrl = "https://www.aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&stationString="
        let hours = "&hoursBeforeNow=12"
        let stationID = station
        let options = "&fields=station_id,observation_time,raw_text"
        let metarURL = "\(avUrl)\(stationID)\(hours)\(options)"
        feedParser.parseFeed(url: metarURL) { (metars) in
            self.metars = metars
            // Reload the page with animation after the parser completes
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let metars = metars else {
            return 0
        }
        return metars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "metarCell", for: indexPath) as! CustomTableViewCell
        let parseMetar = self.metars![indexPath.row]
        let obsTime = parseMetar.observation_time.components(separatedBy: "T")
            let zuluDate = obsTime[0]
            let longZuluTime = obsTime[1]
        let zuluTimeStr = String(longZuluTime.dropLast(4))
        let zuluDateStr = "\(zuluDate) \(zuluTimeStr)Z"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mmZ"
        let zuluTime = formatter.date(from: zuluDateStr)
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        let correctTime = formatter.string(from: zuluTime!)
        
        myCell.metarLabel.text = parseMetar.raw_text
        myCell.timeLabel.text = correctTime
        
        return myCell
    }
    
    
    
}
