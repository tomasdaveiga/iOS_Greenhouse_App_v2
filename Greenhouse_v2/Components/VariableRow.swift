//
//  WeatherRow.swift
//  Greenhouse_v2
//
//  Created by Tomás Veiga on 02/05/2023.
//

import SwiftUI

struct VariableRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        
        
        HStack(spacing: 0) {
            Image(systemName: logo)
                .font(.system(size: 70))
                .frame(width: 100, height: 100, alignment: .trailing)
            Spacer(minLength: 20)
                HStack(spacing: 0){
                    Text(value)
                        .bold()
                        .font(.system(size: 70))
                    if(!(name=="Temperature")){
                        Text("%")
                            .bold()
                            .font(.system(size: 50))
                    }
                }
                .frame(width: 200, height: 100, alignment: .trailing)
                .padding()
        }
        .foregroundColor(Color(hue: 0.6, saturation: 0.887, brightness: 0.557))
        .frame(width: 350, height: 100)
        .background(.white)
        .cornerRadius(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        .cornerOutLine(25, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        .shadow(radius: 7)
        .padding()
    }
}

struct VariableRow_Previews: PreviewProvider {
    static var previews: some View {
        VariableRow(logo: "thermometer", name: "Light", value: "100")
    }
}
