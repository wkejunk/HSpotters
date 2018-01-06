//
//  SpotterGuideTVC.swift
//  Spotters
//
//  Created by Walter Edgar on 11/27/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import SafariServices

class SpotterGuideTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class TableRow: UITableViewCell {
    }

    
    @IBAction func launchIAHGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports/airport.asp?AirportID=KIAH") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func launchDWHGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports/airport.asp?AirportID=KDWH") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func launchHOUGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports/airport.asp?AirportID=KHOU") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func launchEFDGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports/airport.asp?AirportID=KEFD") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func launchIWSGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports/airport.asp?AirportID=KIWS") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func launchGLSGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports/airport.asp?AirportID=KGLS") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }

}
