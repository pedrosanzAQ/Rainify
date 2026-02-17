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
            
            NavigationStack {
                SearchView(viewmodel: SearchViewModel(container: viewmodel.container))
            }
            .tabItem ({ Image(systemName: "magnifyingglass") })
            .tag(TypeBar.search)
        }
        .environment(viewmodel)
    }
}

@Observable
@MainActor
class TabbarViewModel {
    var selectedTab: TypeBar = .weather
    var selectedLocationId: Int? = nil
    let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
}

enum TypeBar {
    case weather
    case search
}

#Preview {
    TabbarView(viewmodel: TabbarViewModel(container: DevPreview.shared.container))
}

