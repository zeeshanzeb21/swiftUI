//
//  ListButtons.swift
//  swiftUI
//
//  Created by Invicttus on 23/05/2025.
//

import SwiftUI

struct ListButtonStyle: ButtonStyle {
    var isFocused: Bool
    var height: CGFloat
    var width: CGFloat
    var selectedColor: Color
    func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
               .frame(width: width, height: height, alignment: .topLeading)
               .background(Color(hex: "#DDDDDD").opacity(0.1))
               .overlay(
                   RoundedRectangle(cornerRadius: 20)
                       .stroke(
                           isFocused ? selectedColor : Color(hex: "#E3E3E4").opacity(0.7),
                           lineWidth: 8
                       )
               )
               .cornerRadius(20)
               .padding(.horizontal, 16) // external spacing between cards
       }
}

struct ListButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
            // Your tap action
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 12) {
                    Image("bbc")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                        .padding(.top, 30)
                        .padding(.leading, 30)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("BBC")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .padding(.top, 30)
                        
                        Text("https://www.bbc.com/travel/article/20250115-the-25-best-places-to-travel-in-2025")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .lineLimit(1)
                        
                    }
                }
                
                Text("The 25 best places to travel in 2025")
                    .font(.system(size: 22,weight: .medium))
                    .foregroundColor(Color(hex: "#00759B"))
                    .lineLimit(1)
                    .padding(.leading, 30)
                
                
                Text("The 25 best places to travel in 2025 · 1. Dominica · 2. Naoshima, Japan · 3. The Dolomites, Italy · 4. Greenland · 5. Wales · 6. Western Newfoundland ...")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#3C3B3B"))
                    .lineLimit(1)
                    .padding(.leading, 30)
            }
            .frame(width: 1669, height: 204, alignment: .topLeading) // force top-left alignment
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
            )
        }
        .buttonStyle(ListButtonStyle(isFocused: false,height: 204, width: 1669, selectedColor: Color(hex: "#005C79")))
        .padding(0)
    }
}
   
struct ItemFramePreferenceKey: PreferenceKey {
    typealias Value = [Int: CGFloat]

    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
