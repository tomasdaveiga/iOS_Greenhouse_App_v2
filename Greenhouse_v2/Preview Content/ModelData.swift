//
//  ModelData.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import Foundation

var previewGreenhouseData: GreenhouseData = load("greenhouseDemo.json")
var previewTempData: WholeVariableData = processTempDataPreview(previewGreenhouseData)
var previewHumidityData: WholeVariableData = processHumidityDataPreview(previewGreenhouseData)
var previewLightData: WholeVariableData = processLightDataPreview(previewGreenhouseData)
var previewWindowData: WholeVariableData = processWindowDataPreview(previewGreenhouseData)

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
    
    var tempPreview = WholeVariableData(name: "Temperature", symbol: "thermometer.medium", data: [], units: "\u{00B0}", numPoints: 0)

    //So, for every element of the array feeds, so for each feed, I want to save each field into each WholeDataVariable
    for i in 0 ... (greenhouseData.channel.numEntries-1) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fullDate = formatter.date(from: greenhouseData.feeds[i].created_at) ?? Date()
        tempPreview.data.append(DataPoint(date: fullDate, value: greenhouseData.feeds[i].temperature))
    }
    tempPreview.numPoints = greenhouseData.channel.numEntries-1
    return tempPreview
}

func processHumidityDataPreview(_ greenhouseData: GreenhouseData) -> WholeVariableData{
    
    var humidityPreview = WholeVariableData(name: "Humidity", symbol: "humidity", data: [], units: "\u{0025}", numPoints: 0)

    //So, for every element of the array feeds, so for each feed, I want to save each field into each WholeDataVariable
    for i in 0 ... (greenhouseData.channel.numEntries-1) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fullDate = formatter.date(from: greenhouseData.feeds[i].created_at) ?? Date()
        humidityPreview.data.append(DataPoint(date: fullDate, value: greenhouseData.feeds[i].humidity))
    }
    humidityPreview.numPoints = greenhouseData.channel.numEntries-1
    return humidityPreview
}

func processLightDataPreview(_ greenhouseData: GreenhouseData) -> WholeVariableData{
    
    var lightPreview = WholeVariableData(name: "Light", symbol: "light.max", data: [], units: "\u{0025}", numPoints: 0)

    //So, for every element of the array feeds, so for each feed, I want to save each field into each WholeDataVariable
    for i in 0 ... (greenhouseData.channel.numEntries-1) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fullDate = formatter.date(from: greenhouseData.feeds[i].created_at) ?? Date()
        lightPreview.data.append(DataPoint(date: fullDate, value: greenhouseData.feeds[i].light))
    }
    lightPreview.numPoints = greenhouseData.channel.numEntries-1
    return lightPreview
}


func processWindowDataPreview(_ greenhouseData: GreenhouseData) -> WholeVariableData{
    
    var windowPreview = WholeVariableData(name: "Window", symbol: "window.ceiling", data: [], units: "\u{0025}", numPoints: 0)

    //So, for every element of the array feeds, so for each feed, I want to save each field into each WholeDataVariable
    for i in 0 ... (greenhouseData.channel.numEntries-1) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fullDate = formatter.date(from: greenhouseData.feeds[i].created_at) ?? Date()
        windowPreview.data.append(DataPoint(date: fullDate, value: greenhouseData.feeds[i].windowAngle))
    }
    windowPreview.numPoints = greenhouseData.channel.numEntries-1
    return windowPreview
}
