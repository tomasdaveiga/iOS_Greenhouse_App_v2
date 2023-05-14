//
//  ModelData.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import Foundation

var previewGreenhouseData: GreenhouseData = load("greenhouseDemo.json")
var previewTemperatureData: WholeVariableData = processTempDataPreview(previewGreenhouseData)


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func processTempDataPreview(_ greenhouseData: GreenhouseData) -> WholeVariableData{
    
    var tempPreview = WholeVariableData(name: "Temperature", symbol: "thermometer.sun", data: [], units: "\u{00B0}")

    //So, for every element of the array feeds, so for each feed, I want to save each field into each WholeDataVariable
    for i in 0 ... (greenhouseData.channel.numEntries-1) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fullDate = formatter.date(from: greenhouseData.feeds[i].created_at) ?? Date()
        tempPreview.data.append(DataPoint(date: fullDate, value: greenhouseData.feeds[i].temperature))
    }
    return tempPreview
}
