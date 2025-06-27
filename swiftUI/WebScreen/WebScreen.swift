//
//  WebScreen.swift
//  swiftUI
//
//  Created by Invicttus on 23/05/2025.
//

import FirebaseAnalytics
import SwiftUI
@MainActor
struct WebScreen: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedButton: FocusableButton?
    @State  var searchText: String
    @State private var placeholderText: String = "Search Here..."
    @State private var focusedIndex: Int? = nil
    @FocusState private var focusedField: FocusField?
    @State private var start: Int = 0
    @State private var limit: Int = 12
    @State var searchType : String
    @State private var selectedURL: String?
    @State private var isNavigated = false
    @State private var link: String = ""
    @State private var showSettingsPopup = false
    @State  var navigeteRight: Bool = true
    enum FocusField: Hashable {
        case item(Int)
    }
    enum FocusableButton: Hashable {
        case left,right,search,premium, settings,images,web, videos, news, shopping, list, loadMore, loadless, back, tryAgain, searchBtnClicked
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
        return focusedButton == .web || (searchType == "general" && isArticleItemFocused())
    }

    func isFocusedImages() -> Bool {
        return focusedButton == .images || (searchType == "isch" && isArticleItemFocused())
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
    
    
    func isFocusedBack() -> Bool {
        focusedButton == .back
    }
    
    func isFocusedSearchBtnClicked() -> Bool {
        focusedButton == .searchBtnClicked
    }
    
    func isFocusedTryAgain() -> Bool {
        focusedButton == .tryAgain
    }
    
    func isArticleItemFocused() -> Bool {
        if case .item(_) = focusedField {
            return true
        }
        return false
    }
    
    @StateObject var viewModel = WebViewModel()
    private var articleButtons: [(Int, DataModel)] {
        Array(viewModel.searchData.enumerated())
    }
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    @Binding var navigationPath: [Route]

    @State private var viewID = UUID()

    
    @StateObject private var networkMonitor = NetworkMonitor()

    
    @State private var showError: Bool = false

    @State private var previousSearchText: String = ""


    
    var body: some View {
            ZStack {
                Image("bgImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
            
                if viewModel.showLoading {
                    LoadingView(screenShots: false)
                }
                
                
                if (viewModel.showLoading == false && viewModel.searchData.isEmpty)
                {
                    ZStack {
                        Color.clear.ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            Image("no_result_found")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 736, height: 409)
                            Spacer()
                        }
                    }
                    
                }
                
                if(networkMonitor.isConnected == false)
                {
                    
                        ZStack {
                            Color.clear.ignoresSafeArea()
                            
                            VStack {
                                Spacer()
                                Image("no_internet")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 736, height: 409)
                                
                                HStack(spacing: 40) {
                                
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Text("Back")
                                            .font(.system(size: 31, weight: .bold, design: .default))
                                            .foregroundColor(isFocusedBack() ? .white : Color(hex: "#D6D6D6"))
                                            .padding(8)
                                    }
                                    .focused($focusedButton, equals: .back)
                                    .buttonStyle(PremiumButton(
                                        isFocused: isFocusedBack(),
                                        width: 320,
                                        height: 80,
                                        cornerRadius: 40
                                    ))
                                    .padding(.bottom, 10)

                                    // Next Page Button
                                    Button(action: {
                                        if networkMonitor.isConnected {
                                            if(searchType == "general")
                                            {
                                                focusedButton = .web
                                                viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                                                
                                            }
                                            else if(searchType == "isch"){
                                                focusedButton = .images
                                                viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                                            }
                                            
                                        }
                                    }) {
                                        Text("Try Again")
                                            .font(.system(size: 31, weight: .bold, design: .default))
                                            .foregroundColor(isFocusedTryAgain() ? .white : Color(hex: "#D6D6D6"))
                                            .padding(8)
                                    }
                                    .focused($focusedButton, equals: .tryAgain)
                                    .buttonStyle(PremiumButton(
                                        isFocused: isFocusedTryAgain(),
                                        width: 320,
                                        height: 80,
                                        cornerRadius: 40
                                    ))
                                    .padding(.bottom, 10)
                                    
                                }.padding(.top, 60)
                                    .frame(maxWidth: .infinity)
                                    .focusSection()

                                
                                Spacer()
                            }
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
                      
                        HStack(spacing: 0) {
                            
                            // LEFT BUTTON IN FIXED CONTAINER
                            ZStack {
                                Color.clear
                                    .frame(width: 60, height: 60) // Fixed container
                                
                                Button(action: {
                                    dismiss()
                                }) {
                                    Image(isFocusedLeft() ? "left_focus" : "left_unfocus")
                                        .resizable()
                                        .frame(width: isFocusedLeft() ? 17 : 12,
                                               height: isFocusedLeft() ? 29 : 19)
                                }
                                .focused($focusedButton, equals: .left)
                                .buttonStyle(PremiumButton(
                                    isFocused: isFocusedLeft(),
                                    width: isFocusedLeft() ? 60 : 45,
                                    height: isFocusedLeft() ? 60 : 45,
                                    cornerRadius: isFocusedLeft() ? 30 : 23
                                ))
                            }
                            
                            ZStack {
                                Color.clear
                                    .frame(width: 60, height: 60)
                                
                                Button(action: {
                                    let link = UserDefaults.standard.string(forKey: "links")
                                    let search = UserDefaults.standard.string(forKey: "search")
                                    if(link != nil)
                                    {
                                        navigationPath.append(.webDetail(searchText: search ?? "", hrefLink: link ?? ""))
                                    }
                                }) {
                                    Image(isFocusedRight() ? "right_focus" : "right_unfocus")
                                        .resizable()
                                        .frame(width: isFocusedRight() ? 17 : 12,
                                               height: isFocusedRight() ? 29 : 19)
                                }
                                .focused($focusedButton, equals: .right)
                                .buttonStyle(PremiumButton(
                                    isFocused: isFocusedRight(),
                                    width: isFocusedRight() ? 60 : 45,
                                    height: isFocusedRight() ? 60 : 45,
                                    cornerRadius: isFocusedRight() ? 30 : 23
                                ))
                            }
                            
                                ZStack {
                                    
                                    Image(showError ? "search_error" : (isFocusedSearch() ? "search_focus": "search_simple"))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 950, height: 80)
                                            .clipped()
                                    
                                    HStack(spacing: 0) {
                                        
                                        
                                       
                                        TextField("Search Here...", text: $searchText)
                                            .foregroundColor(Color(hex: "#6A6767"))
                                            .font(.system(size: 30, weight: .regular))
                                            .padding(.trailing, 20)
                                            .padding(.leading, 70)
                                            .padding(.top, 10)
                                            .background(Color.clear)
                                            .textFieldStyle(.plain)
                                            .focused($focusedButton, equals: .search)
                                            .onSubmit {
                                                
                                                let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                                   
                                                   if !trimmedText.isEmpty {
                                                      
                                                       previousSearchText = searchText
                                                       
                                                       if searchType == "general" {
                                                           focusedButton = .web
                                                           viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                                                       } else if searchType == "isch" {
                                                           focusedButton = .images
                                                           viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                                                       }

                                                       viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                                                   } else {
                                                       
                                                       searchText = previousSearchText
                                                   }
                                                
                                                
                                                
                                                
                                                
                                                }
                                        
                                            .onChange(of: focusedButton) { oldValue, newValue in
                                                if newValue == .search {
                                                    placeholderText = ""
                                                    showError = false
                                                } else if oldValue == .search {
                                                    placeholderText = "Search Here..."

                                                    let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                                    if trimmedText.isEmpty {
                                                        
                                                        searchText = previousSearchText
                                                    } else {
                                                        
                                                        previousSearchText = searchText
                                                    }
                                                }
                                            }

                                    }
                                    
                                    
                                    .frame(width: 900, height: 80)
                               

                                    
                                    
                                    
                                }
                                .padding(.leading, 20)
                            .buttonStyle(WebDetailStyle())
                            .focused($focusedButton, equals: .search)
                            
                        }
                        
                        
                        HStack(alignment: .top) {
                            
                            
            
                            
//                            HStack(alignment: .top, spacing: 0) {
//                                Button(action: {
//                                    print("Tapped")
//                                }) {
//                                    HStack(spacing: 0) {
//                                        Image(isFocusedSearchBtnClicked() ? "search_btn_focus" : "search_btn_unfocus")
//                                            .resizable()
//                                            .frame(width: 86, height: 86)
//                                    }
//                                }
//                                .focused($focusedButton, equals: .searchBtnClicked)
//                                .buttonStyle(WebDetailStyle())
//                            }
                            
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
                                        Analytics.logEvent("setting__btn_pressed", parameters: [
                                            "query": "Setting btn pressed from Home screen"
                                        ])
                                        if(searchType == "general")
                                        {
                                            Analytics.logEvent("setting_web_btn_pressed", parameters: [
                                                "query": "Setting btn pressed from web screen"
                                            ])
                                            
                                        }
                                        else if(searchType == "isch"){
                                            Analytics.logEvent("setting_image_btn_pressed", parameters: [
                                                "query": "Setting btn pressed from web_image screen"
                                            ])
                                        }
                                        else if(searchType == "videos"){
                                            Analytics.logEvent("setting_videos_btn_pressed", parameters: [
                                                "query": "Setting btn pressed from web_videos screen"
                                            ])
                                        }
                                        else if(searchType == "news"){
                                            Analytics.logEvent("setting_news_btn_pressed", parameters: [
                                                "query": "Setting btn pressed from web_news screen"
                                            ])
                                        }
                                        else if(searchType == "shopping"){
                                            Analytics.logEvent("setting_shopping_btn_pressed", parameters: [
                                                "query": "Setting btn pressed from web_shopping screen"
                                            ])
                                        }
                                        
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
                    if(viewModel.searchData.isEmpty == false){
                        HStack(spacing: 20) {
                            Button(action: {
                                searchType =  "general"
                                Analytics.logEvent("search_web", parameters: [
                                    "query": "Search is requested from web"
                                ])
                                Analytics.logEvent("web_tab_btn_pressed", parameters: [
                                    "query": "Web Tab Button Pressed"
                                ])
                                Analytics.logEvent("web view", parameters: [
                                    "query": "Web screen viewed"
                                ])
                                
                                start = 0
                                limit = 12
                                viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                            }) {
                                HStack(spacing: 8) {
                                    Image(isFocusedWeb() ? "web_focus": "web")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .padding(4)
                                    Text("Web")
                                        .font(.system(size: 28,weight: .medium,design: .default))
                                        .foregroundColor(isFocusedWeb() ? .white : Color(hex: "#005C79"))
                                        .padding(4)
                                }
                            }.disabled(showSettingsPopup)
                                .focused($focusedButton, equals: .web)
                                .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedWeb(),height: 60, width: 188,cornerRadius: 30))
                            Button(action: {
                                Analytics.logEvent("search_image", parameters: [
                                    "query": "Search is requested from image"
                                ])
                                Analytics.logEvent("image_tab_btn_pressed", parameters: [
                                    "query": "Image Tab Button Pressed"
                                ])
                                Analytics.logEvent("image view", parameters: [
                                    "query": "image screen viewed"
                                ])
                                searchType =  "isch"
                                start = 0
                                limit = 12
                                viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                            }) {
                                HStack(spacing: 8) {
                                    Image(isFocusedImages()  ? "images_focus": "images")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(4)
                                    Text("Images")
                                        .font(.system(size: 28,weight: .medium,design: .default))
                                        .foregroundColor(isFocusedImages() ? .white : Color(hex: "#005C79")).padding(4)
                                }
                            }.disabled(showSettingsPopup)
                                .focused($focusedButton, equals: .images)
                                .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedImages(),height: 60, width: 226,cornerRadius: 30))
                            Button(action: {
                                searchType = "videos"
                                Analytics.logEvent("search_videos", parameters: [
                                    "query": "Search is requested from videos"
                                ])
                                Analytics.logEvent("video_tab_btn_pressed", parameters: [
                                    "query": "Video Tab Button Pressed"
                                ])
                                Analytics.logEvent("video view", parameters: [
                                    "query": "video screen viewed"
                                ])
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
                            }.disabled(showSettingsPopup)
                                .focused($focusedButton, equals: .videos)
                                .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedVideos(),height: 60, width: 200,cornerRadius: 30))
                            Button(action: {
                                searchType = "news"
                                Analytics.logEvent("search_news", parameters: [
                                    "query": "Search is requested from news"
                                ])
                                Analytics.logEvent("news_tab_btn_pressed", parameters: [
                                    "query": "News Tab Button Pressed"
                                ])
                                Analytics.logEvent("news view", parameters: [
                                    "query": "news screen viewed"
                                ])
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
                            }.disabled(showSettingsPopup)
                                .focused($focusedButton, equals: .news)
                                .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedNews(),height: 60, width: 200,cornerRadius: 30))
                            Button(action: {
                                searchType = "shopping"
                                Analytics.logEvent("search_shop", parameters: [
                                    "query": "Search is requested from shop"
                                ])
                                Analytics.logEvent("shop_tab_btn_pressed", parameters: [
                                    "query": "Shopping Tab Button Pressed"
                                ])
                                Analytics.logEvent("shopping view", parameters: [
                                    "query": "shopping screen viewed"
                                ])
                                
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
                            }.disabled(showSettingsPopup)
                                .focused($focusedButton, equals: .shopping)
                                .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedShopping(),height: 60, width: 255,cornerRadius: 30))
                        }.padding(.top, 4)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .focusSection()
                    }
                
                    if(searchType == "general" || searchType == "isch"){
                        ScrollView {
                            VStack(spacing: 20) {
                                if(searchType == "general" && viewModel.showLoading == false)
                                {
                                    ForEach(articleButtons, id: \.0) { index, article in
                                        articleButtonView(index: index, article: article) {
                                            UserDefaults.standard.set(article.links, forKey: "links")
                                            UserDefaults.standard.set(searchText, forKey: "search")
                                            navigationPath.append(.webDetail(searchText: searchText, hrefLink: link))
                                            Analytics.logEvent("web_result_open", parameters: [
                                                "message": "Search Result Web Link Open \(link)"
                                            ])

                                        }
                                    }
                                    
                                    
                                }
                                
                                else if(searchType == "isch" && viewModel.showLoading == false)
                                {
                                    
                                    HStack {
                                        if(viewModel.searchData.isEmpty == false)
                                        {
                                            Text("Search Results")
                                                .foregroundColor(Color(hex: "#5F6368"))
                                                .font(.system(size: 28, weight: .regular))
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 26)
                                    .frame(maxWidth: .infinity)
                                    
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(articleButtons, id: \.0) { index, article in
                                            articleImageView(index: index, article: article)
                                            {
                                                UserDefaults.standard.set(article.link, forKey: "links")
                                                UserDefaults.standard.set(searchText, forKey: "search")
                                                navigationPath.append(.webDetail(searchText: searchText, hrefLink: link))
                                                Analytics.logEvent("image_result_open", parameters: [
                                                    "message": "Search Result Image Link Open \(link)"
                                                ])

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
                                            start = start - 12
                                            limit = limit - 12
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
                                            limit = limit + 12
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
                        }.disabled(showSettingsPopup)
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
                
            }.disabled(viewModel.showLoading)
            .focusSection()
            .task(id: viewID) {

                
                if networkMonitor.isConnected {
                    
                    if(searchType == "general")
                    {
                        focusedButton = .web
                        viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)

                    }
                    else if(searchType == "isch"){
                        focusedButton = .images
                        viewModel.getData(query: searchText, searchType: searchType, start: start, limit: limit)
                    }
                    
                               
                           }
               
            }
        
//            .alert("Error", isPresented: $viewModel.showAlert) {
//                Button("OK", role: .cancel) {}
//            } message: {
//                Text(viewModel.chatListLoadingError)
//            }
            
        
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
                        ZStack {
                            Color.red
                                .frame(width: 62, height: 62)
                                .cornerRadius(8)

                            Text("Failed")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        .padding(.top, 32)
                        .padding(.leading, 30)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(article.title ?? "")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .padding(.top, 26)
                        
                        Text(article.links ?? "")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                            .padding(.top, 4)
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
            switch newValue {
            case .item(let idx) where idx == index:
                focusedIndex = idx
            default:
                // Focus is no longer on this index
                if focusedIndex == index {
                    focusedIndex = -1
                }
            }
        }
//        .onChange(of: focusedField) { _, newValue in
//            if case .item(let idx) = newValue {
//                focusedIndex = idx
//            }
//        }
    }
    @ViewBuilder
    private func articleImageView(index: Int, article: DataModel,onTap: @escaping () -> Void) -> some View {
        Button(action: {
            print("Selected article at index \(article)")
            link = article.link ?? ""
            onTap()
        }) {
            VStack{
                if let imageString = article.image {
                    if imageString.starts(with: "http"),
                       let url = URL(string: imageString) {
                        
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(height: 300)
                                    .clipped()
                                    .cornerRadius(16)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 20)
                            case .failure(_):
                                EmptyView() // Or placeholder/fallback
                            default:
                                ProgressView()
                                    .frame(height: 300)
                            }
                        }

                    } else if let image = base64ToImage(base64String: imageString) {
                        
                        Image(uiImage: image)
                            .resizable()
                            .frame(height: 300)
                            .clipped()
                            .cornerRadius(16)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)

                    } else {
                        EmptyView() // Invalid image string
                    }
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
//        .onChange(of: focusedField) { _, newValue in
//            if case .item(let idx) = newValue {
//                focusedIndex = idx
//            }
//        }
        .onChange(of: focusedField) { _, newValue in
            switch newValue {
            case .item(let idx) where idx == index:
                focusedIndex = idx
            default:
                // Focus is no longer on this index
                if focusedIndex == index {
                    focusedIndex = -1
                }
            }
        }
    }


    
}

