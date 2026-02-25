//
//  TabbarViewModel.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI

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
