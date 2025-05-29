import SwiftUI
struct WebDetailScreen: View {
    @FocusState private var focusedButton: FocusableButton?
    @ObservedObject var viewModel = DetailViewModel()
    enum FocusableButton {
        case left, right, search, premium, settings, images, link, videos, news, shopping, list, loadMore, loadless
    }
    var searchedTxt: String = ""
    func isFocusedLeft() -> Bool { focusedButton == .left }
    func isFocusedRight() -> Bool { focusedButton == .right }
    func isFocusedSearch() -> Bool { focusedButton == .search }
    func isFocusedPremium() -> Bool { focusedButton == .premium }
    func isFocusedSetting() -> Bool { focusedButton == .settings }
    func isFocusedLink() -> Bool { focusedButton == .link }
    @State private var showLinkList = false


    var body: some View {
        ZStack {

            Image("bgImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        
            if (viewModel.showLoading) {
                Text("Please wait! we are fetching results")
                    .font(Font.custom("Saira-Bold", size: 35))
                    .foregroundColor(Color(hex: "#3C3B3B"))
                    .padding(.top, 6)
            }
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    // Left Button
                    Button(action: {
                        print("Left tapped")
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
                    Button(action: {
                        print("Right tapped")
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
                                TextField(searchedTxt, text: .constant(searchedTxt))
                                    .font(.system(size: 30, weight: .regular))
                                    .foregroundColor(Color(hex: "#6A6767"))
                                    .padding(.leading, 10)
                                    .padding(.top, 10)
                                    .background(Color.clear)
                                    .textFieldStyle(.plain)
                                    .focused($focusedButton, equals: .search)
                            }
                            .frame(width: 1000, height: 80)
                        }
                        .padding(.leading, 70)
                        
        

                        Spacer()

                        // Premium + Settings
                        HStack(spacing: 16) {
                            Button(action: {
                                print("Premium tapped")
                            }) {
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
                }.focusSection()
                
                
                ZStack(alignment: .center) {
                    // Background scroll view
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(viewModel.slices, id: \.self) { imageUrlString in
                                RemoteImageView(urlString: imageUrlString, placeholderHeight: 150)
                            }
                        }
                    }
                    .focused($focusedButton, equals: .list)
                    .focusSection()

                    // Floating button on trailing center
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()

                            ZStack(alignment: .trailing) {
                                // Slide-out side panel
                                if showLinkList {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(["Link 1", "Link 2", "Link 3"], id: \.self) { link in
                                            Button(action: {
                                                print("Tapped \(link)")
                                            }) {
                                                Text(link)
                                                    .font(.system(size: 22, weight: .medium))
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .background(Color.blue.opacity(0.9))
                                                    .border(Color.white.opacity(0.3), width: 0.5)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: 300)
                                    .frame(maxHeight: .infinity)
                                    .background(Color.black.opacity(0.8))
                                    .transition(.move(edge: .trailing))
                                    .animation(.easeInOut, value: showLinkList)
                                }

                                // Floating button
                                Button(action: {
                                    showLinkList.toggle()
                                }) {
                                    Image(isFocusedLink() ? "link_btn_focus" : "link_btn_unfocus")
                                        .resizable()
                                        .frame(width: 72, height: 136)
                                }
                                .buttonStyle(WebDetailStyle())
                                .focused($focusedButton, equals: .link)
                            }
                            .padding(.trailing, 0)
                        }
                        Spacer()
                    }
                }
                .ignoresSafeArea()



                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } .onMoveCommand { direction in
            switch (focusedButton, direction) {
            case (.list, .left):
                focusedButton = .link
            default :
                break
            }
            
        }
        .onAppear {
            viewModel.getScreenShots(urls: "https://github.com/M-HamzaPro", ux_type: 1, ss_width: 0, ss_height: 0)
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.chatListLoadingError)
        }
    }
}

#Preview {
    WebDetailScreen()
}

