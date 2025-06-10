import SwiftUI

struct SettingsPopupView: View {
    let onClose: () -> Void
    @Binding var navigationPath: [Route]
    @FocusState private var focusedButton: FocusableButton?

    enum FocusableButton: Hashable {
        case rateUs, howToUse, cross
    }

    func isFocusedRate() -> Bool {
        focusedButton == .rateUs
    }

    func isFocusedHowUse() -> Bool {
        focusedButton == .howToUse
    }

    func isFocusedCross() -> Bool {
        focusedButton == .cross
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            HStack(spacing: 14) {
                settingButton(icon: isFocusedRate() ? "rate_us_focus" : "rate_us_unfocus", focus: .rateUs, height: 196, width: 184, route: .rateUs)

                settingButton(icon: isFocusedHowUse() ? "how_to_use_focus" : "how_to_use_unfocus", focus: .howToUse, height: 196, width: 184, route: .rateUs)

                settingButton(icon: isFocusedCross() ? "cross_focus" : "cross_unfocus", focus: .cross, height: 80, width: 80, route: .rateUs)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .padding(.top, 0)
        }
        .onAppear {
            focusedButton = .cross
        }
        .focusSection()
    }

    @ViewBuilder
    private func settingButton(icon: String, focus: FocusableButton, height: CGFloat, width: CGFloat,route: Route) -> some View {
        Button(action: {
            switch focus {
            case .cross:
                onClose()
            case .howToUse:
                navigationPath.append(.howToUse)
                onClose()
            case .rateUs:
                navigationPath.append(.rateUs)
                onClose()
            }
        }) {
            VStack {
                Image(icon)
                    .resizable()
                    .frame(width: width, height: height)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .focused($focusedButton, equals: focus)
        .buttonStyle(WebDetailStyle())
    }
}
