//
//  SpecialsAWCTableVC.swift
//  Spotters
//
//  Created by Walter Edgar on 1/1/18.
//  Copyright © 2018 Walter Edgar. All rights reserved.
//

import UIKit
import SafariServices

enum selectedScope1:Int {
    case airline = 0
    case tail = 1
    case type = 2
    case coountry = 3
    case description = 4
    
}

class SpecialsAWCTableVC: UITableViewController, UISearchBarDelegate {
    @IBOutlet var myTableView: UITableView!
    var specialsAwc: [specialsArrayAwc] = []
    var tempSpecialsAwc: [specialsArrayAwc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        myTableView.rowHeight = UITableViewAutomaticDimension
        self.searchBarSetup()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        getSpeicalsAWC()
        tempSpecialsAwc = specialsAwc
    }

    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 60))
        //        searchBar.sizeToFit()
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Airline","Tail","Type","Country","Special"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        //        navigationItem.titleView = searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tempSpecialsAwc = specialsAwc
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tempSpecialsAwc = specialsAwc
            self.tableView.reloadData()
            
        } else {
            let char = searchText.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("backspace")
                tempSpecialsAwc = specialsAwc
                filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
                self.tableView.reloadData()
            }
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }

    func filterTableView(ind:Int, text: String) {
        switch ind {
        case selectedScope1.airline.rawValue:
            tempSpecialsAwc = specialsAwc.filter({(mod) -> Bool in
                return mod.airline.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope1.tail.rawValue:
            tempSpecialsAwc = specialsAwc.filter({(mod) -> Bool in
                return mod.ident.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope1.type.rawValue:
            tempSpecialsAwc = specialsAwc.filter({(mod) -> Bool in
                return mod.type.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope1.coountry.rawValue:
            tempSpecialsAwc = specialsAwc.filter({(mod) -> Bool in
                return mod.country.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectedScope1.description.rawValue:
            tempSpecialsAwc = specialsAwc.filter({(mod) -> Bool in
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
        
        return tempSpecialsAwc.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        let tailNum = tempSpecialsAwc[indexPath.row].ident
        let flightAwareURL = "https://flightaware.com/live/flight/\(tailNum)"
        if let url = URL(string: flightAwareURL) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! SpecialsAWCTVCell
        
        let airline = tempSpecialsAwc[indexPath.row].airline
        let tail = tempSpecialsAwc[indexPath.row].ident
        let country = tempSpecialsAwc[indexPath.row].country
        let type = tempSpecialsAwc[indexPath.row].type
        let airlineTail = "\(airline) • \(tail) • \(type) • \(country) "
        myCell.airlineLabel.text = airlineTail
        myCell.descriptionLabel.text = tempSpecialsAwc[indexPath.row].description
        
        return myCell
    }
    
    func getSpeicalsAWC() {
        if let path = Bundle.main.path(forResource: "SpecialsAWC", ofType: "geojson") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    specialsAwc = try JSONDecoder().decode([specialsArrayAwc].self, from: data)
                    specialsAwc = specialsAwc.sorted {$0.airline.localizedCaseInsensitiveCompare($1.airline) == .orderedAscending}
                    tempSpecialsAwc = specialsAwc
                } catch let jsonError {
                    print ("Error Decoding specials from AWC List:",jsonError)
                }
            } catch let error {
                print(error)
            }
        } else {
            print("Didn't enter do")
        }
        
    }
}
