import SwiftUI
import Lottie

struct LoadingView: View {
    @State private var currentMessageIndex = 0
    @State private var showMessage = true
    @State var screenShots = false
    
    let allMessages = [
        "Hang tight! We're fetching your results...",
        "Thanks for waiting, just a moment more!",
        "Almost there! Your content will be ready shortly.",
        "We're working on it! Please bear with us.",
        "Good things take time – we're almost there!",
        "Thanks for your patience! We're almost done.",
        "Your content is on its way. Please stay with us.",
        "Sorry for the delay! We're getting things ready.",
        "We appreciate your patience – just a few more seconds!",
        "Looks like it's taking a bit longer. We’ll have it soon!"
    ]
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            VStack {
                Spacer()
                    LottieView(animationName: "loading.json", loopMode: .loop)
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                ZStack {
                    if  showMessage {
                        Text(allMessages[currentMessageIndex])
                            .font(.system( size: 40,weight: .bold, design: .default))
                            .italic()
                            .foregroundColor(Color(hex: "#6A6767"))
                            .padding(.bottom, 10)
                            .transition(.opacity)
                            .id(currentMessageIndex)
                    } else {
                        
                        Text(" ")
                            .font(.system(size: 40, weight: .regular))
                            .hidden()
                    }
                }
                if (screenShots == true)
                {
                    Spacer().frame(height: 60)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: currentMessageIndex)
        }
        .onAppear {
            startMessageRotation()
        }
    }
    
    private func startMessageRotation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            withAnimation {
                showMessage = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                currentMessageIndex = (currentMessageIndex + 1) % allMessages.count
                withAnimation {
                    showMessage = true
                }
            }
        }
    }
}
