//
//  Specials.swift
//  Airport
//
//  Created by Walter Edgar on 12/26/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import Foundation

struct specialsArray: Decodable {
    let ident: String
    var identNoDash: String?
    let airline: String
    let description: String
    let airlineCode: String
}

struct specialsArrayAwc: Decodable {
    let country: String
    let airline: String
    let type: String
    let ident: String
    var identNoDash: String?
    let description: String
}

