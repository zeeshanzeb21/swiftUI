//
//  WebScreen.swift
//  swiftUI
//
//  Created by Invicttus on 23/05/2025.
//

import SwiftUI

struct WebScreen: View {
    @FocusState private var focusedButton: FocusableButton?
    @State private var searchText: String = ""
    @State private var placeholderText: String = "Search Here..."
    @State private var focusedIndex: Int? = nil
    @FocusState private var focusedField: FocusField?
    enum FocusField: Hashable {
        case item(Int)
    }
    
    enum FocusableButton {
        case left,right,search,premium, settings,images,web, videos, news, shopping, list
    }
    
    func isFocusedLeft() -> Bool {
        focusedButton == .left
    }
    func isFocusedRight() -> Bool {
        focusedButton == .right
    }
    func isFocusedSearch() -> Bool {
        focusedButton == .search
    }
    
    func isFocusedPremium() -> Bool {
        focusedButton == .premium
    }
    func isFocusedSetting() -> Bool {
        focusedButton == .settings
    }
    func isFocusedWeb() -> Bool {
        focusedButton == .web
    }
    func isFocusedImages() -> Bool {
        focusedButton == .images
    }
    func isFocusedVideos() -> Bool {
        focusedButton == .videos
    }
    func isFocusedNews() -> Bool {
        focusedButton == .news
    }
    func isFocusedShopping() -> Bool {
        focusedButton == .shopping
    }
    func isFocusedList() -> Bool {
        focusedButton == .list
    }
    
    @State private var selectedArticleID: UUID?
        
        let articles: [Article] = [
            Article(sourceLogo: "bbc_logo", sourceName: "BBC",
                    url: "https://www.bbc.com/travel/article/20250115-the-25-best-places-to-travel-in-2025",
                    title: "The 25 best places to travel in 2025",
                    description: "The 25 best places to travel in 2025 · 1. Dominica · 2. Naoshima, Japan · 3. The Dolomites, Italy · 4. Greenland · 5. Wales · 6. Western Newfoundland ..."),
            Article(sourceLogo: "bbc_logo", sourceName: "BBC",
                    url: "https://www.bbc.com/travel/article/20250115-the-25-best-places-to-travel-in-2025",
                    title: "The 25 best places to travel in 2025",
                    description: "Lonely Planet's Best in Travel celebrates 30 incredible destinations for 2025. Discover the top countries, regions and cities around the world, chosen by our ...")
            ]
    
