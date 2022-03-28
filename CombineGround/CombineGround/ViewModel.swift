import RxSwift

final class ViewModel {

    enum Error: Swift.Error {
        case invalid
    }
    private let superUser: User = .init(id: "0", name: "Onur")
}

// MARK: - RXSwift
extension ViewModel {

    func getUser(requiresError: Bool = false) -> Observable<User> {
        guard !requiresError else {
            return .error(Error.invalid)
        }
        return .just(superUser)
    }
}

import Combine
extension ViewModel {

    func getUserPublisher(requiresError: Bool = false) -> AnyPublisher<User, ViewModel.Error> {
        let publisher: PassthroughSubject<User, ViewModel.Error> = .init()
        let disposable = getUser(requiresError: requiresError)
        // normally its not necessary but because we have just and its not that async to be able to wait before dealocation
            .delay(.seconds(1), scheduler: MainScheduler())
            .subscribe(
                onNext: { publisher.send($0) },
                onError: { publisher.send(completion: .failure(self.mapError($0))) },
                onCompleted: { publisher.send(completion: .finished) }
            )
        return publisher
            .handleEvents(
                receiveCompletion: { _ in disposable.dispose() },
                receiveCancel: { disposable.dispose() }
            )
            .eraseToAnyPublisher()
    }
}

// MARK: - Private

private extension ViewModel {

    func mapError(_ error: Swift.Error) -> Error {
        .invalid
    }
}


struct User: Identifiable, Codable {
    let id: String
    let name: String?
}


