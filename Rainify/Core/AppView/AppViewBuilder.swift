//
//  AppViewBuilder.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI

struct AppViewBuilder<TabBarView: View, WelcomeView: View>: View {
    var showTabBar: Bool
    @ViewBuilder var tabbarView: TabBarView
    @ViewBuilder var onboardingView: WelcomeView
    
    var body: some View {
        ZStack {
            if showTabBar {
                tabbarView
                    .transition(.move(edge: .trailing))
            } else {
                onboardingView
                    .transition(.move(edge: .leading))
            }
        }
    }
}
