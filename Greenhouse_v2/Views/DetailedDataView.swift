//
//  TemperatureData.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import SwiftUI
import Charts

struct DetailedDataView: View {
    private var data: WholeVariableData
    
    init(inputData: WholeVariableData){
        data = inputData
    }
    
    @State var currentTab: String = "Max"
    @State var currentActiveItem: DataPoint?
    @State var plotWidth: CGFloat = 0
    var body: some View {
        LazyVStack{
            HStack{
                Image(systemName: data.symbol)
                    .font(.system(size: 70))
                    .frame(width: 100, height: 100, alignment: .leading)
                Text(data.name)
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
            chartView()
            Spacer()
            
        }
        .font(.caption)
        .foregroundColor(.black)
        .background(.white)
    }
    
    /*
    func checkActiveItem(item: DataPoint){
        if let currentActiveItem,currentActiveItem.id == item.id{
            RuleMark(x: .value("Hour", currentActiveItem.value))
                .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                .offset(x: (plotWidth / CGFloat(data.data.count)) / 2)
                .annotation(position: .top){
                    VStack(alignment: .leading, spacing: 6){
                        Text(data.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(String(currentActiveItem.value))
                            .font(.title3.bold())
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background{
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.white.shadow(.drop(radius: 2)))
                    }
                }
        }
    }
    */
    
    @ViewBuilder
    func chartView()->some View{
        let max = data.data.max{ item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        let min = data.data.min{ item1, item2 in
            return item1.value < item2.value
        }?.value ?? 0
        
        Chart{
            ForEach(data.data){ item in
                LineMark(
                    x: .value("Hour", item.date.formatted(date: .omitted, time: .shortened)),
                    y: .value("Temperature", item.value)
                )
                //checkActiveItem(item: item)
            }
        }
        .chartYScale(domain: (min - 2)...(max + 2))
        /*
        .chartOverlay(content: {proxy in
            GeometryReader{innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x){
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    if let currentItem = data.data.first(where: {item in calendar.component(.hour, from: item.date) == hour}){
                                       self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }.onEnded{value in
                                self.currentActiveItem = nil
                            }
                    )
            }
         
        })
         */
        .frame(height: 300)
    }
}

struct InDepthData_Previews: PreviewProvider {
    static var previews: some View {
        DetailedDataView(inputData: previewTemperatureData)
    }
}
