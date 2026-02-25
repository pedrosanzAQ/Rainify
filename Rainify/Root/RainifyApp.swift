//
//  RainifyApp.swift
//  Rainify
//
//  Created by pedrosanz on 15/03/25.
//

import SwiftUI
import CoreLocation

@main
struct RainifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if let container = appDelegate.dependencies?.container {
                AppView(viewmodel: AppViewModel(container: container))
            } else {
                ProgressView()
            }
        }
    }
}

struct EnvironmentBuilderView<Content: View> : View {
    let appDelegate: AppDelegate
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .environment(appDelegate.dependencies.container)
    }
}

@MainActor
class DeviceInfo: ObservableObject {
    @Published var screenWidthInPixels: CGFloat = 0

    init() {
        self.screenWidthInPixels = UIScreen.main.bounds.width
    }
}
