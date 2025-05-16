//
//  MainScreen.swift
//  swiftUI
//
//  Created by Invicttus on 14/05/2025.
//

import SwiftUI
struct DetailScreen: View {
    let item: Int
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 30) {
            Text("Detail for Item \(item) no")
                .font(.largeTitle)

            Button("◀︎ Back") {
                dismiss()
            }
            .frame(width: 200, height: 60)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .buttonStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
