//
//  ToastModifier.swift
//  swiftUI
//
//  Created by Invicttus on 23/06/2025.
//


import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    
                    Text(message)
                        .font(Font.custom("Saira-Bold", size: 24))
                        .font(.system(size: 34,weight: .regular,design: .default))
                        .foregroundColor(Color(hex: "#6A6767")).padding(13)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 80)
                }
                .animation(.easeInOut(duration: 0.3), value: isPresented)
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}
