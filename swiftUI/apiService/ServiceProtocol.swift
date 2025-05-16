import Foundation
import Combine
import Alamofire

protocol ServiceProtocol {
    func fetchChats() -> AnyPublisher<DataResponse<Welcome, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func fetchChats() -> AnyPublisher<DataResponse<Welcome, NetworkError>, Never> {
        let url = URL(string: "https://dummyjson.com/products")!
        return AF.request(url,
                          method: .get)
            .validate()
            .publishDecodable(type: Welcome.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
