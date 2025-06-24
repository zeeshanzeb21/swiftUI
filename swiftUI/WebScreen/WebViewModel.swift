import Foundation
import Combine
import FirebaseAnalytics
class WebViewModel: ObservableObject {
    
    @Published var searchData =  [DataModel]()
    @Published var chatListLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var showLoading: Bool = false
    @Published var totalPages: Int = 0

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
    }
    
    func getData(query: String, searchType: String, start: Int, limit: Int) {
        self.showLoading = true
        
        dataManager.fetchData(query: query, searchType: searchType, start: start, limit: limit)
            .sink { [weak self] dataResponse in
                print("Received response in sink")
                guard let self = self else { return }
                Analytics.logEvent("ud_call_sent", parameters: [
                    "query": "user data request sent"
                ])
                self.showLoading = false
                UserDefaults.standard.removeObject(forKey: "SavedLinks")
                UserDefaults.standard.removeObject(forKey: "CurrentLinkIndex")
                UserDefaults.standard.removeObject(forKey: "BackBtnClicked")
               
                
                if let error = dataResponse.error {
                    self.createAlert(with: error)
                    Analytics.logEvent("error_\(error.localizedDescription)", parameters: [
                        "query": "error type when occurred"
                    ])
                    Analytics.logEvent("ud_call_failed_\(error.localizedDescription)", parameters: [
                        "query": "user data request call response failed with response"
                    ])
                } else {
                    self.searchData = dataResponse.value?.data ?? []
                    self.totalPages = dataResponse.value?.total ?? 0
                    Analytics.logEvent("ud_call_success", parameters: [
                        "query": "When user data request call received successfully"
                    ])
                }
            }
            .store(in: &cancellableSet)
    }

    
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
