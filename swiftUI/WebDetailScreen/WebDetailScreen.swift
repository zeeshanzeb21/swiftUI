//
//  WebDetailScreen.swift
//  swiftUI
//
//  Created by Invicttus on 27/05/2025.
//

import SwiftUI

struct WebDetailScreen: View {
    @ObservedObject var viewModel = DetailViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                viewModel.getScreenShots(urls: "https://www.cricketwireless.com/", ux_type: 1, ss_width: 0, ss_height: 0)
            }
    }
}

#Preview {
    WebDetailScreen()
}
