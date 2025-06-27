//
//  BrowserHomeView.swift
//  swiftUI
//
//  Created by Invicttus on 16/05/2025.
//
import SwiftUI
import Firebase
import FirebaseAnalytics
import Network
struct BrowserHomeView: View {
    @FocusState private var focusedButton: FocusableButton?

    @State var searchText: String
    @FocusState private var isSearchFocused: Bool
    @State private var placeholderText: String = "Search Here..."
    @State private var showError: Bool = false
    
    

    enum FocusableButton: Hashable {
        case premium, settings, images , youtube , twich, wikipedia, pin, ebay, search, mic, clickSearch
    }
    func isFocusedPremium() -> Bool {
        focusedButton == .premium
    }
    func isFocusedSetting() -> Bool {
        focusedButton == .settings
    }
    
    func isFocusedImages() -> Bool {
        focusedButton == .images
    }
    func isFocusedYoutube() -> Bool {
        focusedButton == .youtube
    }
    func isFocusedTwich() -> Bool {
        focusedButton == .twich
    }
    
    func isFocusedWeki() -> Bool {
        focusedButton == .wikipedia
    }
    func isFocusedPin() -> Bool {
        focusedButton == .pin
    }
    func isFocusedEbay() -> Bool {
        focusedButton == .ebay
    }
    
    func isFocusedSearch() -> Bool {
        focusedButton == .search
    }
    
    func isFocusedMic() -> Bool {
        focusedButton == .mic
    }
    
    func isFocusedSearchClicked() -> Bool {
        focusedButton == .clickSearch
    }
        @State private var showSettingsPopup = false
    
    @State private var path: [Route] = []

    @StateObject private var networkMonitor = NetworkMonitor()
    
    @State private var viewID = UUID()
    
