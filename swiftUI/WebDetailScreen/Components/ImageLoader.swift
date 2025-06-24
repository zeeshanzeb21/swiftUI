//
//  ImageLoader.swift
//  swiftUI
//
//  Created by Invicttus on 29/05/2025.
//

import Combine
import SwiftUI


class ImageListLoader: ObservableObject {
    @Published var images: [String: UIImage] = [:]
    @Published var isLoading = true
    private var cancellables = Set<AnyCancellable>()

    func loadImages(from urls: [String]) {
        isLoading = true
        let publishers = urls.compactMap { urlString -> AnyPublisher<(String, UIImage?), Never>? in
            guard let url = URL(string: urlString) else { return nil }
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { (urlString, UIImage(data: $0.data)) }
                .replaceError(with: (urlString, nil))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .sink { [weak self] results in
                results.forEach { url, image in
                    self?.images[url] = image
                }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
//struct RemoteImageView: View {
//    let image: UIImage?
//    let placeholderHeight: CGFloat
//
//    var body: some View {
//        Button(action: {
//            print("Image button tapped")
//        }) {
//            ZStack {
//                if let uiImage = image {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .frame(maxWidth: .infinity)
//                } else {
//                    Color.gray
//                        .frame(height: placeholderHeight)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//        }
//        .focusSection()
//        .buttonStyle(WebDetailStyle())
//    }
//}
struct RemoteImageView: View {
    let image: UIImage?
    let placeholderHeight: CGFloat
    var focusField: FocusState<FocusableButtonForDetail?>.Binding
    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        HStack(spacing: 20) {
            // Left Button
            Button(action: {
                print("Left button tapped")
            }) {
                
                
                
            }
                .focused(focusField, equals: .linkButtonLeft)
                .frame(width: 0, height: 0)
                .opacity(0)

            
            // Main Image Button
            Button(action: {
                print("Image button tapped")
            }) {
                ZStack {
                    if let uiImage = image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    } else {
                        Color.gray
                            .frame(height: placeholderHeight)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(WebDetailStyle())
            
            Button(action: {
                print("Left button tapped")
            }) {
                
                
                
            }
                .frame(width: 0, height: 0)
                .opacity(0)
            
        }
        .onChange(of: focusField.wrappedValue) { newFocus in
            switch newFocus {
            case .linkButtonLeft:
                focusField.wrappedValue = .link
                viewModel.showLinkList = true
                print(newFocus)
            

            default:
                break
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @FocusState private var sampleFocusField: FocusableButtonForDetail?
        @StateObject private var viewModel = DetailViewModel()
        var body: some View {
            RemoteImageView(image: UIImage(named: ""), placeholderHeight: 0, focusField: $sampleFocusField, viewModel: viewModel)
        }
    }
    return PreviewWrapper()
}
