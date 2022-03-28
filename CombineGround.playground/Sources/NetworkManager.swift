import Combine
import Foundation

public protocol NetworkManagerProtocol {

    func createRequestPublisher<D, S>(
        request: URLRequest,
        urlSession: URLSession,
        jsonDecoder: JSONDecoder,
        scheduler: S,
        decodableType: D.Type
    ) -> AnyPublisher<D, NetworkManager.Error> where D: Decodable, S: Scheduler
}


public struct NetworkManager {
    public init() { }

    public enum Error: Swift.Error, Equatable {
        case invalidURL
        case decodingError(DecodingError)
        case invalid(Swift.Error)

        // just for the sake of simplicity
        public static func == (lhs: NetworkManager.Error, rhs: NetworkManager.Error) -> Bool {
            lhs.localizedDescription == rhs.localizedDescription
        }
    }
}

// MARK: - NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {

    public func createRequestPublisher<D, S>(
        request: URLRequest,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init(),
        scheduler: S,
        decodableType: D.Type
    ) -> AnyPublisher<D, Error> where D: Decodable, S: Scheduler {
        urlSession
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: decodableType, decoder: jsonDecoder)
            .mapError(mapError)
            .eraseToAnyPublisher()
    }
}

private extension NetworkManager {

    func mapError(_ error: Swift.Error) -> Error {
        switch error {
        case is DecodingError:
            return .decodingError(error as! DecodingError)

        case is URLError where (error as NSError).code == URLError.unsupportedURL.rawValue:
            return .invalidURL

        default:
            return .invalid(error)
        }
    }
}
