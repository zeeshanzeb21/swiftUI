//
//  swiftUIApp.swift
//  swiftUI
//
//  Created by Invicttus on 14/05/2025.
//

import SwiftUI
import Alamofire
import Firebase
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
    return true
  }
}
