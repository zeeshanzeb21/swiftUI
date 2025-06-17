//
//  Enum.swift
//  swiftUI
//
//  Created by Invicttus on 29/05/2025.
//

import Foundation

enum Route: Hashable {
    case web(searchText: String, searchType: String,navigateRight: Bool)
    case webDetail(searchText: String, hrefLink: String)
    case howToUse
    case rateUs
    case feedbackScreen
}
