//
//  BrowserHomeView.swift
//  swiftUI
//
//  Created by Invicttus on 16/05/2025.
//
import SwiftUI

struct BrowserHomeView: View {
    @FocusState private var focusedButton: FocusableButton?
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    enum FocusableButton {
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
    
    var body: some View {
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
                                Image("premium")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(8)
                                    .cornerRadius(8)
                            }
                            .focusable()
                            .focused($focusedButton, equals: .premium)
                            .buttonStyle(BorderedButtonStyle(isFocused: isFocusedPremium()))
                            Button(action: {
                                print("Settings tapped")
                            }) {
                                Image("setting")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(8)
                            }
                            .focusable()
                            .focused($focusedButton, equals: .settings)
                            .buttonStyle(BorderedButtonStyle(isFocused: isFocusedSetting()))
                        }
                        .padding(.trailing, 20)
                    }
                    .focusSection()
                }
                .padding(.top, 57)
                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                        .frame(width: 950, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(
                                    isFocusedSearch() ? Color(hex: "#005C79") : Color(hex: "#E3E3E4"),
                                    lineWidth: 4
                                )
                        )

                    HStack(spacing: 10) {
                        // Mic Button
                        Button(action: {
                            print("Tapped mic")
                        }) {
                            Image("mic")
                                .resizable()
                                .frame(width: 20, height: 30)
                                .padding(8)
                        }
                        .focusable()
                        .focusSection()
                        .focused($focusedButton, equals: .mic)
                        .buttonStyle(BorderedButtonStyle(isFocused: isFocusedMic()))

                        if searchText.isEmpty {
                                Text("Type here...")
                                .foregroundColor(Color(hex: "#6A6767"))
                                    .font(.system(size: 35))
                                    .frame(height: 50)               // Match TextField height
                                    .padding(.leading, 10)
                                    .frame(maxHeight: .infinity, alignment: .center) //
                            }
                        else if focusedButton != .search
                        {
                            Text(searchText)
                                .foregroundColor(.gray)
                                .font(.system(size: 35))
                                .frame(height: 80)               // Match TextField height
                                .padding(.leading, 10)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                                TextField("", text: $searchText)
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                                .padding(.top, 6)
                                .padding(.leading, 10)
                                .background(Color.white)
                                .cornerRadius(25)
                                .textFieldStyle(.plain)
                                .focused($focusedButton, equals: .search)
                                .focusSection()
                    }
                    .frame(width: 950, height: 80)
                    
                }.padding(.top, 175)
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
                                .font(Font.custom("SF-Pro-Display-Light", size: 42))
                                .foregroundColor(isFocusedImages() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                }
                    }
                    .focusable()
                    .focused($focusedButton, equals: .images)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedImages()))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                                    Image("youtube")
                                        .resizable()
                                        .frame(width: 51, height: 51)
                                        .padding(8)
                            Text("Youtube")
                                .font(Font.custom("SF-Pro-Display-Light", size: 42))
                                .foregroundColor(isFocusedYoutube() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                }
                    }
                    .focusable()
                    .focused($focusedButton, equals: .youtube)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedYoutube()))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                                    Image("twich")
                                        .resizable()
                                        .frame(width: 51, height: 51)
                                        .padding(8)
                            Text("Twitch")
                                .font(Font.custom("SF-Pro-Display-Light", size: 42))
                                .foregroundColor(isFocusedTwich() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                }
                    }
                    .focusable()
                    .focused($focusedButton, equals: .twich)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedTwich()))
                }.padding(.top, 47)
                
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
                                .font(Font.custom("SF-Pro-Display-Light", size: 42))
                                .foregroundColor(isFocusedWeki() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                }
                    }
                    .focusable()
                    .focused($focusedButton, equals: .wikipedia)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedWeki()))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                                    Image("ebay")
                                        .resizable()
                                        .frame(width: 51, height: 51)
                                        .padding(8)
                            Text("eBay")
                                .font(Font.custom("SF-Pro-Display-Light", size: 42))
                                .foregroundColor(isFocusedEbay() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                }
                    }
                    .focusable()
                    .focused($focusedButton, equals: .ebay)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedEbay()))
                    Button(action: {
                        print("Tapped")
                    }) {
                        HStack(spacing: 8) {
                                    Image("pin")
                                        .resizable()
                                        .frame(width: 51, height: 51)
                                        .padding(8)
                            Text("Pinterest")
                                .font(Font.custom("SF-Pro-Display-Light", size: 42))
                                .foregroundColor(isFocusedPin() ? .white : Color(hex: "#3C3B3B")).padding(8)
                                }
                    }
                    .focusable()
                    .focused($focusedButton, equals: .pin)
                    .buttonStyle(BorderedMainButtonStyle(isFocused: isFocusedPin()))
                }.padding(.top, 10)
                Spacer()
                
                }
            }
        .onAppear {
            focusedButton = .premium
        }
        .onMoveCommand { direction in
            switch (focusedButton, direction) {
            case (.premium, .down):
                focusedButton = .search
            case (.settings, .down):
                focusedButton = .search
                
                default :
                break
            }
            
        }
        
            
        }
        
    }
