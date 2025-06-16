import SwiftUI
import FirebaseAnalytics
struct FeedbackScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedButton: FocusableButton?
    
    enum FocusableButton : Hashable {
        case content, appFreeze, cross,naigate, response, money, submit
    }
    
    
    @State private var selectedButtons: Set<FocusableButton> = []
    
    @State private var showValidationMessage = false



    
    func isFocusedContent() -> Bool { focusedButton == .content }
    func isFocusedFreeze() -> Bool { focusedButton == .appFreeze }
    func isFocusedCross() -> Bool { focusedButton == .cross }
    func isFocusedNavigate() -> Bool { focusedButton == .naigate }
    func isFocusedResponse() -> Bool { focusedButton == .response }
    func isFocusedMoney() -> Bool { focusedButton == .money }
    func isFocusedSubmit() -> Bool { focusedButton == .submit }

    
    func toggleSelection(for button: FocusableButton) {
        if selectedButtons.contains(button) {
            selectedButtons.remove(button)
        } else {
            selectedButtons.insert(button)
        }
    }


    
    var body: some View {
        ZStack {
            Image("bgImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    Text("Please tell us what issues you faced")
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
                }.focusSection()
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20){
                    Button(action: {
                        print("Tapped")
                        toggleSelection(for: .content)
                    }) {
                        HStack(spacing: 8) {
                            Image(selectedButtons.contains(.content) ? "tick_focus" : "tick_unfocus")
                                .resizable()
                                .frame(width: 31, height: 31)
                                .padding(8)
                            Text("Content not displaying properly ")
                                .font(.system(size: 34,weight: .regular,design: .default))
                                .foregroundColor(Color(hex: "#6A6767")).padding(13)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                    }
                    .focused($focusedButton, equals: .content)
                    .buttonStyle(FeedbackButtonStyle(isFocused: isFocusedContent(),height: 71, width: 580,cornerRadius: 36))
                    
                    Button(action: {
                        print("Tapped")
                        toggleSelection(for: .appFreeze)

                    }) {
                        HStack(spacing: 8) {
                            Image(selectedButtons.contains(.appFreeze) ? "tick_focus" : "tick_unfocus")
                                .resizable()
                                .frame(width: 31, height: 31)
                                .padding(8)
                            Text("App keeps Freezing or Crashing")
                                .font(.system(size: 34,weight: .regular,design: .default))
                                .foregroundColor(Color(hex: "#6A6767")).padding(13)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                    }
                    .focused($focusedButton, equals: .appFreeze)
                    .buttonStyle(FeedbackButtonStyle(isFocused: isFocusedFreeze(),height: 71, width: 580,cornerRadius: 36))
                    
                    Button(action: {
                        print("Tapped")
                        toggleSelection(for: .naigate)
                    }) {
                        HStack(spacing: 8) {
                            Image(selectedButtons.contains(.naigate) ? "tick_focus" : "tick_unfocus")
                                .resizable()
                                .frame(width: 31, height: 31)
                                .padding(8)
                            Text("Problem with navigation")
                                .font(.system(size: 34,weight: .regular,design: .default))
                                .foregroundColor(Color(hex: "#6A6767")).padding(13)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                    }
                    .focused($focusedButton, equals: .naigate)
                    .buttonStyle(FeedbackButtonStyle(isFocused: isFocusedNavigate(),height: 71, width: 478,cornerRadius: 36))
                    
                    Button(action: {
                        print("Tapped")
                        toggleSelection(for: .response)
                    }) {
                        HStack(spacing: 8) {
                            Image(selectedButtons.contains(.response) ? "tick_focus" : "tick_unfocus")
                                .resizable()
                                .frame(width: 31, height: 31)
                                .padding(8)
                            Text("Slow Search Response")
                                .font(.system(size: 34,weight: .regular,design: .default))
                                .foregroundColor(Color(hex: "#6A6767")).padding(13)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                    }
                    .focused($focusedButton, equals: .response)
                    .buttonStyle(FeedbackButtonStyle(isFocused: isFocusedResponse(),height: 71, width: 451,cornerRadius: 36))
                    
                    Button(action: {
                        print("Tapped")
                        toggleSelection(for: .money)
                    }) {
                        HStack(spacing: 8) {
                            Image(selectedButtons.contains(.money) ? "tick_focus" : "tick_unfocus")
                                .resizable()
                                .frame(width: 31, height: 31)
                                .padding(8)
                            Text("Not value for money")
                                .font(.system(size: 34,weight: .regular,design: .default))
                                .foregroundColor(Color(hex: "#6A6767")).padding(13)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16) // Optional: add padding inside the button for alignment
                    }
                    .focused($focusedButton, equals: .money)
                    .buttonStyle(FeedbackButtonStyle(isFocused: isFocusedMoney(),height: 71, width: 421,cornerRadius: 36))
                    
                    Button(action: {
                        
                        if selectedButtons.isEmpty {
                               showValidationMessage = true
                           } else {
                               showValidationMessage = false
                               
                               
                               let feedbackTexts: [String] = selectedButtons.map { button in
                                          switch button {
                                          case .content:
                                              return "Content not displaying properly"
                                          case .appFreeze:
                                              return "App keeps Freezing or Crashing"
                                          case .naigate:
                                              return "Problem with navigation"
                                          case .response:
                                              return "Slow Search Response"
                                          case .money:
                                              return "Not value for money"
                                          default:
                                              return ""
                                          }
                                      }

                                      let feedbackSummary = feedbackTexts.joined(separator: ", ")

                                      Analytics.logEvent("feedback_\(feedbackSummary)_submitted", parameters: [
                                          "query": "User selected particular feedback"
                                      ])

                                      print("Feedback submitted: \(feedbackSummary)")

                                      dismiss()
                                                                  
                           }
                       
                    }) {
                        Text("Submit")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(isFocusedSubmit() ? Color.white : Color(hex: "#6A6767"))
                    }.padding(.top, 20)
                    .focused($focusedButton, equals: .submit)
                    .buttonStyle(PremiumButton(isFocused: isFocusedSubmit(), width: 310,height: 78,cornerRadius: 53))
                    
                }.frame(maxWidth: .infinity, alignment: .leading) // Push contents to left
                    .padding(.leading, 16)
                
                Spacer()
                
                if showValidationMessage {
                    Text("*Please select at least 1 option to submit")
                        .font(.system(size: 40, weight: .regular))
                        .italic()
                        .foregroundColor(Color(hex: "#FF0000"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 20)
                        .transition(.opacity)
                }
                
                
                    
                
            }
            .focusSection()
            .onAppear {
                focusedButton = .content
            }
        }.focusSection()
        .onMoveCommand { direction in
            switch (focusedButton, direction) {
            case (.cross, .down):
                focusedButton = .content
            default:
                break
            }
        }
    }
}
