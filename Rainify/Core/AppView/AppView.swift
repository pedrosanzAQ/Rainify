//
//  AppView.swift
//  Rainify
//
//  Created by pedrosanz on 16/06/25.
//

import SwiftUI

struct AppView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State var viewmodel: AppViewModel
    @State var appState: AppState = AppState()
    @State var appSettings: AppSettings = AppSettings()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if viewmodel.isAppReady {
                    AppViewBuilder(
                        showTabBar: appState.showTabBar,
                        tabbarView: {
                            TabbarView(viewmodel: TabbarViewModel(container: viewmodel.container))
                                .environment(appSettings)
                        },
                        onboardingView: {
                            WelcomeView(viewmodel: WelcomeViewModel(container: viewmodel.container, onFinished: {
                                appState.updateViewState(showTabBarView: true)
                            }))
                        }
                    )
                } else {
                    LauchReplicaView()
                }
            }
            .frame(
                width: geo.size.width,
                height: geo.size.height,
                alignment: .center
            )
            .task {
                await viewmodel.loadLocations()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    viewmodel.appBecomeActive()
                    
                case .inactive, .background:
                    viewmodel.onAppWentToBackground()
                    
                @unknown default:
                    break
                }
            }
            .environment(\.safeAreaInsets, geo.safeAreaInsets)
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.78)
                .ignoresSafeArea()
            
            VStack(){
                ProgressView()
                    .padding(.bottom, 12)
                    .font(.headline)
                
                Text("Loading weather...")
                    .font(.subheadline)
            }
        }
    }
}

import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets = .init()
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

#Preview("FirstTime"){
    let container = DevPreview.shared.container
    container.register(LocationsPersistenceManager.self, service: LocationsPersistenceManager(service: MockLocationsPersistenceService(citis: [])))
    
    return AppView(viewmodel: AppViewModel(container: container), appState: AppState(showTabBar: false))
}

#Preview("SecondTime"){
    let container = DevPreview.shared.container
    container.register(LocationsPersistenceManager.self, service: LocationsPersistenceManager(service: MockLocationsPersistenceService()))
    return AppView(viewmodel: AppViewModel(container: DevPreview.shared.container), appState: AppState(showTabBar: true))
}
