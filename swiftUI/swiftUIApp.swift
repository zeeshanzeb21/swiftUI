//
//  swiftUIApp.swift
//  swiftUI
//
//  Created by Invicttus on 14/05/2025.
//

import SwiftUI
import Alamofire

@main
struct swiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            WebScreen(searchText: "")
        }
    }
}
