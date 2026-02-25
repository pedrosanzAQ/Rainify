//
//  TabbarView.swift
//  Rainify
//
//  Created by pedrosanz on 18/03/25.
//

import SwiftUI

struct TabbarView: View {
    @State var viewmodel: TabbarViewModel
    
    var body: some View {
        TabView(selection: $viewmodel.selectedTab){
            NavigationStack {
                WeatherRootView(viewmodel: WeatherRootViewModel(container: viewmodel.container))
            }
            .tabItem ({ Image(systemName: "smoke") })
            .tag(TypeBar.weather)
            
            // has navigationStack inside of it 
            SearchView(viewmodel: SearchViewModel(container: viewmodel.container))
            .tabItem ({ Image(systemName: "magnifyingglass") })
            .tag(TypeBar.search)
        }
        .environment(viewmodel)
    }
}

#Preview {
    let appSettings = AppSettings()
    TabbarView(viewmodel: TabbarViewModel(container: DevPreview.shared.container))
        .environment(appSettings)
}

