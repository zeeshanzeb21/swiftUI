//
//  CustomButton.swift
//  swiftUI
//
//  Created by Invicttus on 21/05/2025.
//

import SwiftUI

struct BorderedButtonStyle: ButtonStyle {
    var isFocused: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .background(isFocused ? Color(hex: "#005C79") : Color.white)
            .cornerRadius(40)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(isFocused ? Color(hex: "#005C79") : Color(hex: "#E3E3E4").opacity(0.7), lineWidth: 4)
            )
    }
    }

struct BorderedButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Button(action: {
                print("Tapped")
            }) {
                Image("premium")
                    .resizable()
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(BorderedButtonStyle(isFocused: true))
        }
    }
}

