//
//  BrowserHomeView.swift
//  swiftUI
//
//  Created by Invicttus on 16/05/2025.
//
import SwiftUI
struct BrowserHomeView: View {
    @FocusState private var focusedButton: FocusableButton?

    @State var searchText: String = ""
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
    
    @State private var path = NavigationPath()


    
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
                            .padding(.trailing, 20)
                        }
                        
                    }
                    .focusSection()
                    .padding(.top, 57)
                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white)
                            .frame(width: 950, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(
                                        showError
                                            ? Color.red
                                            : (isFocusedSearch() ? Color(hex: "#005C79") : Color(hex: "#E3E3E4")),
                                        lineWidth: 4
                                    )
                            )

                        
                        HStack(spacing: 0) {
                            // Mic button
                            Button(action: {
                                print("Tapped mic")
                            }) {
                                Image("mic")
                                    .resizable()
                                    .frame(width: 84, height: 77)
                            }
                            .focused($focusedButton, equals: .mic)
                            .buttonStyle(.plain)
                            .focusable(false)
                            .offset(x: -26)
                            
                            if searchText.isEmpty {
                                Text(placeholderText)
                                    .foregroundColor(Color(hex: "#6A6767"))
                                    .font(.system(size: 35,weight: .medium))
                            }
                            
                            if(focusedButton != .search)
                            {
                                Text(searchText)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 35,weight: .medium))
                            }
                            
                            TextField("Search Here...", text: $searchText)
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                                .padding(.leading, 0)
                                .background(Color.clear)
                                .textFieldStyle(.plain)
                                .focused($focusedButton, equals: .search)
                                .onChange(of: focusedButton) { oldValue, newValue in
                                    if newValue == .search {
                                        placeholderText = ""
                                        showError = false
                                    } else {
                                        placeholderText = "Search Here..."
                                    }
                                }
                        }
                        
                        
                        .frame(width: 900, height: 80)
                        HStack(alignment: .center) {
                            
                            Button(action: {
                                if(searchText.isEmpty == false)
                                {
                                    path.append(FocusableButton.clickSearch)

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
                            print("Tapped")
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
                        }) {
                            HStack(spacing: 8) {
                                Image("ebay")
                                    .resizable()
                                    .frame(width: 51, height: 51)
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
            }.navigationDestination(for: SettingsPopupView.FocusableButton.self) { button in
                switch button {
                case .howToUse:
                    HowToUseScreen()
                case .rateUs:
                    RateUs(navigationPath: $path)
                default:
                    EmptyView()
                }
            }
            .navigationDestination(for: FocusableButton.self) { button in
                switch button {
                case .clickSearch:
                    WebScreen(searchText: searchText, navigationPath: $path, viewID: UUID())
                default:
                    EmptyView()
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
    
#Preview {
    BrowserHomeView()
}