    @State private var isPlaceholderActive: Bool = true



    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("bgImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        HStack(spacing: 30) {
                            Image("energy")
                                .resizable()
                                .frame(width: 106, height: 92)
                            
                            Text("Fast Internet Browser")
                                .font(Font.custom("Saira-Bold", size: 70))
                                .foregroundColor(Color(hex: "#3C3B3B"))
                        }
                        HStack {
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
                                }.padding(.bottom, 30)
                                .focused($focusedButton, equals: .premium)
                                .buttonStyle(PremiumButton(isFocused: isFocusedPremium(),width: 260,height: 80, cornerRadius: 53))
                                Button(action: {
                                    print("Settings tapped")
                                    showSettingsPopup = true
                                    Analytics.logEvent("setting_home_btn_pressed", parameters: [
                                        "query": "Setting btn pressed from Home screen"
                                    ])
                                    
                                    
                                }) {
                                    Image(isFocusedSetting() ? "setting_focus" : "setting")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .padding(8)
                                }.padding(.bottom, 30)
                                .focused($focusedButton, equals: .settings)
                                .buttonStyle(BorderedButtonStyle(isFocused: isFocusedSetting()))
                            }
                            .padding(.trailing, 20)
                        }
                        
                    }
                    .focusSection()
                    .padding(.top, 57)
                    ZStack {
                        Image(showError ? "search_error" : (isFocusedSearch() ? "search_focus": "search_simple"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 950, height: 80)
                                .clipped()
                        
                        HStack(spacing: 0) {
                           
//                            if (searchText.isEmpty || focusedButton != .search) {
//                                Text(searchText.isEmpty ? placeholderText : searchText)
//                                    .foregroundColor(Color(hex: "#6A6767"))
//                                    .font(.system(size: 30, weight: .regular))
//                                    .padding(.leading, 70)
//                                    .lineLimit(1)
//                            }
//                            
                            
                            TextField("Search Here...", text: $searchText)
                                .foregroundColor(Color(hex: "#6A6767"))
                                .font(.system(size: 30, weight: .regular))
                                .padding(.leading, searchText.isEmpty ? 10 : 70)
                                .padding(.trailing, 20)
                                .padding(.trailing, 20)
                                .padding(.top, 10)
                                .textFieldStyle(.plain)
                                .background(Color.clear)
                                .focused($focusedButton, equals: .search)
                                .onChange(of: focusedButton) { oldValue, newValue in
                                    if newValue == .search {
                                        placeholderText = ""
                                        showError = false
                                        if(searchText == "")
                                        {
                                            searchText = "Search Here..."
                                            placeholderText = "Search Here..."
                                        }
                                    } else {
                                        placeholderText = "Search Here..."
                                        
                                        
                                    }
                                }
                                .onChange(of: searchText) { oldValue, newValue in
                                        if oldValue == "Search Here..." && newValue != oldValue {
                                            searchText = newValue.replacingOccurrences(of: "Search Here...", with: "")
                                        }
                                    }
                            
                        }
                        
                        
                        .frame(width: 900, height: 80)
                        HStack(alignment: .center) {
                            
                            Button(action: {
                             
                                
                                if(searchText.isEmpty == false && searchText != "Search Here...")
                                {
                                    
                                    Analytics.logEvent("search_manual", parameters: [
                                        "query": "Text search is requested \(searchText)"
                                    ])
                                    
                                    Analytics.logEvent("search_via_button", parameters: [
                                        "query": "User search through on screen search button \(searchText)"
                                    ])
                                    
                                    UserDefaults.standard.removeObject(forKey: "links")
                                    UserDefaults.standard.removeObject(forKey: "search")
                                    path.append(.web(searchText: searchText, searchType: "general", navigateRight: false))

                                }
                                else
                                {
                                    showError = true
                                }
                            }) {
                                Text("Search")
                                    .font(.system(size: 34, weight: .medium))
                                    .foregroundColor(isFocusedSearchClicked() ? .white : Color(hex: "#3C3B3B"))
                            }
                            .focused($focusedButton, equals: .clickSearch)
                            .buttonStyle(PremiumButton(isFocused: isFocusedSearchClicked(), width: 160,height: 80,cornerRadius: 53))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align HStack to the left
                        .padding(.trailing, 210)
                        
                    }
                    .padding(.top, 175)
                    .focusSection()
                    
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            print("Tapped")
                            if(searchText.isEmpty == false && searchText != "Search Here...")
                            {
                                Analytics.logEvent("search_direct_image", parameters: [
                                    "query": "Direct Search is requested via image \(searchText)"
                                ])
                                UserDefaults.standard.removeObject(forKey: "links")
                                UserDefaults.standard.removeObject(forKey: "search")
                                path.append(.web(searchText: searchText, searchType: "isch", navigateRight: false))

                            }
                            else
                            {
                                showError = true
                            }
                            
                            
                    
                        }) {
                            HStack(spacing: 8) {
                                Image("image")
                                    .resizable()
                                    .frame(width: 51, height: 51)
                                    .padding(8)
                                Text("Images")
                                    .font(.system(size: 42,weight: .regular,design: .default))
                                    .foregroundColor(isFocusedImages() ? .white : Color(hex: "#3C3B3B")).padding(8)
                            }
                        }
                        .focused($focusedButton, equals: .images)
                        .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedImages(),height: 105, width: 350,cornerRadius: 53))
                        Button(action: {
                            Analytics.logEvent("search_direct_youtube", parameters: [
                                "query": "Direct Search is requested via youtube \(searchText)"
                            ])
                            UserDefaults.standard.removeObject(forKey: "links")
                            UserDefaults.standard.removeObject(forKey: "search")
                        }) {
                
                            HStack(spacing: 8) {
                                Image("youtube")
                                    .resizable()
                                    .frame(width: 51, height: 51)
                                    .padding(8)
                                Text("Youtube")
                                    .font(.system(size: 42,weight: .regular,design: .default))
                                    .foregroundColor(isFocusedYoutube() ? .white : Color(hex: "#3C3B3B")).padding(8)
                            }
                        }
                        .focused($focusedButton, equals: .youtube)
                        .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedYoutube(),height: 105, width: 350,cornerRadius: 53))
                        Button(action: {
                            print("Tapped")
                            if(searchText.isEmpty == false && searchText != "Search Here...")
                            {
                                
                                let twitchUrl = "https://www.twitch.tv/search?term="
                                Analytics.logEvent("search_direct_twitch", parameters: [
                                    "query": "Direct Search is requested via twitch \(twitchUrl + searchText)"
                                ])
                                UserDefaults.standard.removeObject(forKey: "links")
                                UserDefaults.standard.removeObject(forKey: "search")
                                path.append(.webDetail(searchText: searchText, hrefLink: twitchUrl + searchText))
                            }
                            else
                            {
                                showError = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image("twich")
                                    .resizable()
                                    .frame(width: 51, height: 51)
                                    .padding(8)
                                Text("Twitch")
                                    .font(.system(size: 42,weight: .regular,design: .default))
                                    .foregroundColor(isFocusedTwich() ? .white : Color(hex: "#3C3B3B")).padding(8)
                            }
                        }
                        .focused($focusedButton, equals: .twich)
                        .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedTwich(),height: 105, width: 350,cornerRadius: 53))
                    }.padding(.top, 47)
                        .focusSection()
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            print("Tapped")
                            if(searchText.isEmpty == false && searchText != "Search Here...")
                            {
                                
                                let twitchUrl = "https://en.wikipedia.org/wiki/Special:Search?search="
                                Analytics.logEvent("search_direct_wikipedia", parameters: [
                                    "query": "Direct Search is requested via wikipedia \(twitchUrl + searchText)"
                                ])
                                UserDefaults.standard.removeObject(forKey: "links")
                                UserDefaults.standard.removeObject(forKey: "search")
                                path.append(.webDetail(searchText: searchText, hrefLink: twitchUrl + searchText))
                            }
                            else
                            {
                                showError = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image("wiki")
                                    .resizable()
                                    .frame(width: 51, height: 51)
                                    .padding(8)
                                Text("Wikipedia")
                                    .font(.system(size: 42,weight: .regular,design: .default))
                                    .foregroundColor(isFocusedWeki() ? .white : Color(hex: "#3C3B3B")).padding(8)
                            }
                        }
                        .focused($focusedButton, equals: .wikipedia)
                        .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedWeki(),height: 105, width: 350,cornerRadius: 53))
                        Button(action: {
                            print("Tapped")
                            if(searchText.isEmpty == false && searchText != "Search Here...")
                            {
                                
                                let twitchUrl = "https://www.ebay.com/sch/i.html?_n="
                                Analytics.logEvent("search_direct_ebay", parameters: [
                                    "query": "Direct Search is requested via ebay \(twitchUrl + searchText)"
                                ])
                                UserDefaults.standard.removeObject(forKey: "links")
                                UserDefaults.standard.removeObject(forKey: "search")
                                path.append(.webDetail(searchText: searchText, hrefLink: twitchUrl + searchText))
                            }
                            else
                            {
                                showError = true
                            }
                        }) {
                            HStack(spacing: 3) {
                                Image("ebay")
                                    .resizable()
                                    .frame(width: 60, height: 65)
                                    .padding(8)
                                Text("eBay")
                                    .font(.system(size: 42,weight: .regular,design: .default))
                                    .foregroundColor(isFocusedEbay() ? .white : Color(hex: "#3C3B3B")).padding(8)
                            }
                        }
                        .focused($focusedButton, equals: .ebay)
                        .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedEbay(),height: 105, width: 350,cornerRadius: 53))
                        Button(action: {
                            print("Tapped")
                            if(searchText.isEmpty == false && searchText != "Search Here...")
                            {
                                
                                let twitchUrl = "https://www.pinterest.com/search/pins/?q="
                                Analytics.logEvent("search_direct_pinterest", parameters: [
                                    "query": "Direct Search is requested via pinterest \(twitchUrl + searchText)"
                                ])
                                UserDefaults.standard.removeObject(forKey: "links")
                                UserDefaults.standard.removeObject(forKey: "search")
                                path.append(.webDetail(searchText: searchText, hrefLink: twitchUrl + searchText))
                            }
                            else
                            {
                                showError = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image("pin")
                                    .resizable()
                                    .frame(width: 51, height: 51)
                                    .padding(8)
                                Text("Pinterest")
                                    .font(.system(size: 42,weight: .regular,design: .default))
                                    .foregroundColor(isFocusedPin() ? .white : Color(hex: "#3C3B3B")).padding(8)
                            }
                        }
                        .focused($focusedButton, equals: .pin)
                        .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedPin(),height: 105, width: 350,cornerRadius: 53))
                    }.padding(.top, 10)
                        .focusSection()
                    Spacer()
                    if focusedButton == .youtube
                    {
                        Text("Coming Soon!!!")
                            .font(Font.custom("Saira-Bold", size: 35))
                            .foregroundColor(Color(hex: "#3C3B3B"))
                    }
                
                    
                }
                if showSettingsPopup {
                    SettingsPopupView(
                        onClose: {
                            showSettingsPopup = false
                        },
                        navigationPath: $path
                    )
                    .onDisappear {
                        focusedButton = .settings
                    }
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(100)
                }
            }.onAppear {
                focusedButton = .premium
                Analytics.logEvent("home_view)", parameters: [
                    "query": "home screen viewed"
                ])
            }
            .navigationDestination(for: Route.self) { route in
                   switch route {
                   case .web(let searchText, let searchType,let navigateRight):
                       WebScreen(searchText: searchText, searchType: searchType, navigeteRight: navigateRight, navigationPath: $path)
                   case .webDetail(let searchText, let hrefLink):
                       WebDetailScreen(searchText: searchText, hrefLink: hrefLink,viewID: UUID(), navigationPath: $path)
                   case .howToUse:
                       HowToUseScreen()
                   case .rateUs:
                       RateUs(navigationPath: $path)
                   case .feedbackScreen:
                       FeedbackScreen()
                   }
               }
            .onMoveCommand { direction in
                switch (focusedButton, direction) {
                    default:
                        break
                    }
                
            }
            
            
        }
    }
}
    

