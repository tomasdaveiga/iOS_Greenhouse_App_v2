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
    
    var body: some View {
        VStack{
            //if let greenhouse = greenhouse {
                //GreenhouseView(greenhouse: greenhouse)
            if let tempData = tempData{
                DetailedDataView(inputData: tempData)
            } else {
                LoadingView()
                    .task {
                        do{
                            try await greenhouseManager.fetchData()
                            greenhouse = greenhouseManager.getGreenhouseData()
                            tempData = greenhouseManager.getTempData()
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
