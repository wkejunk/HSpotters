//
//  ViewController.swift
//  Airport
//
//  Created by Walter Edgar on 12/24/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import os.log
import SafariServices
import Foundation

class AirportViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var myTableView: UITableView!
    var airData: [FlightInfo] = []
    var flaggedAirData: [FlightInfo] = []
    var arrivingFlights: [FlightInfo] = []
    var departingFlights: [FlightInfo] = []
    var objectsArray: [Objects] = []
    var arrivingObjects: [Objects] = []
    var departingObjects: [Objects] = []
    var tempObjects: [Objects] = []
    var specials: [specialsArray] = []
    var specialsAwc: [specialsArrayAwc] = []
    var blairIdent: [String] = []
    var awcIdent: [String] = []
    var lastAirport: String = "KIAH"
    var pullRefresh: UIRefreshControl = UIRefreshControl()
    var specialsCount = 0
    var specialsAwcCount = 0
//    var activitiyIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//    @IBOutlet weak var activitiyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterSC: UISegmentedControl!
    
    @IBAction func segmentedChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
//    func filterArrivals(bigObject: Objects) -> Objects {
//        var arrivalsObject: Objects = []
//        let h =
//
//        return arrivalsObject
//    }
    
    @IBOutlet weak var enterAirport: UITextField!
    
    @IBAction func newAirportData(_ sender: Any) {
        var airportName = enterAirport.text
         airData = []
        arrivingFlights = []
        departingFlights = []
        if (airportName?.isEmpty)! {
            airportName = lastAirport
            getAirportDataFA(airport: airportName!)
            lastAirport = airportName!
        } else {
            getAirportDataFA(airport: airportName!)
            lastAirport = airportName!
        }
        myTableView.setContentOffset(CGPoint.zero, animated: true)
         enterAirport.resignFirstResponder()
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        myTableView.estimatedRowHeight = 110
//        myTableView.rowHeight = UITableViewAutomaticDimension
        
        enterAirport.delegate = self
        myTableView.delegate = self
        myTableView.dataSource = self
        let nib = UINib(nibName: "TableViewCell",bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "customCell")
//        getAirportDataFile()  // used for testing
        getAirportDataFA(airport: lastAirport)
        pullDownRefresh()
        tableView.reloadData()
    }
    
    private func textFieldDidEndEditing(_ enterAirport: UITextView) {
        self.enterAirport.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.enterAirport.resignFirstResponder()
        let airportName = enterAirport.text
        airData = []
        arrivingFlights = []
        departingFlights = []
        getAirportDataFA(airport: airportName!)
        lastAirport = airportName!
        myTableView.setContentOffset(CGPoint.init(x: 0, y: 10), animated: true)
        return true
    }
    
    
    
