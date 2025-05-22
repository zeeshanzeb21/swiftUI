//
//  CustomTextField.swift
//  swiftUI
//
//  Created by Invicttus on 21/05/2025.
//

import SwiftUI

struct StyledTextField: View {
    @State private var text: String = ""
    var isFocused: Bool = false

    var body: some View {
        TextField("Search Here", text: $text)
            .padding(.horizontal, 24)
            .frame(width: 950, height: 80)
            .background(isFocused ? Color(hex: "#005C79") : Color.white)
            .cornerRadius(40)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(isFocused ? Color(hex: "#005C79") : Color(hex: "#E3E3E4").opacity(0.7), lineWidth: 4)
            )
            .font(.system(size: 20))
            .foregroundColor(isFocused ? .white : .black)
    }
}

struct StyledTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            StyledTextField(isFocused: true)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
