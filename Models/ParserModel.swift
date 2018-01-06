//
//  ParserModel.swift
//  Spotters
//
//  Created by Walter Edgar on 12/23/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import Foundation

// struct for XML https://www.aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars
struct Metar {
    let raw_text: String
    let station_id: String
    let observation_time: String
}


class FeedParser: NSObject, XMLParserDelegate {
    var metars: [Metar] = []
    private var currentElement = ""
    private var currentMetar = "" {
        didSet {
            currentMetar = currentMetar.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentStation = "" {
        didSet {
            currentStation = currentStation.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTime = "" {
        didSet {
            currentTime = currentTime.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: (([Metar]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([Metar]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print (error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "METAR" {
            currentMetar = ""
            currentStation = ""
            currentTime = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "raw_text": currentMetar += string
        case "station_id": currentStation += string
        case "observation_time": currentTime += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "METAR" {
            let myMetar = Metar(raw_text: currentMetar, station_id: currentStation, observation_time: currentTime)
            self.metars.append(myMetar)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(metars)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
