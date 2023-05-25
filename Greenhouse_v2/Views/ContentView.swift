//
//  ContentView.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 16/04/2023.
//

import SwiftUI

struct ContentView: View {
    var greenhouseManager = GreenhouseDataManager()
    @State var greenhouse: GreenhouseData?
    @State var tempData: WholeVariableData?
    @State var humidityData: WholeVariableData?
    @State var lightData: WholeVariableData?
    @State var windowData: WholeVariableData?
    
    var body: some View {
        VStack{
            if let greenhouse = greenhouse,
                let tempData = tempData,
                let humidityData = humidityData,
                let lightData = lightData,
                let windowData = windowData {
                GreenhouseView(greenhouse: greenhouse, tempData: tempData, humidityData: humidityData, lightData: lightData, windowData: windowData)
            } else {
                LoadingView()
                    .task {
                        do{
                            try await greenhouseManager.fetchData()
                            tempData = greenhouseManager.getTempData()
                            humidityData = greenhouseManager.getHumidityData()
                            lightData = greenhouseManager.getLightData()
                            windowData = greenhouseManager.getWindowData()
                            greenhouse = greenhouseManager.getGreenhouseData()
                        } catch{
                            print("Error getting greenhouse: \(error)")
                        }
                    }
            }
        }
        .background(Color(hue: 0.6, saturation: 0.887, brightness: 0.557))
        .preferredColorScheme(.dark)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
