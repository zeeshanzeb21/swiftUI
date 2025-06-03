import SwiftUI
import StoreKit

struct RateUs: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedButton: FocusableButton?
    @Binding var navigationPath: NavigationPath  // <- use binding from parent

    enum FocusableButton: Hashable {
        case left, right, cross
    }

    func isFocusedLeft() -> Bool { focusedButton == .left }
    func isFocusedRight() -> Bool { focusedButton == .right }
    func isFocusedCross() -> Bool { focusedButton == .cross }

    var body: some View {
        ZStack {
            Image("bgImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

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
                        navigationPath.append(FocusableButton.right)
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
        .navigationDestination(for: FocusableButton.self) { button in
            if button == .right {
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
