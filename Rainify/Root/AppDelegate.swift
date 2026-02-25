//
//  AppDelegate.swift
//  Rainify
//
//  Created by pedrosanz on 25/02/26.
//
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dependencies = Dependencies()
        return true
    }
}
