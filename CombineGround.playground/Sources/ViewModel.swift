import Foundation
import Combine

public final class ViewModel {

    struct FailingModel: Codable, Equatable { }

    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    public enum State: Equatable {
        case idle
        case finished
        case failure(NetworkManager.Error)
        case success(UserList)
    }
    private var cancellables: Set<AnyCancellable> = []
    private(set) var state: State = .idle
    private let failingURLRequest: URLRequest = .init(url: .init(string: "www.some-test.com")!)
    private let sampleURLRequest: URLRequest = .init(url: .init(string: "https://jsonplaceholder.typicode.com/users")!)
}

extension ViewModel {

    func makeFailingRequest() {
        networkManager.createRequestPublisher(
            request: sampleURLRequest,
            urlSession: .shared,
            jsonDecoder: .init(),
            scheduler: DispatchQueue.main,
            decodableType: FailingModel.self
        ).sink { result in
            switch result {
            case .finished:
                self.state = .finished
            case let .failure(error):
                self.state = .failure(error)
            }
        } receiveValue: { _ in
            print("Imposible is Nothing")
        }.store(in: &cancellables)
    }

    func fetchUserList() {
        networkManager.createRequestPublisher(
            request: sampleURLRequest,
            urlSession: .shared,
            jsonDecoder: .init(),
            scheduler: DispatchQueue.main,
            decodableType: UserList.self
        ).sink { result in
            switch result {
            case .finished:
                self.state = .finished
            case let .failure(error):
                self.state = .failure(error)
            }
        } receiveValue: {
            self.state = .success($0)
        }.store(in: &cancellables)

    }
}
