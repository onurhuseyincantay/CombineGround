import Combine
import XCTest

public struct NetworkManagerStub {
    public init() { }

    public var receiveOutputExpectation: XCTestExpectation?
    public var receiveCompletionExpectation: XCTestExpectation?
    public var createRequestPublisherResult: PassthroughSubject<Any, NetworkManager.Error> = .init()
}

// MARK: - NetworkManagerProtocol
extension NetworkManagerStub: NetworkManagerProtocol {

    public func createRequestPublisher<D, S>(
        request: URLRequest,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init(),
        scheduler: S,
        decodableType: D.Type
    ) -> AnyPublisher<D, NetworkManager.Error> where D: Decodable, S: Scheduler {
        createRequestPublisherResult
            .compactMap { $0 as? D }
            .handleEvents(
                receiveOutput: { _ in receiveOutputExpectation?.fulfill() },
                receiveCompletion: { _ in receiveCompletionExpectation?.fulfill() }
        ).eraseToAnyPublisher()
    }
}
