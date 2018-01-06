//
//  SpecialsPickSCVC.swift
//  Spotters
//
//  Created by Walter Edgar on 11/27/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import SafariServices

class HomeSetupSCVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {


    @IBOutlet weak var locationPicker: UIPickerView!
//    @IBOutlet weak var airportText: UITextField!
    @IBOutlet weak var defaultAirportLabel: UILabel!
//    @IBOutlet weak var searchIcao: UITextField!
    
    var locations = [String]()
    var airportFull = [String]()
    var airprortCode = ""
    var airportCity = ""
    var airportName = ""
    var airportSuccess = false
   
    var defaultAirport: String = "KIAH"
    let userKey = "userKey"

    override func viewDidLoad() {
        super.viewDidLoad()
//        defaultAirport = UserDefaults.standard.string(forKey: userKey)!
//        airportText.delegate = self
//        searchIcao.delegate = self
        locationConfig()
        
//        var userDefaultAirport = UserDefaults.standard.string(forKey: userKey)
//        if userDefaultAirport == "" {
//            userDefaultAirport = "KIAH"
//            defaultAirport = userDefaultAirport!
//            self.defaultAirportLabel.text = "Default Airport: \(userDefaultAirport!)"
//        } else {
//            defaultAirport = userDefaultAirport!
//            self.defaultAirportLabel.text = "Default Airport: \(userDefaultAirport!)"
//        }

        
//            let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 20.0)!, forKey: NSFontAttributeName as NSCopying)   //HelveticaNeue-Bold
//            ArrOrDepSC.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)

    }
    
