//
//  WebViewModel.swift
//  swiftUI
//
//  Created by Invicttus on 27/05/2025.
//


import Foundation
import Combine
import FirebaseAnalytics
class DetailViewModel: ObservableObject {
    
    @Published var slices =  [String]()
    @Published var links = [Link]()
    @Published var basePath =  ""
    @Published var showAlert: Bool = false
    @Published var showLoading: Bool = false
    @Published var showLoadingSS: Bool = false
    private var hasLoaded = false
    @Published var chatListLoadingError: String = ""
    @Published  var showLinkList = false
    @Published var allLinks: [Link] = []
    private var currentLimit = 150
    private let pageSize = 150



    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
    }
    
    func loadDataIfNeeded(urls: String, ux_type: Int, ss_width: Int, ss_height: Int) {
            guard !hasLoaded else { return }
            hasLoaded = true
            getScreenShots(urls: urls, ux_type: ux_type, ss_width: ss_width, ss_height: ss_height)
        }
    
    
    func getScreenShots(urls: String, ux_type: Int, ss_width: Int, ss_height: Int) {
        
        Analytics.logEvent("ud_call_sent", parameters: [
            "query": "user data request sent"
        ])
        self.showLoading = true
        
        dataManager.fetchScreenShots(urls: urls, ux_type: 1, ss_width: 1920, ss_height: 100)
            .sink { [weak self] dataResponse in
                guard let self = self else { return }
                
                self.showLoading = false
                
                if let error = dataResponse.error {
                    self.createAlert(with: error)
                    Analytics.logEvent("ud_call_failed_\(error.localizedDescription)", parameters: [
                        "query": "user data request call response failed with response"
                    ])
                    Analytics.logEvent("error_\(error.localizedDescription)", parameters: [
                        "query": "error type when occurred"
                    ])
                } else {
                    let basePath = dataResponse.value?.basePath ?? ""
                    let rawSlices = dataResponse.value?.slices ?? []
                    self.slices = rawSlices.map { "\(basePath)\($0)" }
                    print("slices\(self.slices)")
                    Analytics.logEvent("ud_call_success", parameters: [
                        "query": "When user data request call received successfully"
                    ])
                }
            }
            .store(in: &cancellableSet)
    }
    
//    func getInternalLinks(url: String) {
//        self.showLoadingSS = true
//        Analytics.logEvent("ud_call_sent", parameters: [
//            "query": "user data request sent"
//        ])
//        dataManager.fetchInternalLinks(urls: url)
//            .sink { [weak self] dataResponse in
//                guard let self = self else { return }
//                
//                self.showLoadingSS = false
//                
//                if let error = dataResponse.error {
//                    self.createAlert(with: error)
//                    Analytics.logEvent("ud_call_failed_\(error.localizedDescription)", parameters: [
//                        "query": "user data request call response failed with response"
//                    ])
//                    Analytics.logEvent("error_\(error.localizedDescription)", parameters: [
//                        "query": "error type when occurred"
//                    ])
//                } else {
//                    self.links = dataResponse.value?.links ?? []
//                    print("links\(self.links.count)")
//                    Analytics.logEvent("ud_call_success", parameters: [
//                        "query": "When user data request call received successfully"
//                    ])
//                    Analytics.logEvent("internal_link_open", parameters: [
//                        "query": "userr opened internal link in the website"
//                    ])
//                }
//            }
//            .store(in: &cancellableSet)
//    }

    func getInternalLinks(url: String) {
           self.showLoadingSS = true

           dataManager.fetchInternalLinks(urls: url)
               .sink { [weak self] dataResponse in
                   guard let self = self else { return }

                   self.showLoadingSS = false

                   if let error = dataResponse.error {
                       self.createAlert(with: error)
                   } else {
                       self.allLinks = dataResponse.value?.links ?? []
                       self.currentLimit = min(self.pageSize, self.allLinks.count)
                       self.links = Array(self.allLinks.prefix(self.currentLimit))
                       print("Loaded initial \(self.links.count) links")
                   }
               }
               .store(in: &cancellableSet)
       }

       func loadMoreIfNeeded(currentIndex: Int) {
           // Trigger only when the currentIndex reaches the last visible one
           if currentIndex == links.count - 1 && links.count < allLinks.count {
               let newLimit = min(currentLimit + pageSize, allLinks.count)
               if newLimit > currentLimit {
                   currentLimit = newLimit
                   links = Array(allLinks.prefix(currentLimit))
                   print("Loaded more: \(links.count) links")
               }
           }
       }
    
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
