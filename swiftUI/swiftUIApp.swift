//
//  swiftUIApp.swift
//  swiftUI
//
//  Created by Invicttus on 14/05/2025.
//

import SwiftUI
import Alamofire
import Firebase
import Foundation
import FirebaseAnalytics
@main
struct swiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isActive: Bool = true


    var body: some Scene {
        WindowGroup {
            ZStack {
                if isActive {
                    SplashScreenView(isActive: $isActive)
                        .transition(.opacity)
                } else {
                    BrowserHomeView(searchText: "Search Here...")
                        .transition(.opacity)
                }
            }
        }


    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Analytics.setAnalyticsCollectionEnabled(true)

      let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isLaunchedBefore")
      

          
          if isFirstLaunch {
              UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
              
              Analytics.logEvent("first_app_open", parameters: [
                  "message": "App launched for the first time"
              ])

          }
      else
      {
          Analytics.logEvent("app_open", parameters: [
              "message": "App opened by the user"
          ])
          UserDefaults.standard.set(false, forKey: "showToast")


          
      }
    
    return true
  }
}
