//
//  WeatherManager.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 01/05/2023.
//

import Foundation

class GreenhouseDataManager {
    
    var greenhouseData: GreenhouseData
    var tempData: WholeVariableData
    var humidityData: WholeVariableData
    var lightData: WholeVariableData
    var windowData: WholeVariableData
    
    init(){
        greenhouseData = GreenhouseData(channel: GreenhouseData.ChannelResponse(id: 0, name: "", latitude: "", longitude: "", field1: "", field2: "", field3: "", field4: "", last_entry_id: 0), feeds: [])
        tempData = WholeVariableData(name: "Temperature", symbol: "thermometer.no_weather", data: [], units: "\u{00B0}")
        humidityData = WholeVariableData(name: "Humidity", symbol: "humidity", data: [], units: "\u{0025}")
        lightData = WholeVariableData(name: "Sunlight", symbol: "light.max", data: [], units: "\u{0025}")
        windowData = WholeVariableData(name: "Window Angle", symbol: "window.ceiling", data: [], units: "\u{0025}")
    }
    
    func fetchData() async throws {
        guard let url = URL(string: "https://api.thingspeak.com/channels/2128848/feeds.json?api_key=P983C0G1H6RO2L1Z") else {fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching greenhouse data")}
        let decodedData = try JSONDecoder().decode(GreenhouseData.self, from: data)
        greenhouseData = decodedData
        processData()
    }
    
    func processData(){        
        //So, for every element of the array feeds, so for each feed, I want to save each field into each WholeDataVariable
        for i in 0 ... greenhouseData.channel.numEntries-1 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let fullDate = formatter.date(from: greenhouseData.feeds[i].created_at) ?? Date()
            
            tempData.data.append(DataPoint(date: fullDate, value:greenhouseData.feeds[i].temperature))
            humidityData.data.append(DataPoint(date: fullDate, value:greenhouseData.feeds[i].humidity))
            lightData.data.append(DataPoint(date: fullDate, value:greenhouseData.feeds[i].light))
            windowData.data.append(DataPoint(date: fullDate, value:greenhouseData.feeds[i].windowAngle))
            
        }
    }
    
    func getTempData() -> WholeVariableData{
        return tempData
    }
    func getHumidityData() -> WholeVariableData{
        return humidityData
    }
    func getLightData() -> WholeVariableData{
        return lightData
    }
    func getWindowData() -> WholeVariableData{
        return windowData
    }
    
    func getGreenhouseData() -> GreenhouseData{
        return greenhouseData
    }
    
}

struct GreenhouseData: Decodable {
    var channel: ChannelResponse
    var feeds: [FeedResponse]
    
    struct ChannelResponse: Decodable {
        var id: Int
        var name: String
        var latitude: String
        var longitude: String
        var field1: String
        var field2: String
        var field3: String
        var field4: String
        var last_entry_id: Int
    }
    
    struct FeedResponse: Decodable {
        var created_at: String
        var entry_id: Int
        var field1: String
        var field2: String
        var field3: String
        var field4: String
    }
}

extension GreenhouseData.ChannelResponse {
    var numEntries: Int {return last_entry_id}
}

extension GreenhouseData.FeedResponse {
    var timeStamp: String {return created_at}
    var entryID: Int {return entry_id}
    var temperature: Double {return Double(field1)!}
    var humidity: Double {return Double(field2)!}
    var light: Double {return Double(field3)!}
    var windowAngle: Double {return Double(field4)!}
}

struct WholeVariableData {
    var name: String
    var symbol: String
    var data: [DataPoint]
    var units: String
}

struct DataPoint: Identifiable{
    let id = UUID()
    var date: Date
    var value: Double
}
