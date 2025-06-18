//
//  SplashScreenView.swift
//  swiftUI
//
//  Created by Invicttus on 18/06/2025.
//


import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            Image("splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            isActive = false
                        }
                    }
                }
        }
    }
}
