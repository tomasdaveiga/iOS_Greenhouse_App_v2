//
//  GreenhouseView.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import SwiftUI

struct GreenhouseView: View {
    var greenhouse: GreenhouseData
    
    var body: some View {
        ZStack(alignment: .leading){
            VStack{
                ZStack(alignment: .top){
                    Image("greenhouse_vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                
                        Text("Greenhouse")
                            .bold().font(.system(size: 50))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                }
                
                Spacer(minLength: 20)
                
                VStack{
                    if (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature > 19){
                        VariableRow(logo: "thermometer.sun", name: "Temperature", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature.roundDouble()+"°"))
                    }
                    else if(greenhouse.feeds[greenhouse.channel.numEntries-1].temperature < 10){
                        VariableRow(logo: "thermometer.snowflake", name: "Temperature", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature.roundDouble()+"°"))
                    }
                    else{
                        VariableRow(logo: "thermometer.no_weather", name: "Temperature", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].temperature.roundDouble()+"°"))
                    }
                    Spacer()
                    VariableRow(logo: "humidity", name: "Humidity", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].humidity.roundDouble()))
                    Spacer()
                    VariableRow(logo: "light.max", name: "Light", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].light.roundDouble()))
                    Spacer()
                    VariableRow(logo: "window.ceiling", name: "Window", value: (greenhouse.feeds[greenhouse.channel.numEntries-1].windowAngle.roundDouble()))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.6, saturation: 0.887, brightness: 0.557))
        .preferredColorScheme(.dark)
               
    }
    
}

struct GreenhouseView_Previews: PreviewProvider {
    static var previews: some View {
        GreenhouseView(greenhouse: previewGreenhouseData)
    }
}

class GreenhouseUIView: UIView {
    private let hostingController: UIHostingController<GreenhouseView>
    
    init(greenhouse: GreenhouseData) {
        hostingController = UIHostingController(rootView: GreenhouseView(greenhouse: greenhouse))
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
