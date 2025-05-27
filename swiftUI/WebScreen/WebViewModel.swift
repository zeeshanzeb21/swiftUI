import Foundation
import Combine
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
                guard let self = self else { return }
                
                self.showLoading = false
                
                if let error = dataResponse.error {
                    self.createAlert(with: error)
                } else {
                    self.searchData = dataResponse.value?.data ?? []
                    self.totalPages = dataResponse.value?.total ?? 0
                    print(self.totalPages)
                }
            }
            .store(in: &cancellableSet)
    }

    
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
