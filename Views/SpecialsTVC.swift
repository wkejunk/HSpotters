//
//  SpecialsTVC.swift
//  Spotters
//
//  Created by Walter Edgar on 12/30/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import SafariServices

enum selectedScope:Int {
    case airline = 0
    case tail = 1
    case description = 2
}

class SpecialsTVC: UITableViewController, UISearchBarDelegate {
    @IBOutlet var myTableView: UITableView!
    
    var specials: [specialsArray] = []
    var tempSpecials: [specialsArray] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        myTableView.rowHeight = UITableViewAutomaticDimension
        self.searchBarSetup()
        myTableView.delegate = self
        myTableView.dataSource = self
        
//        fetchData()=
        fetchDataLive()
        tempSpecials = specials
    }
    
    func searchBarSetup() {
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 60))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 40))

//        searchBar.sizeToFit()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Airline","Tail","Special"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
//        navigationItem.titleView = searchBar
    }
    
    func alterLayout() {
        myTableView.tableHeaderView = UIView()
        myTableView.estimatedSectionHeaderHeight = 50
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tempSpecials = specials
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tempSpecials = specials
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tempSpecials = specials
            self.tableView.reloadData()

        } else {
            let char = searchText.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("backspace")
                tempSpecials = specials
                filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
                self.tableView.reloadData()

            }
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(ind:Int, text: String) {
        switch ind {
        case selectedScope.airline.rawValue:
            tempSpecials = specials.filter({(mod) -> Bool in
                return mod.airline.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope.tail.rawValue:
            tempSpecials = specials.filter({(mod) -> Bool in
                return mod.ident.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope.description.rawValue:
            tempSpecials = specials.filter({(mod) -> Bool in
                return mod.description.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        default:
            print("default")
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tempSpecials.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        let tailNum = tempSpecials[indexPath.row].ident
        let flightAwareURL = "https://flightaware.com/live/flight/\(tailNum)"
        if let url = URL(string: flightAwareURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! SpecialsTableViewCell
        
        let airline = tempSpecials[indexPath.row].airline
        let tail = tempSpecials[indexPath.row].ident
        let code = tempSpecials[indexPath.row].airlineCode
//        let airlineTail = "\(code) • \(airline) • \(tail)"
        let airlineTail = "\(airline) • \(tail)"

        myCell.airlineTailLabel.text = airlineTail
        myCell.descriptionLabel.text = tempSpecials[indexPath.row].description
        myCell.iconImage.layer.masksToBounds = true
        myCell.iconImage.layer.cornerRadius = myCell.iconImage.layer.frame.height / 8
        
        if code == "" {
            myCell.iconImage.image = UIImage(named: tail)
        } else {
            myCell.iconImage.image = UIImage(named: code)
        }
        
//        let iconName = specials[indexPath.row].airlineCode
//        myCell.iconImage.image = UIImage(named: iconName)
//
        return myCell
    }

    func fetchData() {   //Blair's Database static
        if let path = Bundle.main.path(forResource: "TestSpecials", ofType: "geojson") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    specials = try JSONDecoder().decode([specialsArray].self, from: data)
                    specials = specials.sorted {$0.airline.localizedCaseInsensitiveCompare($1.airline) == .orderedAscending}
                    tempSpecials = specials
//                    print(specials)
                } catch let jsonError {
                    print ("specials json error:",jsonError)
                }
            } catch let error {
                print(error)
            }
        } else {
            print("Didn't enter do")
        }
    }
    
    func fetchDataLive() {   //Blair's Database static
        let urlFA = "http://www.houstonspotters.net/resources/FlightTracker/getDataDB.php"
        guard let url = URL(string: urlFA) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                self.specials = try JSONDecoder().decode([specialsArray].self, from: data)
                self.specials = self.specials.sorted {$0.airline.localizedCaseInsensitiveCompare($1.airline) == .orderedAscending}
                //                    print(specials)
                self.tempSpecials = self.specials
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let jsonError {
                print ("json2 error:",jsonError)
            }
        }.resume()
    }
    
}