    func locationConfig() {
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        let airports = ["KIAH", "KHOU", "KEFD", "KSGR", "KDWH", "KCXO", "KAXH", "KIWS", "KGLS", "KTME", "KEYQ", "KHPY", "T41"]
        
        let airportNames = [
            "IAH- George Bush Intercontinental",
            "HOU- William P Hobby",
            "EFD- Ellington Field",
            "SGR- Sugar Land Regional",
            "DWH- David W Hooks Memorial",
            "CXO- Lone Star Executive",
            "AXH- Houston-Southwest",
            "IWS- West Houston",
            "GLS- Galveston Scholes",
            "TME- Houston Executive",
            "EYQ- Weiser Air Park",
            "HPY- Baytown",
            "T41- La Porte Municipal"
        ]
        
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
    
    func setDefault(defAir: String, uKey: String) {
        let defAirport = UserDefaults.standard
        defAirport.setValue(defAir, forKey: uKey)
        
    }
   
    @IBAction func allSpecialsButtonPressed() {
        let specialsTrackerURL = "http://www.houstonspotters.net/dev/?allSpecials=true"
        if let url = URL(string: specialsTrackerURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func arrivalsButtonPressed() {
        let arrOrDepValue = "arrivals"
        let airportValue = self.locationPicker.selectedRow(inComponent: 0)
        let airport = locations[airportValue]
        let flightTrackerURL = "http://www.houstonspotters.net/dev/?ArrOrDep=\(arrOrDepValue)&airport=\(airport)"
        if let url = URL(string: flightTrackerURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func departuresButtonPressed() {
        let arrOrDepValue = "departures"
        let airportValue = self.locationPicker.selectedRow(inComponent: 0)
        let airport = locations[airportValue]
        let flightTrackerURL = "http://www.houstonspotters.net/dev/?ArrOrDep=\(arrOrDepValue)&airport=\(airport)"
        if let url = URL(string: flightTrackerURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }

//    @IBAction func searchIcaoButton(_ sender: Any) {
//        let enteredText = searchIcao.text
//        searchIcao.resignFirstResponder()
//        if (enteredText?.isEmpty)! {
//            let message = "Enter an airport or location"
//            self.noFlights(noMessage: message)
//        } else {
//            var aNameNoSpace = ""
//            aNameNoSpace = (enteredText!.replacingOccurrences(of: " ", with: "+"))
//            let flightAwareURL = "https://acukwik.com/Airports?search=\(aNameNoSpace)"
//            if let url = URL(string: flightAwareURL) {
//                let safariVC = SFSafariViewController(url: url)
//                present(safariVC, animated: true, completion: nil)
//            }
//        }
//    }
    
    @IBAction func airportInfoButton(_ sender: Any) {
        let airportValue = self.locationPicker.selectedRow(inComponent: 0)
        let airport = locations[airportValue]
        let flightAwareURL = "https://flightaware.com/live/airport/\(airport)"
        if let url = URL(string: flightAwareURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
//    @IBAction func setDefaultButton(_ sender: Any) {
//        self.airportText.resignFirstResponder()
//            let airportName = airportText.text
//            if (airportName?.isEmpty)! {
//                let message = "Enter an airport\n(IAH, KIAH)"
//                self.noFlights(noMessage: message)
//            } else {
//                checkAirport(airport: airportName!)
//                if self.airportSuccess {
//                    print("changed airport from button")
////                    defaultAirport = self.airprortCode
////                    changeDefaultLabel(code: defaultAirport)
////                    setDefault(defAir: defaultAirport, uKey: userKey)
////                    let message = self.airportConfirmed()
////                    self.confirmAirport(yesMessage: message)
//                    } //else {
////                    let message = "Airport not found"
//                //                    noFlights(noMessage: message) }
//            }
//        }

//    func textFieldDidEndEditing() {
//        self.searchIcao.resignFirstResponder()
//        self.airportText.resignFirstResponder()
////        let message = "Search field ended"
////        noFlights(noMessage: message)
//        return
//    }
//    
//    func textFieldShouldReturn(_ airportText: UITextField) -> Bool {
//        self.airportText.resignFirstResponder()
//        let enteredText = airportText.text
//        if (enteredText?.isEmpty)! {
//            let message = "Enter an airport"
//            self.noFlights(noMessage: message)
//        } else {
//            self.searchIcao.resignFirstResponder()
//            self.airportText.resignFirstResponder()
//        }
//        return true
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //    send the airport code to the airport view page
                if let destination = segue.destination as? AirportViewController {
//                    let airport = defaultAirport
                    let airportValue = self.locationPicker.selectedRow(inComponent: 0)
                    let airport = locations[airportValue]
                    destination.lastAirport = airport
        }
    }
    
    func checkAirport(airport: String)  {
        let urlFA = "https://wkejunk:508562eb1167f0e4319fec3c542a95288c542a57@flightxml.flightaware.com/json/FlightXML3/AirportInfo?airport_code=\(airport)"

        guard let url = URL(string: urlFA) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let airportInfo = try JSONDecoder().decode(AirportInfoFA.self, from: data)
                self.airportName = airportInfo.AirportInfoResult.name
                self.airprortCode = airportInfo.AirportInfoResult.airport_code
                self.airportCity = airportInfo.AirportInfoResult.city
                self.airportSuccess = true
                let message = self.airportConfirmed()
                self.confirmAirport(yesMessage: message)
                let code = self.airprortCode
                self.changeDefaultLabel(code: code)
                self.changeDefaultAirport(code: code)
                return
            } catch let jsonError {
                let message = "Unable to locate airport"
                print ("json2 error:",jsonError)
                self.noFlights(noMessage: message)
                return
            }
            }.resume()
//        let message = "Airport Confirmed"
//        self.confirmAirport(yesMessage: message)
        return
    }
    
    func airportConfirmed() -> String {
        let code = self.airprortCode
        let name = self.airportName
        let city = self.airportCity
        let confirmText = "Default Airport set to: \(code)\nCity: \(city)\nAirport Name: \(name)"
        return confirmText
    }
    
    func changeDefaultLabel(code: String) {
        DispatchQueue.main.async {
            let code = self.airprortCode
            self.defaultAirportLabel.text = "Default airport: \(code)"
        }
    }
    
    func changeDefaultAirport(code: String) {
        self.defaultAirport = code
        self.setDefault(defAir: code, uKey: self.userKey)
    }
    
    func noFlights(noMessage: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let noGate = UIAlertController(title: "!", message: noMessage, preferredStyle: .alert)
        noGate.addAction(okAction)
        present(noGate, animated: true, completion: nil)
    }
    
    func confirmAirport(yesMessage: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let noGate = UIAlertController(title: "Success!", message: yesMessage, preferredStyle: .alert)
        noGate.addAction(okAction)
        present(noGate, animated: true, completion: nil)
    }
}


