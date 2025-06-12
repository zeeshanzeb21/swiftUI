//
//  WebScreen.swift
//  swiftUI
//
//  Created by Invicttus on 23/05/2025.
//

import SwiftUI
struct WebScreen: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedButton: FocusableButton?
    @State  var searchText: String
    @State private var placeholderText: String = "Search Here..."
    @State private var focusedIndex: Int? = nil
    @FocusState private var focusedField: FocusField?
    @State private var start: Int = 0
    @State private var limit: Int = 10
    @State private var searchType : String = "general"
    @State private var selectedURL: String?
    @State private var isNavigated = false
    @State private var link: String = ""
    @State private var showSettingsPopup = false

    
    
    enum FocusField: Hashable {
        case item(Int)
    }
    enum FocusableButton: Hashable {
        case left,right,search,premium, settings,images,web, videos, news, shopping, list, loadMore, loadless
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
    func isFocusedLoadMore() -> Bool {
        focusedButton == .loadMore
    }
    func isFocusedLoadless() -> Bool {
        focusedButton == .loadless
    }
    
    @ObservedObject var viewModel = WebViewModel()
    private var articleButtons: [(Int, DataModel)] {
        Array(viewModel.searchData.enumerated())
    }
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    @Binding var navigationPath: [Route]

    let viewID: UUID

    
    var body: some View {
            ZStack {
                Image("bgImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if viewModel.showLoading == true{
                    ZStack {
                        Text("Please wait! we are fetching results")
                            .font(Font.custom("Saira-Bold", size: 35))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .padding(.top, 6)
                            .padding(.leading, 10)
                    }
                }
                
                
                
                if searchType == "videos" || searchType == "news" || searchType == "shopping" {
                    ZStack {
                        Text("Coming Soon !!!")
                            .font(Font.custom("Saira-Bold", size: 70))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .padding(.top, 6)
                            .padding(.leading, 10)
                    }
                    
                }
                
                
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Button(action: {
                            print("Settings tapped")
                            dismiss()
                            
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
                            //                            ZStack {
                            //                                RoundedRectangle(cornerRadius: 40)
                            //                                    .fill(Color.white)
                            //                                    .frame(width: 1050, height: 80)
                            //                                    .overlay(
                            //                                        RoundedRectangle(cornerRadius: 40)
                            //                                            .stroke(
                            //                                                isFocusedSearch() ? Color(hex: "#005C79") : Color(hex: "#E3E3E4"),
                            //                                                lineWidth: 4
                            //                                            )
                            //                                    )
                            //
                            //                                HStack(spacing: 0) {
                            //                                    if focusedButton != .search {
                            //                                        Text(searchText)
                            //                                            .foregroundColor(Color(hex: "#6A6767"))
                            //                                            .font(.system(size: 30, weight: .regular))
                            //                                            .padding(.leading, 10)
                            //                                    }
                            //
                            //                                    TextField("Search Here...", text: $searchText)
                            //                                        .font(.system(size: 30, weight: .regular))
                            //                                        .foregroundColor(Color(hex: "#6A6767"))
                            //                                        .padding(.leading, 10)
                            //                                        .background(Color.clear)
                            //                                        .textFieldStyle(.plain)
                            //                                        .focused($focusedButton, equals: .search)
                            //                                        .onChange(of: focusedButton) { oldValue, newValue in
                            //                                            placeholderText = newValue == .search ? "" : "Search Here..."
                            //                                        }
                            //                                }
                            //                                .frame(width: 1000, height: 80)
                            //                            }
                            
                            Button(action: {
                                focusedButton = .search
                            }) {
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
                                    
                                    Text(searchText.isEmpty ? "Search Here..." : searchText)
                                        .foregroundColor(Color(hex: "#6A6767"))
                                        .font(.system(size: 30, weight: .regular))
                                        .frame(width: 1000, alignment: .leading)
                                    
                                }
                            }
                            .buttonStyle(WebDetailStyle()) // Remove default button visuals
                            .focused($focusedButton, equals: .search)
                            
                            
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
                                        showSettingsPopup = true
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
                            searchType =  "general"
                            start = 0
                            limit = 10
                            viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
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
                            searchType =  "isch"
                            start = 0
                            limit = 10
                            viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
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
                            searchType = "videos"
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
                            searchType = "news"
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
                            searchType = "shopping"
                            
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
                    if(searchType == "general" || searchType == "isch"){
                        ScrollView {
                            VStack(spacing: 20) {
                                if(searchType == "general" && viewModel.showLoading == false)
                                {
                                    ForEach(articleButtons, id: \.0) { index, article in
                                        articleButtonView(index: index, article: article) {
                                            navigationPath.append(.webDetail(searchText: searchText, hrefLink: link))

                                        }
                                    }
                                    
                                    
                                }
                                
                                else if(searchType == "isch" && viewModel.showLoading == false)
                                {
                                    
                                    HStack {
                                        Text("Search Results")
                                            .foregroundColor(Color(hex: "#5F6368"))
                                            .font(.system(size: 28, weight: .regular))
                                        Spacer()
                                    }
                                    .padding(.leading, 26)
                                    .frame(maxWidth: .infinity)
                                    
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(articleButtons, id: \.0) { index, article in
                                            articleImageView(index: index, article: article)
                                            {
                                                navigationPath.append(.webDetail(searchText: searchText, hrefLink: link))
                                            }
                                                .frame(width: 430, height: 460)
                                                .background(Color.white)
                                                .cornerRadius(20)
                                        }
                                    }
                                    .padding()
                                }
                                HStack{
                                    if !viewModel.searchData.isEmpty && start != 0 && viewModel.showLoading == false {
                                        Button(action: {
                                            start = start - 10
                                            limit = limit - 10
                                            viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                                            print("start")
                                            print(start)
                                            print(limit)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                focusedField = .item(0)
                                            }
                                            
                                            
                                        }) {
                                            HStack(spacing: 8) {
                                                Text("Previous Page")
                                                    .font(.system( size: 31,weight: .bold, design: .default))
                                                    .foregroundColor(isFocusedLoadless() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                            }
                                        }
                                        .focused($focusedButton, equals: .loadless)
                                        .buttonStyle(PremiumButton(isFocused: isFocusedLoadless(),width: 240,height: 60, cornerRadius: 20)).padding(.bottom, 10)
                                    }
                                    if (viewModel.showLoading == false && limit <= viewModel.totalPages) {
                                        Button(action: {
                                            start = limit
                                            limit = limit + 10
                                            viewModel.getData(query:  searchText, searchType: searchType, start: start, limit: limit)
                                            print(start)
                                            print(limit)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                focusedField = .item(0)
                                            }
                                        }) {
                                            HStack(spacing: 8) {
                                                Text("Next Page")
                                                    .font(.system( size: 31,weight: .bold, design: .default))
                                                    .foregroundColor(isFocusedLoadMore() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                            }
                                        }
                                        .focused($focusedButton, equals: .loadMore)
                                        .buttonStyle(PremiumButton(isFocused: isFocusedLoadMore(),width: 240,height: 60, cornerRadius: 20)).padding(.bottom, 10)
                                    }
                                }
                                
                            }
                        }
                    }
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if showSettingsPopup {
                    SettingsPopupView(
                        onClose: {
                            showSettingsPopup = false
                        },
                        navigationPath: $navigationPath
                    )
                    .onDisappear {
                        focusedButton = .settings
                    }
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(100)
                }
                
            }.task(id: viewID) {
                focusedButton = .web
                viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.chatListLoadingError)
            }
            
        
    }
     
    func base64ToImage(base64String: String) -> UIImage? {
        let cleanedString: String
        if let range = base64String.range(of: "base64,") {
            cleanedString = String(base64String[range.upperBound...])
        } else {
            cleanedString = base64String
        }
        guard let imageData = Data(base64Encoded: cleanedString, options: .ignoreUnknownCharacters),
              let image = UIImage(data: imageData) else {
            return nil
        }
        
        return image
    }
    
    @ViewBuilder
    private func articleButtonView(index: Int, article: DataModel,onTap: @escaping () -> Void) -> some View {
        Button(action: {
            print("Selected article at index \(index)")
            link = article.links ?? ""
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 12) {
                    if let image = base64ToImage(base64String: article.image ?? "bbc") {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 62, height: 62)
                            .cornerRadius(32)
                            .padding(.top, 20)
                            .padding(.leading, 26)
                    } else {
                        Color.red
                            .frame(width: 62, height: 62)
                            .cornerRadius(8)
                            .padding(.top, 32)
                            .padding(.leading, 30)
                            .overlay(Text("Failed").foregroundColor(.white).font(.caption))
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(article.title ?? "")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .padding(.top, 26)
                        
                        Text(article.links ?? "")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                    }
                }
                
                Text(article.heading ?? "")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color(hex: "#00759B"))
                    .padding(.leading, 30)
                    .padding(.top, 4)
                
                
                Text(article.description ?? "")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#3C3B3B"))
                    .padding(.leading, 30)
                    .lineLimit(2)
            }
        }
        .buttonStyle(ListButtonStyle(isFocused: focusedIndex == index, height: 204, width: 1669,selectedColor: Color(hex: "#005C79")))
        .focused($focusedField, equals: .item(index))
        .onChange(of: focusedField) { _, newValue in
            if case .item(let idx) = newValue {
                focusedIndex = idx
            }
        }
    }
    @ViewBuilder
    private func articleImageView(index: Int, article: DataModel,onTap: @escaping () -> Void) -> some View {
        Button(action: {
            print("Selected article at index \(article)")
            link = article.link ?? ""
            onTap()
        }) {
            VStack{
                if let image = base64ToImage(base64String: article.image ?? "") {
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: 300)
                        .clipped()
                        .cornerRadius(16)
                        .padding(.leading, 24)
                        .padding(.trailing, 24)
                        .padding(.bottom, 2)
                        .padding(.top, 20)
                } else {
                    Image("bbc")
                        .resizable()
                        .frame(height: 300)
                        .clipped()
                        .cornerRadius(16)
                        .padding(.leading, 24)
                        .padding(.trailing, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 2)

                }
                HStack(alignment: .top, spacing: 0) {
                    if let image = base64ToImage(base64String: article.sourceLogo ?? "bbc") {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
                    Text(article.source ?? "")
                        .font(Font.custom("Raleway-Regular", size: 18).weight(.regular))
                        .foregroundColor(Color(hex: "#3C3B3B"))
                        .padding(.leading, 4)
                    Spacer()
                }
                .padding(.leading, 26)
                .padding(.top, 0)
                HStack(alignment: .top, spacing: 0) {
                    Text(article.title ?? "")
                        .font(Font.custom("Raleway-Regular", size: 24).weight(.regular))
                        .foregroundColor(Color(hex: "#3C3B3B"))
                        .padding(.leading, 4)
                    Spacer()
                }
                .padding(.leading, 26)
                .padding(.top, 0)
                Spacer()
            }
        }
        .buttonStyle(ListButtonStyle(isFocused: focusedIndex == index, height: 460, width: 430,selectedColor: Color(hex: "#00759B")))
        .focused($focusedField, equals: .item(index))
        .onChange(of: focusedField) { _, newValue in
            if case .item(let idx) = newValue {
                focusedIndex = idx
            }
        }
    }

    
    
}

