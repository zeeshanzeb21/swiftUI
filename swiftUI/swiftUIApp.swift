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
@main
struct swiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {

        WindowGroup {
                BrowserHomeView(searchText: "")
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
      }
    
    return true
  }
}
