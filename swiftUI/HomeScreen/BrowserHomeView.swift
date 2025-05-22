import SwiftUI

struct BrowserHomeView: View {
    @State private var searchText: String = ""

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // Logo & Title
                HStack {
                    Image(systemName: "bolt.circle") // Placeholder logo
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    Text("Fast Internet Browser")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.top, 60)

                // Search Bar
                HStack(spacing: 10) {
                    Button(action: {
                        // Voice Search Action
                    }) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    TextField("Search Here", text: $searchText)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(25)
                        .foregroundColor(.black)

                    Button(action: {
                        // Search Action
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .background(Color.white)
                .cornerRadius(25)
                .padding(.horizontal, 80)

                // Quick Access Buttons
                LazyVGrid(columns: columns, spacing: 30) {
                    BrowserButton(title: "Images", systemImage: "photo")
                    BrowserButton(title: "Youtube", systemImage: "play.rectangle.fill", isHighlighted: true)
                    BrowserButton(title: "Twitch", systemImage: "t.square.fill", iconColor: .purple)

                    BrowserButton(title: "Wikipedia", systemImage: "w.square")
                    BrowserButton(title: "eBay", systemImage: "cart", iconColor: .red)
                    BrowserButton(title: "Pinterest", systemImage: "p.circle.fill", iconColor: .red)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(white: 0.95))
        }
    }
}

struct BrowserButton: View {
    let title: String
    let systemImage: String
    var isHighlighted: Bool = false
    var iconColor: Color = .black

    var body: some View {
        Button(action: {
            // Handle navigation
        }) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundColor(iconColor)
                Text(title)
                    .fontWeight(.medium)
            }
            .padding()
            .frame(width: 250, height: 60)
            .background(isHighlighted ? Color.blue.opacity(0.8) : Color.white)
            .foregroundColor(.black)
            .cornerRadius(30)
            .shadow(radius: isHighlighted ? 4 : 1)
        }
        .buttonStyle(.plain)
    }
}
