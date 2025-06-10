import SwiftUI

struct WebDetailScreen: View {
    @FocusState private var focusedButton: FocusableButton?
    @ObservedObject var viewModel = DetailViewModel()
    @State private var focusedIndex: Int? = nil
    @FocusState private var focusedField: FocusField?
    @State var searchText: String
    @State private var showLinkList = false
    @State var hrefLink: String


    private var interalLinks: [(Int, Link)] {
        Array(viewModel.links.enumerated())
    }
    enum FocusableButton {
        case left, right, search, premium, settings, images, link, videos, news, shopping, list, loadMore, loadless
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
    
    @Binding var navigationPath: [Route]
    @Environment(\.dismiss) private var dismiss

    
    @StateObject private var imageLoader = ImageListLoader()



    var body: some View {
            ZStack {
                Image("bgImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if viewModel.showLoading {
                    Text("Please wait! we are fetching results")
                        .font(Font.custom("Saira-Bold", size: 35))
                        .foregroundColor(Color(hex: "#3C3B3B"))
                        .padding(.top, 6)
                }
                
                VStack(alignment: .leading) {
                    topBar
                    contentArea
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onChange(of: focusedField) { oldValue, newFocus in
                switch newFocus {
                    
                case .item(let index):
                    print(index)
                    if index == 0 || index == viewModel.links.count - 1 {
                        showLinkList = false
                        focusedButton = .list
                    }
                default:
                    break
                }
            }
            .onMoveCommand { direction in
                switch (focusedButton, direction) {
                case (.link, .left):
                    focusedButton = .list
                default:
                    break
                }
            }
            
            .onChange(of: viewModel.showLoading) { wasLoading, isLoading in
                if wasLoading == true && isLoading == false {
                        viewModel.getInternalLinks(url: hrefLink)
                    
                }
            }
            
            .onAppear {
                   
                    viewModel.loadDataIfNeeded(urls: hrefLink, ux_type: 1, ss_width: 0, ss_height: 0)
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.chatListLoadingError)
            }.onReceive(viewModel.$slices) { newSlices in
                imageLoader.loadImages(from: newSlices)
            }
        
    }

    private var topBar: some View {
        HStack(spacing: 0) {
            Button(action: { print("Left tapped")
                print("hrefrfvdcfv \(hrefLink)")
                if !navigationPath.isEmpty {
                        navigationPath.removeLast()
                    } else {
                        dismiss()
                    }
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

            // Right Button
            Button(action: { print("Right tapped")
                navigationPath.append(.webDetail(searchText: searchText, hrefLink: hrefLink))
                showLinkList = false
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

            // Search Field
            HStack(alignment: .top) {
                ZStack {
//                    RoundedRectangle(cornerRadius: 40)
//                        .fill(Color.white)
//                        .frame(width: 1050, height: 80)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 40)
//                                .stroke(
//                                    isFocusedSearch() ? Color(hex: "#005C79") : Color(hex: "#E3E3E4"),
//                                    lineWidth: 4
//                                )
//                        )
//
//                    HStack(spacing: 0) {
//                        TextField(searchedTxt, text: .constant(searchedTxt))
//                            .font(.system(size: 30, weight: .regular))
//                            .foregroundColor(Color(hex: "#6A6767"))
//                            .padding(.leading, 10)
//                            .padding(.top, 10)
//                            .background(Color.clear)
//                            .textFieldStyle(.plain)
//                            .focused($focusedButton, equals: .search)
//                    }
//                    .frame(width: 1000, height: 80)
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
                }
                .padding(.leading, 70)

                Spacer()

                // Premium + Settings
                HStack(spacing: 16) {
                    Button(action: { print("Premium tapped") }) {
                        HStack(spacing: 8) {
                            Image("premium")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .padding(8)
                            Text("Premium")
                                .font(.system(size: 31, weight: .bold))
                                .foregroundColor(isFocusedPremium() ? .white : Color(hex: "#3C3B3B"))
                                .padding(8)
                        }
                    }
                    .focused($focusedButton, equals: .premium)
                    .buttonStyle(PremiumButton(isFocused: isFocusedPremium(), width: 260, height: 80, cornerRadius: 53))

                    Button(action: { print("Settings tapped") }) {
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
        .focusSection()
    }

    private var contentArea: some View {
        ZStack {
            
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 0) {
//                    ForEach(viewModel.slices, id: \.self) { imageUrlString in
//                        RemoteImageView(urlString: imageUrlString, placeholderHeight: 150)
//                    }
//                }
//            }
//            .focused($focusedButton, equals: .list)
//            .focusSection()
            
            
            if imageLoader.isLoading {
                Text("Just a moment — we're loading your results.")
                    .font(Font.custom("Saira-Bold", size: 35))
                    .foregroundColor(Color(hex: "#3C3B3B"))
                
                 } else {
                     ScrollView(.vertical, showsIndicators: false) {
                         VStack(spacing: 0) {
                             ForEach(viewModel.slices, id: \.self) { urlString in
                                 RemoteImageView(
                                     image: imageLoader.images[urlString],
                                     placeholderHeight: 150
                                 )
                             }
                         }
                     }
                     .focused($focusedButton, equals: .list)
                     .focusSection()
                 }
            

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    ZStack(alignment: .trailing) {
                        if showLinkList {
                            linkListView
                                .frame(width: 300)
                                .frame(maxHeight: .infinity)
                                .background(Color.white)
                                .ignoresSafeArea()
                                .cornerRadius(16)
                                .transition(.move(edge: .trailing))
                                .animation(.easeInOut, value: showLinkList)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(hex: "#E3E3E4").opacity(0.7), lineWidth: 4)
                                    
                                )
                        }
                        
                        Button(action: {
                            withAnimation {
                                showLinkList.toggle()
                            }
                        }) {
                            Image(isFocusedLink() ? "link_btn_focus" : "link_btn_unfocus")
                                .resizable()
                                .frame(width: 72, height: 136)
                        }
                        .buttonStyle(WebDetailStyle())
                        .focused($focusedButton, equals: .link)
                        .offset(x: showLinkList ? -330 + 36 : 0)
                        .animation(.easeInOut, value: showLinkList)
                    }
                }
                Spacer()
                
            }.focusSection()
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
            
            navigationPath.append(.webDetail(searchText: searchText, hrefLink: links.href ?? ""))
            showLinkList = false

            
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
