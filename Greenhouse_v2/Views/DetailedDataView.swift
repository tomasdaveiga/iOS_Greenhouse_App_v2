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
    
    @State private var touchLocation: CGPoint = .zero
    @State private var isTouching: Bool = false
    @State var currentTab: String = "1D"
    
    init(inputData: WholeVariableData){
        VariableData = inputData
    }
    
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
            Spacer()
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
        .chartOverlay{ proxy in
            GeometryReader { geometry in
                if isTouching {
                    if let closestDataPoint = getClosestDataPoint(touchLocation, proxy, in: geometry, currentData) {
                        let yValue = closestDataPoint.value
                        let formattedYValue = String(format: "%.0f", yValue)
                        Text(formattedYValue)
                            .font(.title)
                            .foregroundColor(.white)
                            .position(x: touchLocation.x, y: -30)
                        let plotViewHeight = geometry.size.height - 20 // Adjust the height as needed
                        Path { path in
                            path.move(to: CGPoint(x: touchLocation.x, y: 0))
                            path.addLine(to: CGPoint(x: touchLocation.x, y: plotViewHeight))
                        }
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.white)
                            
                        let intersectionPoint = CGPoint(x: touchLocation.x, y: proxy.position(forY: yValue)!)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .position(intersectionPoint)
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    handleDragGesture(gesture)
                }
                .onEnded { gesture in
                    handleDragGestureEnd(gesture)
                }
        )
    }
    
    private func handleDragGesture(_ gesture: DragGesture.Value) {
        let location = gesture.location
        touchLocation = location
        isTouching = true
    }
        
    private func handleDragGestureEnd(_ gesture: DragGesture.Value) {
        touchLocation = .zero
        isTouching = false
    }
    
    private func getClosestDataPoint(_ touchPosition: CGPoint, _ proxy: ChartProxy, in geometry: GeometryProxy, _ currentData: [DataPoint]) -> DataPoint? {
        let xPosition = touchPosition.x - geometry[proxy.plotAreaFrame].origin.x
        if let dateSelected: Date = proxy.value(atX: xPosition) {
            let closestDataPoint = currentData.min(by: { abs($0.date.timeIntervalSince(dateSelected)) < abs($1.date.timeIntervalSince(dateSelected)) })
            touchLocation.x = proxy.position(forX: closestDataPoint!.date)!
            return closestDataPoint
        }
        return nil
    }
}

struct InDepthData_Previews: PreviewProvider {
    static var previews: some View {
        DetailedDataView(inputData: previewTempData)
    }
}
