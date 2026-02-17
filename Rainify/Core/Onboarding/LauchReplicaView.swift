//
//  LauchReplicaView.swift
//  Rainify
//
//  Created by pedrosanz on 14/02/26.
//

import SwiftUI

struct LauchReplicaView: View {
    var body: some View {
        ZStack {
            Color(red: 53/255, green: 75/255, blue: 105/255)
                .ignoresSafeArea()
            
//            Text("Rainify")
//                .font(.title)
            VStack {
                Image("weatherLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
//                    .padding(.top, -20)
                
                Text("Rainify")
                    .font(.title)
                    .padding(.top, -68)
                    .foregroundStyle(Color.white)
            }
            .padding(.bottom, 60)

        }
    }
}

#Preview {
    LauchReplicaView()
}
