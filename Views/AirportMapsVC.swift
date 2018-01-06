//
//  AirportMapsVC.swift
//  Spotters
//
//  Created by Walter Edgar on 11/26/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit
import SafariServices

class AirportMapsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet weak var LocationOrDiagram: UISegmentedControl!
    
    //        &hl=en language en - english
    //        &t=k k - satellite, m - normal map, h - hybrid, p - terrain
    
    @IBAction func launchIAHMapButtonPressed() {
        let mapSelect = self.LocationOrDiagram.selectedSegmentIndex
        switch mapSelect {
        case 0:
            if let url = URL(string: "https://www.google.com/maps/d/viewer?mid=17N3kVcC-r2e_zX61mxa3kT-fO90&hl=en&ll=29.979108547581166,-95.31700500000005&z=12&t=k") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
            }
        case 1:
            if let url = URL(string: "http://aeronav.faa.gov/d-tpp/1713/05461ad.pdf#nameddest=(IAH)") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 2:
            if let url = URL(string: "http://iahmaps.fly2houston.com/?vid=iah") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        default:
            if let url = URL(string: "https://www.google.com/maps/d/viewer?mid=17N3kVcC-r2e_zX61mxa3kT-fO90&hl=en&ll=29.979108547581166,-95.31700500000005&z=12&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }

    }

    @IBAction func launchDWHMapButtonPressed() {
        let mapSelect = self.LocationOrDiagram.selectedSegmentIndex
        switch mapSelect {
        case 0:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1WwkcMxvGXFNQyZJxOdzOlE4btWE&hl=en&ll=30.066414951600898%2C-95.5468539090233&z=14&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 1:
            if let url = URL(string: "http://aeronav.faa.gov/d-tpp/1713/05457ad.pdf#nameddest=(DWH)") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 2:
            noGateMap()
        default:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1WwkcMxvGXFNQyZJxOdzOlE4btWE&hl=en&ll=30.066414951600898%2C-95.5468539090233&z=14&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func launchHOUMapButtonPressed() {
        let mapSelect = self.LocationOrDiagram.selectedSegmentIndex
        switch mapSelect {
        case 0:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1QWvsgKBI8R0zSgU0y7HZ5u68T6o&hl=en&ll=29.645297789617118%2C-95.27693550000004&z=14&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 1:
            if let url = URL(string: "http://aeronav.faa.gov/d-tpp/1713/00198ad.pdf#nameddest=(HOU)") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 2:
            if let url = URL(string: "http://iahmaps.fly2houston.com/?vid=hou") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
            
        default:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1QWvsgKBI8R0zSgU0y7HZ5u68T6o&hl=en&ll=29.645297789617118%2C-95.27693550000004&z=14&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func launchEFDMapButtonPressed() {
        let mapSelect = self.LocationOrDiagram.selectedSegmentIndex
        switch mapSelect {
        case 0:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1Dsb3627Ta77HDYaYgBjxZlRWd2o&hl=en&ll=29.594735607377206%2C-95.170323&z=14&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 1:
            if let url = URL(string: "http://aeronav.faa.gov/d-tpp/1713/00197ad.pdf#nameddest=(EFD)") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 2:
            noGateMap()
        default:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1Dsb3627Ta77HDYaYgBjxZlRWd2o&hl=en&ll=29.594735607377206%2C-95.170323&z=14&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
     }

    @IBAction func launchIWSMapButtonPressed() {
    
        let mapSelect = self.LocationOrDiagram.selectedSegmentIndex
        switch mapSelect {
        case 0:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1bZxr94kSNeZc-v6TcjUaIMcAXpM&hl=en&ll=29.81613150101496%2C-95.671472&z=16&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 1:
           noFaaMap()
        case 2:
            noGateMap()
        default:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=1bZxr94kSNeZc-v6TcjUaIMcAXpM&hl=en&ll=29.81613150101496%2C-95.671472&z=16&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func launchGLSMapButtonPressed() {
        let mapSelect = self.LocationOrDiagram.selectedSegmentIndex
        switch mapSelect {
        case 0:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=18buMy0EB2uZ18TSnk33qTyDe9IY&hl=en&ll=29.270114131843666%2C-94.85494200000005&z=13&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 1:
            if let url = URL(string: "http://aeronav.faa.gov/d-tpp/1713/00164ad.pdf#nameddest=(LGS)") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case 2:
            noGateMap()
        default:
            if let url = URL(string: "https://www.google.com/maps/d/u/0/viewer?mid=18buMy0EB2uZ18TSnk33qTyDe9IY&hl=en&ll=29.270114131843666%2C-94.85494200000005&z=13&t=k") {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    func noGateMap() {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let noGate = UIAlertController(title: "Missing Diagram", message: "Gate Diagram Not Available for this Airport", preferredStyle: .alert)
        noGate.addAction(okAction)
        present(noGate, animated: true, completion: nil)
    }
    func noFaaMap() {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let noFAA = UIAlertController(title: "Missing Diagram", message: "FAA Diagram Not Available for this Airport", preferredStyle: .alert)
        noFAA.addAction(okAction)
        present(noFAA, animated: true, completion: nil)
    }
}
