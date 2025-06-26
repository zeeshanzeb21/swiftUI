//
//  ListButtonStyle.swift
//  swiftUI
//
//  Created by Invicttus on 30/05/2025.
//


//
//  ListButtons.swift
//  swiftUI
//
//  Created by Invicttus on 23/05/2025.
//

import SwiftUI
struct InnerLinkList: ButtonStyle {
    var isFocused: Bool
    var height: CGFloat
    var width: CGFloat
    var selectedColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Color(hex: "#DDDDDD").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                ZStack(alignment: .leading) {
                    (isFocused ? selectedColor : Color.white)
                    
                    configuration.label
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.vertical, 10)
                        .foregroundColor(isFocused ? .white : .black)
                }
                .frame(height: height)
                Spacer()
            }
        }
        .frame(width: width, height: height + 7)
        .padding(.leading, 2)
    }
}

struct InnerLinkList_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
            print("Tapped")
        }) {
            Text("Search")
                .font(.system(size: 15, weight: .regular))
        }
        .buttonStyle(InnerLinkList(
            isFocused: true,
            height: 55,
            width: 300,
            selectedColor: Color(hex: "#005C79")
        ))
    }
}
