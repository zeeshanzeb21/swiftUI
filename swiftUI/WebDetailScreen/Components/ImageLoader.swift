//
//  ImageLoader.swift
//  swiftUI
//
//  Created by Invicttus on 29/05/2025.
//

import Combine
import SwiftUI
class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    private var url: URL?
    private var cancellable: AnyCancellable?

    init(url: URL?) {
        self.url = url
        load()
    }

    func load() {
        guard let url = url else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    deinit {
        cancellable?.cancel()
    }
}

// 2. RemoteImageView to replace AsyncImage
struct RemoteImageView: View {
    @StateObject private var loader: ImageLoader
    var placeholderHeight: CGFloat = 150

    init(urlString: String, placeholderHeight: CGFloat = 150) {
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: urlString)))
        self.placeholderHeight = placeholderHeight
    }

    var body: some View {
        
        Button(action: {

            print("Image button tapped")
        }) {
            ZStack {
                if let uiImage = loader.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(maxWidth: .infinity)
                } else {
                    Color.gray
                        .frame(height: placeholderHeight)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            ProgressView()
                        )
                }
            }
        }.focusSection()
            .buttonStyle(WebDetailStyle())
    }
}
