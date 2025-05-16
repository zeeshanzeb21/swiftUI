import Foundation
import Combine
class ViewModel: ObservableObject {
    
    @Published var products = [Product]()
    @Published var chatListLoadingError: String = ""
    @Published var showAlert: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        getChatList()
    }
    
    func getChatList() {
        dataManager.fetchChats()
            .sink { dataResponse in
                if let error = dataResponse.error {
                    self.createAlert(with: error)
                } else {
                    switch dataResponse.result {
                    case .success(let welcome):
                            self.products = welcome.products
                        print("hellooo \(welcome.products)")

                    case .failure(let error):
                        self.createAlert(with: error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
