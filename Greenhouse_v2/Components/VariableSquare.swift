//
//  WeatherRow.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import SwiftUI

struct VariableSquare: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        
        
        HStack(spacing: 0) {
            Image(systemName: logo)
                .font(.system(size: 45))
                .frame(width: 60, height: 80)
            
                HStack(spacing: 0){
                    Text(value)
                        .bold()
                        .font(.system(size: 30))
                    if(!(name=="Temperature")){
                        Text("%")
                            .bold()
                            .font(.system(size: 15))
                    }
                }
                .frame(width: 80, height: 80, alignment: .trailing)
        }
        .foregroundColor(Color(hue: 0.6, saturation: 0.887, brightness: 0.557))
        .frame(width: 150, height: 100)
        .background(.white)
        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        .border(Color.blue)
    }
}

struct VariableSquare_Previews: PreviewProvider {
    static var previews: some View {
        VariableSquare(logo: "thermometer", name: "Light", value: "9")
    }
}
