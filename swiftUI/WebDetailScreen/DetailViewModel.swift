//
//  WebViewModel.swift
//  swiftUI
//
//  Created by Invicttus on 27/05/2025.
//


import Foundation
import Combine
class DetailViewModel: ObservableObject {
    
    @Published var slices =  [String]()
    @Published var links = [Link]()
    @Published var basePath =  ""
    @Published var showAlert: Bool = false
    @Published var showLoading: Bool = false
    @Published var showLoadingSS: Bool = false

    @Published var chatListLoadingError: String = ""


    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
    }
    
    func getScreenShots(urls: String, ux_type: Int, ss_width: Int, ss_height: Int) {
        
       
        self.showLoading = true
        
        dataManager.fetchScreenShots(urls: urls, ux_type: 1, ss_width: 1920, ss_height: 100)
            .sink { [weak self] dataResponse in
                guard let self = self else { return }
                
                self.showLoading = false
                
                if let error = dataResponse.error {
                    self.createAlert(with: error)
                } else {
                    let basePath = dataResponse.value?.basePath ?? ""
                    let rawSlices = dataResponse.value?.slices ?? []
                    self.slices = rawSlices.map { "\(basePath)\($0)" }
                    print("slices\(self.slices)")
                }
            }
            .store(in: &cancellableSet)
    }
    
    func getInternalLinks(url: String) {
        self.showLoadingSS = true
        
        dataManager.fetchInternalLinks(urls: url)
            .sink { [weak self] dataResponse in
                guard let self = self else { return }
                
                self.showLoadingSS = false
                
                if let error = dataResponse.error {
                    self.createAlert(with: error)
                } else {
                    self.links = dataResponse.value?.links ?? []
                    print("links\(self.links)")
                }
            }
            .store(in: &cancellableSet)
    }

    
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
