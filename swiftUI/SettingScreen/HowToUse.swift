import SwiftUI
struct HowToUseScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedButton: FocusableButton?
    
    enum FocusableButton {
        case cross, left, right
    }
    
    func isFocusedCross() -> Bool { focusedButton == .cross }
    func isFocusedLeft() -> Bool { focusedButton == .left }
    func isFocusedRight() -> Bool { focusedButton == .right }
    
    @State private var currentIndex = 0
    
    // 2. Your pages array
    let pages = ["how_to_use_one", "how_to_use_two", "how_to_use_three"]
    
    var body: some View {
        ZStack {
            Image("bgImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    Text("How to Use")
                        .foregroundColor(.black)
                        .font(.system(size: 70, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    HStack {
                        Spacer()
                        Button {
                            if currentIndex == 0 {
                                dismiss()
                            } else {
                                currentIndex -= 1
                            }
                        } label: {
                            Image(isFocusedCross() ? "cross_focus" : "cross_unfocus")
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                        .focused($focusedButton, equals: .cross)
                        .buttonStyle(WebDetailStyle())
                        .padding(.top, 20)
                        
                    }
                }.focusSection()
                .frame(height: 80) // fix height to avoid layout jumps
                
                Spacer().frame(height: 34)
            VStack {

                    Image(pages[currentIndex]) // assuming images named how_to_use_1, 2, 3
                        .resizable()
                        .frame(width: 1312, height: 738)
                        .cornerRadius(24)
                        .shadow(radius: 10)
                }
                
                Spacer()
                
                HStack(spacing: 44) {
                    if(currentIndex > 0)
                    {
                        Button(action: {
                            // 4. Handle Previous button
                            if currentIndex == 0 {
                                // At first page, dismiss on Previous
                                dismiss()
                            } else {
                                currentIndex -= 1
                            }
                        }) {
                            Text("Previous")
                                .font(.system(size: 34, weight: .medium))
                                .foregroundColor(isFocusedLeft() ? Color.white : Color(hex: "#3C3B3B").opacity(0.52))
                                .frame(width: 334, height: 80)
                        }
                        .focused($focusedButton, equals: .left)
                        .buttonStyle(PremiumButton(isFocused: isFocusedLeft(), width: 334, height: 80, cornerRadius: 53))
                    }
                    if currentIndex < pages.count - 1 {
                        Button(action: {
                            // 4. Handle Next button safely
                            if currentIndex < pages.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Text("Next")
                                .font(.system(size: 34, weight: .medium))
                                .foregroundColor(isFocusedRight() ? Color.white : Color(hex: "#3C3B3B").opacity(0.52))
                                .frame(width: 334, height: 80)
                        }
                        .focused($focusedButton, equals: .right)
                        .buttonStyle(PremiumButton(isFocused: isFocusedRight(), width: 334, height: 80, cornerRadius: 53))
                    }
                }.focusSection()
                .padding(.bottom, 20)
                    
            }
            .focusSection()
            .onAppear {
                focusedButton = .left
            }
        }.focusSection()
        .onMoveCommand { direction in
            switch (focusedButton, direction) {
            case (.cross, .down):
                focusedButton = .right
                focusedButton = .left
            default:
                break
            }
        }
    }
}
