//
//  BorderedMainButtonStyle.swift
//  swiftUI
//
//  Created by Invicttus on 02/06/2025.
//


//
//  CustomButton.swift
//  swiftUI
//
//  Created by Invicttus on 21/05/2025.
//

import SwiftUI

struct FeedbackButtonStyle: ButtonStyle {
    var isFocused: Bool
    var height: CGFloat
    var width: CGFloat
    var cornerRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .background(isFocused ? Color.white: Color.white)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isFocused ? Color(hex: "#005C79") : Color(hex: "#E3E3E4").opacity(0.7), lineWidth: 4)
            )
    }
    }

struct FeedbackButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Button(action: {
                print("Tapped")
            }) {
                Image("image")
                    .resizable()
                    .frame(width: 51, height: 51)
            }
            .buttonStyle(BorderedButtonStyle(isFocused: true))
        }
    }
}

