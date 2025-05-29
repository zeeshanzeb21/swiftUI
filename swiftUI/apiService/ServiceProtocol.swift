import Foundation
import Combine
import Alamofire

protocol ServiceProtocol {
    func fetchData(query: String, searchType: String, start: Int, limit: Int) -> AnyPublisher<DataResponse<SearchModel, NetworkError>, Never>
    
    func fetchScreenShots(urls: String, ux_type: Int, ss_width: Int, ss_height: Int) -> AnyPublisher<DataResponse<ScreenShotModel, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func fetchData(query: String, searchType: String, start: Int, limit: Int) -> AnyPublisher<DataResponse<SearchModel, NetworkError>, Never> {
        let url = URL(string: "https://app.fastbrowser.online/search")!
        
        let parameters: [String: String] = [
            "query": query,
            "searchType": searchType,
            "start": "\(start)",
            "limit": "\(limit)"
        ]
        print("parameters")
        print(parameters)
        return AF.request(url,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default)
            .validate()
            .publishDecodable(type: SearchModel.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchScreenShots(urls: String, ux_type: Int, ss_width: Int, ss_height: Int) -> AnyPublisher<DataResponse<ScreenShotModel, NetworkError>, Never> {
        let url = URL(string: "https://app.fastbrowser.online/screenshot/")!
        
        let parameters: [String: Any] = [
            "url": urls,
            "ux_type": ux_type,
            "ss_width": ss_width,
            "ss_height": ss_height
        ]
        print("parameters")
        print(parameters)
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: ScreenShotModel.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    }
    
