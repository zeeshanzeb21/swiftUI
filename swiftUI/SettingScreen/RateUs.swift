import SwiftUI
import StoreKit
import FirebaseAnalytics
struct RateUs: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedButton: FocusableButton?
    @Binding var navigationPath: [Route]  // <- use binding from parent

    enum FocusableButton: Hashable {
        case left, right, cross, back, tryAgain
    }

    func isFocusedLeft() -> Bool { focusedButton == .left }
    func isFocusedRight() -> Bool { focusedButton == .right }
    func isFocusedCross() -> Bool { focusedButton == .cross }
    func isFocusedBack() -> Bool { focusedButton == .back }
    func isFocusedtryAgain() -> Bool { focusedButton == .tryAgain }
    
    @StateObject private var networkMonitor = NetworkMonitor()


    var body: some View {
        ZStack {
            Image("bgImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            
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
                                    
                                    
                                    
                                }
                            }) {
                                Text("Try Again")
                                    .font(.system(size: 31, weight: .bold, design: .default))
                                    .foregroundColor(isFocusedtryAgain() ? .white : Color(hex: "#D6D6D6"))
                                    .padding(8)
                            }
                            .focused($focusedButton, equals: .tryAgain)
                            .buttonStyle(PremiumButton(
                                isFocused: isFocusedtryAgain(),
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
            
            if(networkMonitor.isConnected){
                VStack(spacing: 0) {
                    ZStack {
                        Text("Did you enjoy using our app?")
                            .foregroundColor(.black)
                            .font(.system(size: 70, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                        
                        HStack {
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                Image(isFocusedCross() ? "cross_focus" : "cross_unfocus")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                            }
                            .focused($focusedButton, equals: .cross)
                            .buttonStyle(WebDetailStyle())
                            .padding(.top, 20)
                        }
                    }
                    .frame(height: 80)
                    .focusSection()
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            Analytics.logEvent("rate_us_liked", parameters: [
                                "query": "Rate Us Liked btn pressed"
                            ])
                            
                            let appStoreURL = URL(string: "https://apps.apple.com/pk/app/sco-video-tutorials/id1142206124")!
                            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        }) {
                            Image(isFocusedLeft() ? "rate_us_focused" : "rate_us_unfocused")
                                .resizable()
                                .frame(width: 316, height: 376)
                        }
                        .focused($focusedButton, equals: .left)
                        .buttonStyle(WebDetailStyle())
                        
                        Spacer().frame(width: 30)
                        
                        Button(action: {
                            Analytics.logEvent("rate_us_feedback", parameters: [
                                "query": "Rate Us Feedback btn pressed"
                            ])
                            
                            navigationPath.append(.feedbackScreen)
                        }) {
                            Image(isFocusedRight() ? "feedback_focused" : "feedback_unfocused")
                                .resizable()
                                .frame(width: 316, height: 376)
                        }
                        .focused($focusedButton, equals: .right)
                        .buttonStyle(WebDetailStyle())
                    }
                    
                    Spacer()
                }
                
                .onAppear {
                    focusedButton = .left
                }
                .focusSection()
            }
        }
        .navigationDestination(for: Route.self) { button in
            if button == .feedbackScreen {
                FeedbackScreen()
            }
        }
        .onMoveCommand { direction in
            switch (focusedButton, direction) {
            case (.cross, .down):
                focusedButton = .left
            case (.left, .right):
                focusedButton = .right
            case (.right, .left):
                focusedButton = .left
            case (.left, .up), (.right, .up):
                focusedButton = .cross
            default:
                break
            }
        }
    }
}
