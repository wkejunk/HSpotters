//
//  FlightAware.swift
//  Airport
//
//  Created by Walter Edgar on 12/24/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import Foundation

struct Flights: Decodable {
    let AirportBoardsResult: Result
}

struct Result: Decodable {
    let airport: String
    let airport_info: AirportInfo
    let arrivals: Info
    let departures: Info
    let enroute: Info
    let scheduled: Info
}

struct AirportInfo: Decodable {
    let airport_code: String
    let name: String
    let city: String
}

struct Info: Decodable {
    let num_flights: Int
    var flights: [FlightInfo]?
}

struct Objects: Decodable {    //This struct used for creating the TableView Sections
    var sectionName: String
    var flights: [FlightInfo]
}


struct FlightInfo: Decodable {
    let ident: String
    let airline: String
    var icon: String?
    let flightnumber: String
    var tailnumber: String?
    var tailnumberNoDash: String?
    var codeshares: String?
    let blocked: Bool?
    let diverted: Bool?
    let cancelled: Bool?
    let origin: City
    let destination: City
    var originOrDestCode: String?
    var originOrDestAirport: String?
    var originOrDestCity: String?
    let route: String?
    let distance_filed: Int?
    let filed_departure_time: Times
    let estimated_departure_time: Times
    let actual_departure_time: Times
    let departure_delay: Int?
    let filed_arrival_time: Times
    let estimated_arrival_time: Times
    let actual_arrival_time: Times
    var estArrDepTime: Int?
    var actArrDepTime: Int?
    let arrival_delay: Int?
    let status: String?
    let progress_percent: Int?
    let aircrafttype: String?
    let full_aircrafttype: String?
    let terminal_dest: String?
    let gate_dest: String?
    let gate_orig: String?
    var originOrDestGate: String?
    var specialsFlag: Bool?
    var specialsDescription: String?
}

struct Times: Decodable {
    let epoch: Int?
    let time: String?
    let date: String?
    let localtime: Int?
}

struct City: Decodable {
    let code: String?
    let city: String?
    let alternate_ident: String?
    let airport_name: String?
}

