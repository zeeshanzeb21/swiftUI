import SwiftUI
import FirebaseAnalytics

enum FocusableButtonForDetail {
    case left, right, search, premium, settings, images, link, videos, news, shopping, list, loadMore, loadless, back, tryAgain, linkButtonRight, linkButtonLeft, linkListLeftButton
}

struct WebDetailScreen: View {
    @FocusState private var focusedButton: FocusableButtonForDetail?
    @ObservedObject var viewModel = DetailViewModel()
    @State private var focusedIndex: Int? = nil
    @FocusState private var focusedField: FocusField?
    @State var searchText: String
    //    @State private var showLinkList = false
    @State var hrefLink: String
    let viewID: UUID
    @State private var visitedLinks: [String] = []
    
    private var interalLinks: [(Int, Link)] {
        Array(viewModel.links.enumerated())
    }
    
    
    enum FocusField: Hashable {
        case item(Int)
    }
    
    var searchedTxt: String = ""
    
    func isFocusedLeft() -> Bool { focusedButton == .left }
    func isFocusedRight() -> Bool { focusedButton == .right }
    func isFocusedSearch() -> Bool { focusedButton == .search }
    func isFocusedPremium() -> Bool { focusedButton == .premium }
    func isFocusedSetting() -> Bool { focusedButton == .settings }
    func isFocusedLink() -> Bool { focusedButton == .link }
    
    func isFocusedBack() -> Bool {
        focusedButton == .back
    }
    
    func isFocusedTryAgain() -> Bool {
        focusedButton == .tryAgain
    }
    
    @Binding var navigationPath: [Route]
    @Environment(\.dismiss) private var dismiss
    
    
    @StateObject private var imageLoader = ImageListLoader()
    
    @State private var showSettingsPopup = false
    
    @StateObject private var networkMonitor = NetworkMonitor()
    
    
    