//    func startLoadingAnimation() {
//        activitiyIndicator.center = self.view.center
//        activitiyIndicator.hidesWhenStopped = true
//        activitiyIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        activitiyIndicator.startAnimating()
//    }
//
//    func stopLoadingAnimation() {
//        self.activitiyIndicator.stopAnimating()
//    }
    
    func pullDownRefresh() {
        pullRefresh.addTarget(self, action: #selector(refreshAirport), for: UIControlEvents.valueChanged)
        tableView.refreshControl = pullRefresh
        refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl?.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
    }
    
    @objc func refreshAirport() {
        airData = []
        arrivingFlights = []
        departingFlights = []
        if (self.enterAirport.text?.isEmpty)! {
            getAirportDataFA(airport: lastAirport)
            refreshControl?.endRefreshing()
        } else {
            let airport = self.enterAirport.text
            getAirportDataFA(airport: airport!)
            refreshControl?.endRefreshing()
//            activityIndicatorView.stopAnimating()
        }
     }

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch filterSC.selectedSegmentIndex {
        case 0:
           return objectsArray.count
        case 1:
            return arrivingObjects.count
        case 2:
            return departingObjects.count
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch filterSC.selectedSegmentIndex {
        case 0:
            return objectsArray[section].sectionName
        case 1:
            return arrivingObjects[section].sectionName
        case 2:
            return departingObjects[section].sectionName
        default:
            break
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.blue
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterSC.selectedSegmentIndex {
        case 0:
            return objectsArray[section].flights.count
        case 1:
            return arrivingObjects[section].flights.count
        case 2:
            return departingObjects[section].flights.count
        default:
            break
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let myCell: AirportTableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: "customCell") as? AirportTableViewCell else
        {
            os_log("didn't work", log: .default, type: .debug)
            fatalError()
        }
        
        myCell.cellView.layer.cornerRadius = myCell.cellView.frame.height / 5
        myCell.airlineImage.layer.masksToBounds = true
        myCell.airlineImage.layer.cornerRadius = myCell.airlineImage.layer.frame.height / 20
        myCell.backgroundColor = UIColor.clear
        
        
        switch filterSC.selectedSegmentIndex {
        case 0:
            tempObjects = objectsArray
        case 1:
            tempObjects = arrivingObjects
        case 2:
            tempObjects = departingObjects
        default:
            break
        }
        
        let data = tempObjects[indexPath.section].flights[indexPath.row]
        
        let airplaneIcon = data.icon!
        myCell.airplaneImage.image = UIImage(named: airplaneIcon)
        if airplaneIcon == "arriving" {
            myCell.fromToLabel.text = "FROM:"
            myCell.estTimeLabel.text = data.estimated_arrival_time.time
//            myCell.actTimeLabel.text = data.actual_arrival_time.time
        } else {
            myCell.fromToLabel.text = "TO:"
            myCell.estTimeLabel.text = data.estimated_departure_time.time
//            myCell.actTimeLabel.text = data.actual_departure_time.time
        }

        myCell.flightLabel.text = data.ident
        myCell.codeShareLabel.text = data.codeshares
        myCell.tailLabel.text = data.tailnumber
        myCell.typeLabel.text = data.aircrafttype
        myCell.airportCodeLabel.text = data.originOrDestCode
        myCell.airportNameLabel.text = data.originOrDestAirport
        
        myCell.statusLabel.text = data.status
        myCell.gateLabel.text = data.originOrDestGate
        
        if data.specialsFlag! {
            myCell.specialLabel.text = data.specialsDescription
            if indexPath.section != 1   {
                myCell.backgroundColor = UIColor.yellow
                }
            } else {
            myCell.specialLabel.text = ""
            }
        let iconName = data.airline
        myCell.airlineImage.image = UIImage(named: iconName)
        myCell.airlineImage.layer.cornerRadius = myCell.airlineImage.layer.frame.height / 10
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        let flightNum = tempObjects[indexPath.section].flights[indexPath.row].ident
        let flightAwareURL = "https://flightaware.com/live/flight/\(flightNum)"
        if let url = URL(string: flightAwareURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    //Gets flights from FLightAware
    func getAirportDataFA(airport: String) {

        let urlFA = "https://wkejunk:508562eb1167f0e4319fec3c542a95288c542a57@flightxml.flightaware.com/json/FlightXML3/AirportBoards?airport_code=\(airport)&filter=airline&howMany=250&offset=0&include_ex_data=true"
        //        let options = "&filter=airline&howMany=\(numberOfFlights)&offset=0"
        //        let urlString = "\(urlFA)\(airport)\(options)"
        //let urlString = "https://wkejunk:508562eb1167f0e4319fec3c542a95288c542a57@flightxml.flightaware.com/json/FlightXML3/AirportBoards?airport_code=Klax&filter=airline&howMany=15&offset=0"
                guard let url = URL(string: urlFA) else { return }
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else { return }
                    do {
                        let airports = try JSONDecoder().decode(Flights.self, from: data)
                        
                        self.getAllSpecials()
                        self.airDataFill(airports: airports)
                        if self.airData.isEmpty {
                            self.noFlights()
                        } else {
                            let (specialAirData, flaggedAirData) = self.getSpecials(flights: self.airData)
                            let (aSpecials, aflagged) = self.getSpecials(flights: self.arrivingFlights)
                            let (dSpecials, dflagged) = self.getSpecials(flights: self.departingFlights)
                            let heavyAirData = self.getHeavies(flights: flaggedAirData)
                            let aHeavies = self.getHeavies(flights: aflagged)
                            let dHeavies = self.getHeavies(flights: dflagged)
                            let nonHeavyInterestingAirData = self.getInterestingNonHeavy(flights: flaggedAirData, airp: airport)
                            let aInteresting = self.getInterestingNonHeavy(flights: aflagged, airp: airport)
                            let dInteresting = self.getInterestingNonHeavy(flights: dflagged, airp: airport)
                            
                            self.objectsArray = [Objects(sectionName: "Heavies", flights: heavyAirData),
                                                 Objects(sectionName: "All Specials", flights: specialAirData),
                                                 Objects(sectionName: "Others", flights: nonHeavyInterestingAirData)]
                            self.arrivingObjects = [Objects(sectionName: "Heavies", flights: aHeavies),
                                               Objects(sectionName: "All Specials", flights: aSpecials),
                                               Objects(sectionName: "Others", flights: aInteresting)]
                            self.departingObjects = [Objects(sectionName: "Heavies", flights: dHeavies),
                                                Objects(sectionName: "All Specials", flights: dSpecials),
                                                Objects(sectionName: "Others", flights: dInteresting)]
//                                                    OperationQueue.main.addOperation {
//                                                        self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
//                                                    }
//
//                            for o in self.objectsArray {
//                                let oCount = o.flights.count - 1
//                                for f in 0...oCount {
//                                    if o.flights[f].icon == "arriving" {
//                                        self.arrivingObjects.append(o)
//                                    } else {
//                                        self.departingObjects.append(o)
//                                    }
//                                }
//                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                            print("Success")
                        }
                        
                    } catch let jsonError {
                        self.noFlights()
                        print ("json2 error:",jsonError)
                    }

            }.resume()
    }
    
//    // gets flights, builds 1 object for TableView DataSource
//    func getAirportDataFile() {
//
//        let airport = "KIAH"
////        self.startLoadingAnimation()
//        if let path = Bundle.main.path(forResource: "TestFAJson", ofType: "geojson") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                do {
//                    let airports = try JSONDecoder().decode(Flights.self, from: data)
//
//                    airDataFill(airports: airports)     //fills the airData Object
//                    //send the airData Object and reutrn a specials Object and full list flagged with specials
//                    let (specialAirData, flaggedAirData) = getSpecials(flights: airData)
//                    let (aSpecials, aflagged) = getSpecials(flights: arrivingFlights)
//                    let (dSpecials, dflagged) = getSpecials(flights: departingFlights)
//                    let heavyAirData = getHeavies(flights: flaggedAirData)
//                    let aHeavies = getHeavies(flights: aflagged)
//                    let dHeavies = getHeavies(flights: dflagged)
//                    let nonHeavyInterestingAirData = getInterestingNonHeavy(flights: flaggedAirData, airp: airport)
//                    let aInteresting = getInterestingNonHeavy(flights: aflagged, airp: airport)
//                    let dInteresting = getInterestingNonHeavy(flights: dflagged, airp: airport)
//
//
//                    objectsArray = [Objects(sectionName: "Heavies", flights: heavyAirData),
//                        Objects(sectionName: "All Specials", flights: specialAirData),
//                        Objects(sectionName: "Others", flights: nonHeavyInterestingAirData)]
//                    arrivingObjects = [Objects(sectionName: "Heavies", flights: aHeavies),
//                                Objects(sectionName: "All Specials", flights: aSpecials),
//                                Objects(sectionName: "Others", flights: aInteresting)]
//                    departingObjects = [Objects(sectionName: "Heavies", flights: dHeavies),
//                                        Objects(sectionName: "All Specials", flights: dSpecials),
//                                        Objects(sectionName: "Others", flights: dInteresting)]
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//
//                } catch let jsonError {
//                    print ("json2 error:",jsonError)
//                }
//            } catch let error {
//                print(error)
//            }
//        } else {
//            print("Didn't enter do")
//        }
//    }
//
    //Receives Flight Info Object and returns an object of only specials (in order of time), flagged and labeled; and returns the complete Flight object also with specials flagged and labeled
    
    func getSpecials(flights: [FlightInfo]) -> ([FlightInfo],[FlightInfo]) {
        var flights = flights
        var specialFlights: [FlightInfo] = []
        let noDashSpecialTails = blairIdent
        var specialTailNumArray: [String] = []
        var specialTailNumArrayAwc: [String] = []

        
        // Compare tail number to identifier in specials.  Removes "-" from both before doing comparison.
        
        let flightCount = flights.count - 1
        for flight in 0...flightCount {         // replace tail numbers with dashes with tail number with no dashes
            flights[flight].tailnumberNoDash = flights[flight].tailnumber?.replacingOccurrences(of: "-", with: "")
            flights[flight].codeshares = flights[flight].codeshares?.replacingOccurrences(of: ",", with: " • ")
        }
        
        if specials.isEmpty {
            print("List of Specials didn't Load from database")
            return (specialFlights,flights)
        } else {
            
                //make a set of flight tail numbers
                let tailNumArray = flights.flatMap {$0.tailnumberNoDash}
                let tailNumSet = Set(tailNumArray)
                
                //convert list of nodash special numbers to a set
                let idenitfierSet = Set(noDashSpecialTails)
                let idenitfierSetAwc = Set(awcIdent)

                
                //use set function "intersection" to determine wich special tail numbers match tail numbers in flight
                let specialTailNumbers = tailNumSet.intersection(idenitfierSet)
                let specialTailNumbersAwc = tailNumSet.intersection(idenitfierSetAwc)
                let specialTailNumbersAwcCut = specialTailNumbersAwc.subtracting(specialTailNumbers)

                if specialTailNumbers.isEmpty {     //check to see if any flights are specials
                    print("No Special Flights from Blair's List")
                } else {
                    for item in specialTailNumbers {
                        specialTailNumArray.append(item)      //convert Set of special tailNums to an array
                    }
                    for f in 0...flightCount {          //checks for match with sepcials and adds flags and descriptions
                        for s in 0...specialsCount {
                            if flights[f].tailnumberNoDash == specials[s].identNoDash {
                                flights[f].specialsFlag = true
                                flights[f].specialsDescription = specials[s].description
                            }
                        }
                    }

                }
            if specialTailNumbersAwcCut.isEmpty {            //repeat the same process for teh AWC Database
                print("No specials unique to AWC Database")
                
            } else {
                for item in specialTailNumbersAwcCut {
                    specialTailNumArrayAwc.append(item)      //convert Set of special tailNums to an array
                }
                for f in 0...flightCount {          //checks for match with sepcials and adds flags and descriptions
                    for s in 0...specialsAwcCount {
                        if flights[f].tailnumberNoDash == specialsAwc[s].identNoDash {
                            flights[f].specialsFlag = true
                            flights[f].specialsDescription = specialsAwc[s].description
                        }
                    }
                }
            }
        }
        
        for n in 0...flightCount {
            if flights[n].specialsFlag! {       // look for specials using the flag
                specialFlights.append(flights[n])       //build the specialflights object
            }
        }
        specialFlights = specialFlights.sorted {$0.estArrDepTime! < $1.estArrDepTime!}
        print("All Specials:")
        for item in specialFlights {
            print(item.ident, item.flightnumber,item.specialsDescription!)
        }
        return (specialFlights,flights)
    }
    
    func getHeavies(flights: [FlightInfo]) -> [FlightInfo] {
        let heavyFilter = Set(FilterLists().heavyType)
        var fHeavyAirData: [FlightInfo] = []
        for list in heavyFilter {
            let filterList = flights.filter({$0.aircrafttype == list})
            for item in filterList {
                fHeavyAirData.append(item)
            }
        }
        if fHeavyAirData.isEmpty {
            print("No Heavies")
        } else {
            print("All Heavies Flight Numbers:")
            fHeavyAirData = fHeavyAirData.sorted {$0.estArrDepTime! < $1.estArrDepTime!}
            for item in fHeavyAirData {
                print(item.ident)
            }
        }
        return fHeavyAirData
    }
    
    func getInterestingNonHeavy(flights: [FlightInfo], airp: String) -> [FlightInfo] {
        //create a set of interesting airlines based on the airport selection
        var jabSet = Set<String>()
        let airlineArray = flights.map {$0.airline}
        let airlineSet = Set(airlineArray)
        if airp == "KIAH" {
            jabSet = Set(FilterLists().excludeIAH)
        } else if airp == "KHOU" {
            jabSet = Set(FilterLists().excludeHOU)
        } else { jabSet = Set(FilterLists().excludeAirport) }
        let interestingAirlines = airlineSet.subtracting(jabSet)

        //  filter list for interesting types (not united, etc..., and remove heavies from that list)
        var fInterestingAirData: [FlightInfo] = []
        var fNonHeavyInterestingAirData: [FlightInfo] = []
        for list in interestingAirlines {
            let filterList = flights.filter({$0.airline == list})
            for item in filterList {
                fInterestingAirData.append(item)
            }
        }
        if fInterestingAirData.isEmpty {
            print("No interesting")
            
        } else {
            //                        remove heavies from the interesting list
            let interestingType = fInterestingAirData.flatMap {$0.aircrafttype}
            let interestingTypeSet = Set(interestingType)
            let nonHeavyInterestingType = interestingTypeSet.subtracting(FilterLists().heavyType)
            for list in nonHeavyInterestingType {
                let filterList = fInterestingAirData.filter({$0.aircrafttype == list})
                for item in filterList {
                    fNonHeavyInterestingAirData.append(item)
                }
            }
            print("All Interesting Flight Numbers (non-Heavy):")
            fNonHeavyInterestingAirData = fNonHeavyInterestingAirData.sorted {$0.estArrDepTime! < $1.estArrDepTime!}
            for item in fNonHeavyInterestingAirData {
                print(item.ident)
            }
        }
        return fNonHeavyInterestingAirData
    }
    
    func airDataFill(airports: Flights) {
        var flights: [FlightInfo] = []
        
//        Fill the object with "arriving" flights, set my variables
//        flights = airports.AirportBoardsResult.arrivals.flights!
//        if flights.isEmpty {
//            print("No arrivals")
//        } else {
//            flights = fillArrivingFlightObjects(flights: flights, arrOrDep: "arriving")
//            for flight in flights {
//                self.airData.append(flight)
//                self.arrivingFlights.append(flight)
//            }
//        }
        
        //Fill the object with "enroute" flights, set my variables
        flights = airports.AirportBoardsResult.enroute.flights!
        if flights.isEmpty {
            print("No enroute")
        } else {
            flights = fillArrivingFlightObjects(flights: flights, arrOrDep: "arriving")
            for flight in flights {
                self.airData.append(flight)
                self.arrivingFlights.append(flight)
            }
        }
        
        //Fill the object with "departures" flights, set my variables
//        flights = airports.AirportBoardsResult.departures.flights!
//        if flights.isEmpty {
//            print("No departures")
//        } else {
//            flights = fillDepartingFlightObjects(flights: flights, arrOrDep: "departing")
//            for flight in flights {
//                self.airData.append(flight)
//                self.departingFlights.append(flight)
        
//            }
//        }
        
        //Fill the object with "scheduled" flights, set my variables
        flights = airports.AirportBoardsResult.scheduled.flights!
        if flights.isEmpty {
            print("No departures")
        } else {
            flights = fillDepartingFlightObjects(flights: flights, arrOrDep: "departing")
            for flight in flights {
                self.airData.append(flight)
                self.departingFlights.append(flight)
            }
        }
    }
    
    func fillArrivingFlightObjects(flights: [FlightInfo], arrOrDep: String) -> [FlightInfo] {
        //Fill the object with "arriving" flights, set my variables
        var flightObject: [FlightInfo] = []
        for flight in flights {
            flightObject.append(flight)
        }
        let counter = flights.count - 1
        //Assign arriving/departing icon, time (to sort by), Airport Code and Name
        for c in 0...counter {
            flightObject[c].icon = arrOrDep
            flightObject[c].estArrDepTime = flightObject[c].estimated_arrival_time.localtime
            flightObject[c].actArrDepTime = flightObject[c].actual_arrival_time.localtime
            flightObject[c].originOrDestCode = flightObject[c].origin.code
            flightObject[c].originOrDestAirport = flightObject[c].origin.airport_name
            flightObject[c].originOrDestCity = flightObject[c].origin.city
            flightObject[c].originOrDestGate = flightObject[c].gate_dest
            flightObject[c].specialsFlag = false
            flightObject[c].specialsDescription = ""
        }
        return flightObject
    }
    
    func fillDepartingFlightObjects(flights: [FlightInfo], arrOrDep: String) -> [FlightInfo] {
        //Fill the object with "arriving" flights, set my variables
        var flightObject: [FlightInfo] = []
        for flight in flights {
            flightObject.append(flight)
        }
        let counter = flights.count - 1
        //Assign arriving/departing icon, time (to sort by), Airport Code and Name
        for c in 0...counter {
            flightObject[c].icon = arrOrDep
            flightObject[c].estArrDepTime = flightObject[c].estimated_departure_time.localtime
            flightObject[c].actArrDepTime = flightObject[c].actual_departure_time.localtime
            flightObject[c].originOrDestCode = flightObject[c].destination.code
            flightObject[c].originOrDestAirport = flightObject[c].destination.airport_name
            flightObject[c].originOrDestCity = flightObject[c].destination.city
            flightObject[c].originOrDestGate = flightObject[c].gate_orig
            flightObject[c].specialsFlag = false
            flightObject[c].specialsDescription = ""
        }
        return flightObject
    }
    
    func noFlights() {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let noGate = UIAlertController(title: "No Data", message: "Airport Not Found or No Flights Returned", preferredStyle: .alert)
        noGate.addAction(okAction)
        present(noGate, animated: true, completion: nil)
    }
   
    func getAllSpecials() {     //this function goes and gets the list of specials, either from Blair's DB or from the TestSpecials file in the Models
//        let urlString = "http://www.houstonspotters.net/resources/FlightTracker/getDataDB.php"
//        guard let url = URL(string: urlString) else { return }
//        let request = NSMutableURLRequest(url: NSURL(string: "http://www.houstonspotters.net/resources/FlightTracker/getDataDB.php")! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//        request.httpMethod = "GET"
////        request.allHTTPHeaderFields = headers
//        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//
//            if (error != nil) {
//                print(error!)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
////                print(httpResponse!)
//            }
//        })
//        dataTask.resume()
        
        if let path = Bundle.main.path(forResource: "TestSpecials", ofType: "geojson") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    specials = try JSONDecoder().decode([specialsArray].self, from: data)
                    specials = specials.sorted {$0.airline < $1.airline}
                } catch let jsonError {
                    print ("specials json error:",jsonError)
                }
            } catch let error {
                print(error)
            }
        } else {
        print("Didn't enter do")
        }
        
        if let path = Bundle.main.path(forResource: "SpecialsAWC", ofType: "geojson") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    specialsAwc = try JSONDecoder().decode([specialsArrayAwc].self, from: data)
                    specialsAwc = specialsAwc.sorted {$0.airline < $1.airline}
                } catch let jsonError {
                    print ("Error Decoding specials from AWC List:",jsonError)
                }
            } catch let error {
                print(error)
            }
        } else {
            print("Didn't enter do")
        }
        specialsCount = specials.count - 1
        for special in 0...specialsCount {
            let identifiers = specials[special].ident      //remove dashes from all special tail numbers (idents)
            specials[special].identNoDash = identifiers.replacingOccurrences(of: "-", with: "")
            blairIdent.append(specials[special].identNoDash!)
        }
        let blairIdentSet = Set(blairIdent)
        
        specialsAwcCount = specialsAwc.count - 1
        for special in 0...specialsAwcCount {
            let idents = specialsAwc[special].ident      //remove dashes from all special tail numbers (idents)
            specialsAwc[special].identNoDash = idents.replacingOccurrences(of: "-", with: "")
            awcIdent.append(specialsAwc[special].identNoDash!)
        }
        let awcIdentSet = Set(awcIdent)
        let blairUniqueSet = blairIdentSet.subtracting(awcIdentSet)
        let awcUniqueSet = awcIdentSet.subtracting(blairUniqueSet)
        
        var blairUniqueArray: [specialsArray] = []
        for list in blairUniqueSet {
            let filterList = specials.filter({$0.identNoDash == list})
            for item in filterList {
                blairUniqueArray.append(item)
            }
        }
        var awcUniqueArray: [specialsArrayAwc] = []
        for list in awcUniqueSet {
            let filterList = specialsAwc.filter({$0.identNoDash == list})
            for item in filterList {
                awcUniqueArray.append(item)
            }
        }
        
        
//        let bUACount = blairUniqueArray.count - 1
//        for n in 0...bUACount {
////            print(blairUniqueArray[n].ident,blairUniqueArray[n].airline, blairUniqueArray[n].description)
//        }
//        print("Above are the /(bUACount) items unique to Blair's database")
        
//        use this for querrying the database directly
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
////            print(error!)
//            guard let data = data else { return }
//            do {
//                self.specials = try JSONDecoder().decode([specialsArray].self, from: data)
//                print(self.specials[0].ident,self.specials[0].description)
        
//                self.specialsCount = self.specials.count - 1
        
//        } catch let jsonError {
//            print ("json1 error:",jsonError)
//        }
//
//    }.resume()
    }
    
}

