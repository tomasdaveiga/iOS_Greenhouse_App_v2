//
//  TemperatureData.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import SwiftUI
import Charts

struct DetailedDataView: View {
    private var VariableData: WholeVariableData
    
    init(inputData: WholeVariableData){
        VariableData = inputData
    }
    
    @State var currentTab: String = "1D"
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Image(systemName: VariableData.symbol)
                    .font(.system(size: 70))
                    .frame(width: 100, height: 100, alignment: .leading)
                Text(VariableData.name)
                    .font(.system(size: 30))
            }
            
            Picker("", selection: $currentTab){
                Text("1D").tag("1D")
                Text("1W").tag("1W")
                Text("1M").tag("1M")
                Text("Max").tag("Max")
                }
                .pickerStyle(.segmented)
                .padding()
            chartView(currentTab: currentTab)
            Spacer()
            
        }
        .font(.caption)
        .foregroundColor(.white)
        .background(Color(hue: 0.6, saturation: 0.887, brightness: 0.557))
        .preferredColorScheme(.dark)
    }
    
    
    func chartView(currentTab: String)->some View{
        // Get the data format
        let calendar = Calendar.current
        let currentDate = Date()
                
        // Define the end of the X axis: always the last data point
        let endX = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate)!
        
        /* Define the start of the X axis: depends on the picker */
        var currentData: [DataPoint]
        
        // Default Single Day
        var startX = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: endX)!
        // Other Cases
        if(currentTab == "1W"){
            if(calendar.date(byAdding: .day, value: -6, to: endX)! > calendar.date(bySettingHour: 00, minute: 00, second: 00, of: VariableData.data[0].date)!){
                startX = calendar.date(byAdding: .day, value: -6, to: endX)!
                startX = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: startX)!
            }else{
                startX = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: VariableData.data[0].date)!
            }
        }else if(currentTab == "1M"){
            if(calendar.date(byAdding: .month, value: -1, to: endX)! > calendar.date(bySettingHour: 00, minute: 00, second: 00, of: VariableData.data[0].date)!){
                startX = calendar.date(byAdding: .month, value: -1, to: endX)!
                startX = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: startX)!
            }else{
                startX = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: VariableData.data[0].date)!
            }
        }else if(currentTab == "Max"){
            startX = calendar.date(bySettingHour: 00, minute: 00, second: 00, of: VariableData.data[0].date)!
        }
        
        currentData = VariableData.data.filter{ item in
            return item.date >= startX
        }
        
        
        // Define the Y axis limits
        let max = currentData.max{ item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        let min = currentData.min{ item1, item2 in
            return item1.value < item2.value
        }?.value ?? 0
        
        return Chart{
            ForEach(currentData){ item in
                LineMark(
                    x: .value("Hour", item.date),
                    y: .value("Temperature", item.value)
                )
            }
        }
        .chartXScale(domain: startX...endX)
        .chartYScale(domain: (min - 2)...(max + 2))
        .frame(width: 350)
        .frame(height: 300)
    }
}

struct InDepthData_Previews: PreviewProvider {
    static var previews: some View {
        DetailedDataView(inputData: previewTempData)
    }
}