    var body: some View {
        
        ZStack {
//            Image("bgImage")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
            
            
            
            
            if (viewModel.showLoading || imageLoader.isLoading) {
                LoadingView(screenShots: false)
            }
            
            if (viewModel.showLoading == false && viewModel.slices.isEmpty)
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
                                if !navigationPath.isEmpty {
                                    UserDefaults.standard.set(true, forKey: "BackBtnClicked")
                                    var currentIndex = UserDefaults.standard.getCurrentLinkIndex()
                                    currentIndex -= 1
                                    UserDefaults.standard.setCurrentLinkIndex(currentIndex)
                                    let savedLinks = UserDefaults.standard.getSavedLinks()
                                    print("ind \(savedLinks.count)")
                                    print("currentIndex \(currentIndex)")
                                    navigationPath.removeLast()
                                } else {
                                    
                                    dismiss()
                                    
                                }
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
                                    focusedButton = .search
                                    viewModel.loadDataIfNeeded(urls: hrefLink, ux_type: 1, ss_width: 0, ss_height: 0)
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
            
            VStack(alignment: .leading) {
                topBar
                contentArea
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
        }.background(Color.white)
            .disabled(viewModel.showLoading || imageLoader.isLoading)
            .onChange(of: viewModel.showLinkList) { oldValue, newValue in
                if newValue {
                    focusedField = .item(0)
                }
            }
        
        //            .onMoveCommand { direction in
        //                switch (focusedButton, direction) {
        //
        //                case (_, .right) where viewModel.showLinkList:
        //                    withAnimation {
        //                        viewModel.showLinkList = false
        //                        focusedButton = .list
        //
        //                    }
        //
        //                default:
        //                    break
        //                }
        //            }
        
        
        
        
        
        
        
        
            .onChange(of: viewModel.showLoading) { wasLoading, isLoading in
                if wasLoading == true && isLoading == false {
                    viewModel.getInternalLinks(url: hrefLink)
                    
                }
            }
        
            .task(id: viewID) {
                
                if networkMonitor.isConnected {
                    
                    focusedButton = .search
                    viewModel.loadDataIfNeeded(urls: hrefLink, ux_type: 1, ss_width: 0, ss_height: 0)
                }
            }
        
        //            .alert("Error", isPresented: $viewModel.showAlert) {
        //                Button("OK", role: .cancel) {}
        //            } message: {
        //                Text(viewModel.chatListLoadingError)
        //            }
            .onReceive(viewModel.$slices) { newSlices in
                imageLoader.loadImages(from: newSlices)
            }
        
    }
    
    private var topBar: some View {
        HStack(spacing: 0) {
            //            Button(action: { print("Left tapped")
            //                if !navigationPath.isEmpty {
            //                    UserDefaults.standard.set(true, forKey: "BackBtnClicked")
            //                      var currentIndex = UserDefaults.standard.getCurrentLinkIndex()
            //                      currentIndex -= 1
            //                      UserDefaults.standard.setCurrentLinkIndex(currentIndex)
            //                    let savedLinks = UserDefaults.standard.getSavedLinks()
            //                    print("ind \(savedLinks.count)")
            //                    print("currentIndex \(currentIndex)")
            //                        navigationPath.removeLast()
            //                    } else {
            //
            //                        dismiss()
            //
            //                    }
            //            }) {
            //                Image(isFocusedLeft() ? "left_focus" : "left_unfocus")
            //                    .resizable()
            //                    .frame(width: isFocusedLeft() ? 17 : 12, height: isFocusedLeft() ? 29 : 19)
            //                    .padding(8)
            //            }
            //            .focused($focusedButton, equals: .left)
            //            .buttonStyle(PremiumButton(
            //                isFocused: isFocusedLeft(),
            //                width: isFocusedLeft() ? 60 : 45,
            //                height: isFocusedLeft() ? 60 : 45,
            //                cornerRadius: isFocusedLeft() ? 30 : 23
            //            ))
            //
            //            Button(action: { print("Right tapped")
            //                let savedLinks = UserDefaults.standard.getSavedLinks()
            //                var currentIndex = UserDefaults.standard.getCurrentLinkIndex()
            //                let backClicked = UserDefaults.standard.bool(forKey: "BackBtnClicked")
            //                print("currentIndex \(currentIndex)")
            //                print("currentIndex \(savedLinks)")
            //
            //                if currentIndex < savedLinks.count {
            //                    let nextLink = savedLinks[currentIndex]
            //                    navigationPath.append(.webDetail(searchText: searchText, hrefLink: nextLink))
            //                } else {
            //                    print("Already at the last link. No forward navigation.")
            //                }
            //                if(backClicked == true && currentIndex < savedLinks.count)
            //                {
            //                    currentIndex += 1
            //                    UserDefaults.standard.setCurrentLinkIndex(currentIndex)
            //                }
            //
            //
            //
            //            }) {
            //                Image(isFocusedRight() ? "right_focus" : "right_unfocus")
            //                    .resizable()
            //                    .frame(width: isFocusedRight() ? 17 : 12, height: isFocusedRight() ? 29 : 19)
            //                    .padding(8)
            //            }
            //            .focused($focusedButton, equals: .right)
            //            .buttonStyle(PremiumButton(
            //                isFocused: isFocusedRight(),
            //                width: isFocusedRight() ? 60 : 45,
            //                height: isFocusedRight() ? 60 : 45,
            //                cornerRadius: isFocusedRight() ? 30 : 23
            //            ))
            //            .padding(.leading, 13)
            
            // Search Field
            
            
            ZStack {
                Color.clear
                    .frame(width: 60, height: 60) // Fixed container
                
                Button(action: {
                    if !navigationPath.isEmpty {
                        UserDefaults.standard.set(true, forKey: "BackBtnClicked")
                        var currentIndex = UserDefaults.standard.getCurrentLinkIndex()
                        currentIndex -= 1
                        UserDefaults.standard.setCurrentLinkIndex(currentIndex)
                        let savedLinks = UserDefaults.standard.getSavedLinks()
                        print("ind \(savedLinks.count)")
                        print("currentIndex \(currentIndex)")
                        navigationPath.removeLast()
                    } else {
                        
                        dismiss()
                        
                    }
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
                    let savedLinks = UserDefaults.standard.getSavedLinks()
                    var currentIndex = UserDefaults.standard.getCurrentLinkIndex()
                    let backClicked = UserDefaults.standard.bool(forKey: "BackBtnClicked")
                    print("currentIndex \(currentIndex)")
                    print("currentIndex \(savedLinks)")
                    
                    if currentIndex < savedLinks.count {
                        let nextLink = savedLinks[currentIndex]
                        navigationPath.append(.webDetail(searchText: searchText, hrefLink: nextLink))
                    } else {
                        print("Already at the last link. No forward navigation.")
                    }
                    if(backClicked == true && currentIndex < savedLinks.count)
                    {
                        currentIndex += 1
                        UserDefaults.standard.setCurrentLinkIndex(currentIndex)
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
            
            // SEARCH BAR (no layout shift now)
            Button(action: {
                focusedButton = .search
            }) {
                ZStack {
                    Image(isFocusedSearch() ? "search_focus" : "search_simple")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 950, height: 80)
                        .clipped()
                    
                    HStack {
                        Text(searchText.isEmpty ? "Search Here..." : searchText)
                            .foregroundColor(Color(hex: "#6A6767"))
                            .font(.system(size: 30, weight: .regular))
                            .frame(width: 800, alignment: .leading)
                            .padding(.leading, 40)
                    }
                    .frame(width: 950, height: 80)
                }.padding(.leading, 40)
            }
            .buttonStyle(WebDetailStyle())
            .focused($focusedButton, equals: .search)
            
            
            HStack(alignment: .top) {
                
                
                
                Spacer()
                
                // Premium + Settings
                HStack(spacing: 16) {
                    //                    Button(action: { print("Premium tapped") }) {
                    //                        HStack(spacing: 8) {
                    //                            Image("premium")
                    //                                .resizable()
                    //                                .frame(width: 48, height: 48)
                    //                                .padding(8)
                    //                            Text("Premium")
                    //                                .font(.system(size: 31, weight: .bold))
                    //                                .foregroundColor(isFocusedPremium() ? .white : Color(hex: "#3C3B3B"))
                    //                                .padding(8)
                    //                        }
                    //                    }
                    //                    .focused($focusedButton, equals: .premium)
                    //                    .buttonStyle(PremiumButton(isFocused: isFocusedPremium(), width: 260, height: 80, cornerRadius: 53))
                    
                    Button(action: { print("Settings tapped")
                        showSettingsPopup = true
                    }) {
                        Image(isFocusedSetting() ? "setting_focus" : "setting")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .padding(8)
                    }
                    .focused($focusedButton, equals: .settings)
                    .buttonStyle(BorderedButtonStyle(isFocused: isFocusedSetting()))
                    .disabled(viewModel.showLinkList)
                }
                .padding(.trailing, 0)
            }
        }
        
    }
    
    private var contentArea: some View {
        ZStack {
            
            
            if imageLoader.isLoading {
                
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(viewModel.slices, id: \.self) { urlString in
                            RemoteImageView(
                                image: imageLoader.images[urlString],
                                placeholderHeight: 150, focusField: $focusedButton,
                                viewModel: viewModel
                            )
                        }
                    }
                }
                .focused($focusedButton, equals: .list)
                .disabled(viewModel.showLinkList || showSettingsPopup)
                
            }
            
            if(networkMonitor.isConnected){
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        ZStack(alignment: .trailing) {
                            if (viewModel.showLinkList) {
                                HStack(spacing: 0) {
                                    linkListView
                                        .frame(maxWidth: 300)
                                        .frame(maxHeight: .infinity)
                                        .ignoresSafeArea()
                                        .cornerRadius(16)
                                        .transition(.move(edge: .trailing))
                                        .animation(.easeInOut, value: viewModel.showLinkList)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(hex: "#E3E3E4").opacity(0.7), lineWidth: 4)
                                            
                                        )
                                    Button(action: {}) {
                                        Text("")
                                            .frame(maxHeight: .infinity)

                                    }
                                    .focused($focusedButton, equals: .linkListLeftButton)
                                    .frame(maxHeight: .infinity)
                                    .frame(width: 1)
                                    .opacity(0)
                                }
                               
                                .onChange(of: focusedButton) { newFocus in
                                    switch newFocus {
                                    case .linkListLeftButton:
                                        focusedButton = .link
                                        viewModel.showLinkList = false
                                       print(newFocus)
    
                                    default:
                                        break
                                    }
                                }
                                
                            }
                            
                            Button(action: {
                                withAnimation {
                                    viewModel.showLinkList.toggle()
                                    if(viewModel.showLinkList == true)
                                    {
                                        Analytics.logEvent("internal_link_tab_open", parameters: [
                                            "query": "User opens an internal links tab in the webpage"
                                        ])
                                    }
                                }
                            }) {
                                Image(isFocusedLink() ? "link_btn_focus" : "link_btn_unfocus")
                                    .resizable()
                                    .frame(width: 72, height: 136)
                            }
                            .buttonStyle(WebDetailStyle())
                            .focused($focusedButton, equals: .link)
                            .offset(x: viewModel.showLinkList ? -330 + 36 : 0)
                            .animation(.easeInOut, value: viewModel.showLinkList)
                            .disabled(showSettingsPopup)
                        }
                    }
                    Spacer()
                    
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private var linkListView: some View {
        
        VStack(alignment: .leading) {
            Text("Browse Internal Links")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex: "#938B8B"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
                .padding(.bottom, 16)
                .background(Color.white)
            ScrollView{
                ForEach(viewModel.links.indices, id: \.self) { index in
                    listView(index: index, links: viewModel.links[index])
                }
            }
            Spacer()
        }
    }
    
    
    
    @ViewBuilder
    private func listView(index: Int, links: Link) -> some View {
        Button(action: {
            
            let href = links.href ?? ""
            UserDefaults.standard.saveLink(href)
            var currentIndex = UserDefaults.standard.getCurrentLinkIndex()
            currentIndex += 1
            UserDefaults.standard.setCurrentLinkIndex(currentIndex)
            navigationPath.append(.webDetail(searchText: searchText, hrefLink: links.href ?? ""))
            viewModel.showLinkList = false
            
            var savedLinks = UserDefaults.standard.getSavedLinks()
            let currentInd = UserDefaults.standard.getCurrentLinkIndex()
            
            if currentIndex < savedLinks.count {
                savedLinks = Array(savedLinks.prefix(currentIndex))
                UserDefaults.standard.set(savedLinks, forKey: "SavedLinks")
            }
            
            print("hello")
            print("currentIndex \(currentInd)")
            print("currentIndex \(savedLinks)")
            
            
        }) {
            Text(links.text ?? "")
                .font(.system(size: 25, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(InnerLinkList(
            isFocused: focusedIndex == index,
            height: 20,
            width: 290,
            selectedColor: Color(hex: "#005C79")
        ))
        .focused($focusedField, equals: .item(index))
        .onChange(of: focusedField) { oldValue, newValue in
            if case .item(let idx) = newValue {
                focusedIndex = idx
            }
        }
    }
    

    



}
