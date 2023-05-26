//
//  GreenhouseView.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import SwiftUI
import Foundation

struct GreenhouseView: View {
    var greenhouse: GreenhouseData
    var tempData: WholeVariableData
    var humidityData: WholeVariableData
    var lightData: WholeVariableData
    var windowData: WholeVariableData
    
    let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .top){
                    Image("greenhouse_vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(y: -20)
                        
                    Text("Greenhouse")
                        .bold().font(.system(size: 50))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .offset(y: -40)
                }
                
                VStack{
                    if(calendar.isDateInToday(tempData.data[tempData.numPoints-1].date)){
                        Text("Last Reading today at " + tempData.data[tempData.numPoints-1].date.formatted(date: .omitted, time: .shortened))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .offset(x: -20)
                            .offset(y: 10)
                    }else if(calendar.isDateInYesterday(tempData.data[tempData.numPoints-1].date)){
                        Text("Last Reading yesterday at " + tempData.data[tempData.numPoints-1].date.formatted(date: .omitted, time: .shortened))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .offset(x: -20)
                            .offset(y: 10)
                    }else{
                        Text("Last reading " + tempData.data[tempData.numPoints-1].date.formatted(date: .abbreviated, time: .shortened))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .offset(x: -20)
                            .offset(y: 10)
                    }
                    if (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature > 19){
                        NavigationLink(destination: DetailedDataView(inputData: tempData)){
                            VariableRow(logo: "thermometer.sun", name: "Temperature", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature.roundDouble()+"°"))
                        }
                    }
                    else{ if(greenhouse.feeds[greenhouse.channel.numEntries-1].temperature < 10){
                        NavigationLink(destination: DetailedDataView(inputData: tempData)){
                            VariableRow(logo: "thermometer.snowflake", name: "Temperature", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature.roundDouble()+"°"))
                            }
                        }
                        else{
                            NavigationLink(destination: DetailedDataView(inputData: tempData)){
                                VariableRow(logo: "thermometer.medium", name: "Temperature", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature.roundDouble()+"°"))
                            }
                        }
                    }
                    //Spacer()
                    NavigationLink(destination: DetailedDataView(inputData: humidityData)){
                        VariableRow(logo: "humidity", name: "Humidity", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].humidity.roundDouble()))
                    }
                    NavigationLink(destination: DetailedDataView(inputData: lightData)){
                        VariableRow(logo: "light.max", name: "Light", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].light.roundDouble()))
                    }
                    NavigationLink(destination: DetailedDataView(inputData: windowData)){
                        VariableRow(logo: "window.ceiling", name: "Window", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].windowAngle.roundDouble()))
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(hue: 0.6, saturation: 0.887, brightness: 0.557))
            .preferredColorScheme(.dark)
        }
    }
}

struct GreenhouseView_Previews: PreviewProvider {
    static var previews: some View {
        GreenhouseView(greenhouse: previewGreenhouseData, tempData: previewTempData, humidityData: previewHumidityData, lightData: previewLightData, windowData: previewWindowData)
    }
}

class GreenhouseUIView: UIView {
    private let hostingController: UIHostingController<GreenhouseView>
    
    init(greenhouse: GreenhouseData, tempData: WholeVariableData, humidityData: WholeVariableData, lightData: WholeVariableData, windowData: WholeVariableData) {
        hostingController = UIHostingController(rootView: GreenhouseView(greenhouse: greenhouse, tempData: tempData, humidityData: humidityData, lightData: lightData, windowData: windowData))
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
