//
//  HoustonSpottersHomeTVC.swift
//  Spotters
//
//  Created by Walter Edgar on 11/25/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import SwiftWebVC
import AVFoundation
import SafariServices


let urlIAH = "https://www.liveatc.net/search/?icao=iah"
let urlHOU = "https://www.liveatc.net/search/?icao=hou"

class HoustonSpottersHomeTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBOutlet weak var spottingGuides: UIButton!
    
    @IBAction func hAviationPhotoFbook(_ sender: Any) {
        let fbURL = URL(string: "https://www.facebook.com/groups/houstonaviation/")
        let fbURLID = URL(string: "fb://profile/439002759543246")
        if (UIApplication.shared.canOpenURL(fbURLID!)) {
            UIApplication.shared.open(fbURLID!, options: [:], completionHandler: nil)
        }
            else {
            UIApplication.shared.open(fbURL!, options: [:])
        }
    }
    
    @IBAction func hSpottersFbook(_ sender: Any) {
        let fbURL = URL(string: "https://www.facebook.com/HoustonSpotters/")
        let fbURLID = URL(string: "fb://profile/269689596272")
        if (UIApplication.shared.canOpenURL(fbURLID!)) {
            UIApplication.shared.open(fbURLID!, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open(fbURL!, options: [:])
        }
    }
   
    @IBAction func sunCalcButtonPressed() {
        if let url = URL(string: "http://www.suncalc.org") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func moonCalcButtonPressed() {
        if let url = URL(string: "https://mooncalc.org/#/29.96326,-95.35034,14") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func houstonSpottersButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func spottingGuideButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/resources/airports") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func donateButtonPressed() {
        if let url = URL(string: "http://www.houstonspotters.net/donate") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func fly2HoustonPressed() {
        if let url = URL(string: "http://www.fly2houston.com") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
        @IBAction func allSpecialsPressed() {
            if let url = URL(string: "http://airportwebcams.net/special-liveries/") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    //    @IBAction func iahButtonPressed() {
    //        if let url = URL(string: "https://www.liveatc.net/search/?icao=iah") {
    //            UIApplication.shared.open(url, options: [:])
    //        }
    //    }
 
}
