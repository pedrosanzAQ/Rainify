//
//  NoConnectionView.swift
//  Rainify
//
//  Created by pedrosanz on 27/11/25.
//

import SwiftUI

struct WithoutConnectionView: View {
    var spacing: CGFloat? = 12
    
    var body: some View {
        VStack(spacing: spacing){
            Text("Error")
                .font(.headline)
                .foregroundColor(.theme.primary)
            
            Text("Please check your internet conection and try again")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.theme.secondary)
                
        }
    }
}

#Preview {
    WithoutConnectionView(spacing: 16)
}
