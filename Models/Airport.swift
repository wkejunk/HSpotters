//
//  Airport.swift
//  Spotters
//
//  Created by Walter Edgar on 12/9/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import Foundation

//struct for specials
//struct specialsArray: Decodable {
//    let ident: String
//    let airline: String
//    let description: String
//    let airlineCode: String
//}

struct Airport: Decodable {
    let id: Int
    let name: String
    let lat: Double
    let long: Double
}
struct AirportInfoFA: Decodable {
    let AirportInfoResult: Results
}

struct Results: Decodable {
let airport_code: String
let name: String
let city: String
}

// struct for http://avwx.rest/api/metar/
struct AvMetar: Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case Station, Speech, Summary, Info, Remarks, Translations, Time,
        FlightRules = "Flight-Rules",
        RawReport = "Raw-Report"
    }
    
    let Station: String
    let Speech: String
    let Summary: String
    let Info: DicInfo
    let Remarks: String
    let Translations: DicTranlations
    let Time: String
    let FlightRules: String
    let RawReport: String
}

struct DicTranlations: Decodable {
    let Altimeter: String
    let Clouds: String
    let Dewpoint: String
    let Other: String
    let Remarks: Dictionary<String,String>
    let Temperature: String
    let Visibility: String
    let Wind: String
}

struct DicInfo: Decodable {
    let Name: String
    let ICAO: String
}
    
class AirportPickerConfig {
    let airports = ["Current Location", "KIAH", "KHOU", "KEFD", "KSGR", "KDWH", "KCXO", "KAXH", "KIWS", "KGLS", "KTME", "KEYQ", "KHPY", "T41"] //SOME HAVE NO METAR
    let houstonAirports: Set = (["KIAH", "KHOU", "KEFD", "KSGR", "KDWH", "KCXO", "KAXH", "KIWS", "KGLS", "KTME", "KEYQ", "KHPY", "T41"])
    let airportNames = ["Current Location",
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
    
}
