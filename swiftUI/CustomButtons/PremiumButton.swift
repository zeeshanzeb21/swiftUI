//
//  CustomButton.swift
//  swiftUI
//
//  Created by Invicttus on 21/05/2025.
//

import SwiftUI

struct PremiumButton: ButtonStyle {
    var isFocused: Bool
    var width: CGFloat 
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: 80)
            .background(isFocused ? Color(hex: "#005C79") : Color.white)
            .cornerRadius(53)
            .overlay(
                RoundedRectangle(cornerRadius: 53)
                    .stroke(isFocused ? Color(hex: "#005C79") : Color(hex: "#E3E3E4").opacity(0.7), lineWidth: 4)
            )
    }
    }

struct PremiumButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Button(action: {
                print("Tapped")
            }) {
                Image("image")
                    .resizable()
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(BorderedButtonStyle(isFocused: true))
        }
    }
}