    var body: some View {
        ZStack {
            Image("bgImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Button(action: {
                        print("Settings tapped")
                    }) {
                        Image(isFocusedLeft() ? "left_focus" : "left_unfocus")
                            .resizable()
                            .frame(width: isFocusedLeft() ? 17 : 12, height: isFocusedLeft() ? 29 : 19)
                            .padding(8)
                    }
                    .focused($focusedButton, equals: .left)
                    .buttonStyle(PremiumButton(
                        isFocused: isFocusedLeft(),
                        width: isFocusedLeft() ? 60 : 45,
                        height: isFocusedLeft() ? 60 : 45,
                        cornerRadius: isFocusedLeft() ? 30 : 23
                    ))

                    Button(action: {
                        print("Settings tapped")
                    }) {
                        Image(isFocusedRight() ? "right_focus" : "right_unfocus")
                            .resizable()
                            .frame(width: isFocusedRight() ? 17 : 12, height: isFocusedRight() ? 29 : 19)
                            .padding(8)
                    }
                    .focused($focusedButton, equals: .right)
                    .buttonStyle(PremiumButton(
                        isFocused: isFocusedRight(),
                        width: isFocusedRight() ? 60 : 45,
                        height: isFocusedRight() ? 60 : 45,
                        cornerRadius: isFocusedRight() ? 30 : 23
                    ))
                    .padding(.leading, 13)
                    HStack(alignment: .top) {
                        // Search bar
                        ZStack {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.white)
                                .frame(width: 1050, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(
                                            isFocusedSearch() ? Color(hex: "#005C79") : Color(hex: "#E3E3E4"),
                                            lineWidth: 4
                                        )
                                )

                            HStack(spacing: 0) {
                                if searchText.isEmpty {
                                    Text(placeholderText)
                                        .foregroundColor(Color(hex: "#6A6767"))
                                        .font(.system(size: 35, weight: .regular))
                                        .padding(.top, 6)
                                        .padding(.leading, 10)
                                }

                                if focusedButton != .search {
                                    Text(searchText)
                                        .foregroundColor(Color(hex: "#6A6767"))
                                        .font(.system(size: 35, weight: .regular))
                                        .padding(.top, 6)
                                        .padding(.leading, 10)
                                }

                                TextField("Search Here...", text: $searchText)
                                    .font(.system(size: 35, weight: .regular))
                                    .foregroundColor(Color(hex: "#6A6767"))
                                    .padding(.top, 6)
                                    .padding(.leading, 10)
                                    .background(Color.clear)
                                    .textFieldStyle(.plain)
                                    .focused($focusedButton, equals: .search)
                                    .onChange(of: focusedButton) { oldValue, newValue in
                                        placeholderText = newValue == .search ? "" : "Search Here..."
                                    }
                            }
                            .frame(width: 1000, height: 80)
                        }

                        HStack{
                            Spacer()
                            HStack(spacing: 16) {
                                Button(action: {
                                    print("Tapped")
                                }) {
                                    HStack(spacing: 8) {
                                        Image("premium")
                                            .resizable()
                                            .frame(width: 48, height: 48)
                                            .padding(8)
                                        Text("Premium")
                                            .font(.system( size: 31,weight: .bold, design: .default))
                                            .foregroundColor(isFocusedPremium() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                    }
                                }
                                .focused($focusedButton, equals: .premium)
                                .buttonStyle(PremiumButton(isFocused: isFocusedPremium(),width: 260,height: 80, cornerRadius: 53))
                                Button(action: {
                                    print("Settings tapped")
                                }) {
                                    Image(isFocusedSetting() ? "setting_focus" : "setting")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .padding(8)
                                }
                                .focused($focusedButton, equals: .settings)
                                .buttonStyle(BorderedButtonStyle(isFocused: isFocusedSetting()))
                            }
                            .padding(.trailing, 0)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    
                    .padding(.leading, 77)
                }.focusSection()
                .padding(.leading, 0)
                .padding(.top, 10)
                
                HStack(spacing: 20) {
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                            Image(isFocusedWeb() ?"web_focus": "web")
                                .resizable()
                                .frame(width: 26, height: 26)
                                .padding(4)
                            Text("Web")
                                .font(.system(size: 28,weight: .medium,design: .default))
                                .foregroundColor(isFocusedWeb() ? .white : Color(hex: "#005C79")).padding(4)
                        }
                    }
                    .focused($focusedButton, equals: .web)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedWeb(),height: 60, width: 188,cornerRadius: 30))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                            Image(isFocusedImages() ? "images_focus": "images")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(4)
                            Text("Images")
                                .font(.system(size: 28,weight: .medium,design: .default))
                                .foregroundColor(isFocusedImages() ? .white : Color(hex: "#005C79")).padding(4)
                        }
                    }
                    .focused($focusedButton, equals: .images)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedImages(),height: 60, width: 226,cornerRadius: 30))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                            Image(isFocusedVideos() ? "video_focus"
                            :"video")
                                .resizable()
                                .frame(width: 33, height: 24)
                                .padding(4)
                            Text("Videos")
                                .font(.system(size: 28,weight: .medium,design: .default))
                                .foregroundColor(isFocusedVideos() ? .white : Color(hex: "#005C79")).padding(4)
                        }
                    }
                    .focused($focusedButton, equals: .videos)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedVideos(),height: 60, width: 200,cornerRadius: 30))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                            Image(isFocusedNews() ? "news_focus" :"news")
                                .resizable()
                                .frame(width: 28, height: 24)
                                .padding(4)
                            Text("News")
                                .font(.system(size: 28,weight: .medium,design: .default))
                                .foregroundColor(isFocusedNews() ? .white : Color(hex: "#005C79")).padding(4)
                        }
                    }
                    .focused($focusedButton, equals: .news)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedNews(),height: 60, width: 200,cornerRadius: 30))
                    Button(action: {
                        print("Tapped")
                        
                    }) {
                        HStack(spacing: 8) {
                            Image(isFocusedShopping() ? "shopping_focus" :"shopping")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(4)
                            Text("Shopping")
                                .font(.system(size: 28,weight: .medium,design: .default))
                                .foregroundColor(isFocusedShopping() ? .white : Color(hex: "#005C79")).padding(4)
                        }
                    }
                    .focused($focusedButton, equals: .shopping)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedShopping(),height: 60, width: 255,cornerRadius: 30))
                }.padding(.top, 4)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .focusSection()
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                            Button(action: {
                                // Handle selection
                                print("Selected article at index \(index)")
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image("bbc")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                            .padding(.top, 32)
                                            .padding(.leading, 30)

                                        VStack(alignment: .leading, spacing: 0) {
                                            Text("BBC")
                                                .font(.system(size: 24, weight: .medium))
                                                .foregroundColor(Color(hex: "#3C3B3B"))
                                                .padding(.top, 30)

                                            Text(article.url)
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(hex: "#3C3B3B"))
                                        }
                                    }

                                    Text(article.title)
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundColor(Color(hex: "#00759B"))
                                        .padding(.leading, 30)

                                    Text(article.description)
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(hex: "#3C3B3B"))
                                        .padding(.leading, 30)
                                        .lineLimit(2)
                                }
                            }
                            .buttonStyle(ListButtonStyle(isFocused: focusedIndex == index))
                            .focused($focusedField, equals: .item(index))
                            .onChange(of: focusedField) { oldValue, newValue in
                                if case .item(let idx) = newValue {
                                    focusedIndex = idx
                                }
                            }
                        }
                    }
                }

                
                
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }

}


#Preview {
    WebScreen()
}

struct Article: Identifiable {
    let id = UUID()
    let sourceLogo: String
    let sourceName: String
    let url: String
    let title: String
    let description: String
}
