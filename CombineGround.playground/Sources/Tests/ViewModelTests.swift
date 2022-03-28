import XCTest

public final class ViewModelTests: XCTestCase {
    private var networkManagerStub: NetworkManagerStub = .init()

    func testFailingRequest() {
        let expectedFailing: NetworkManager.Error = .invalidURL
        let receiveCompletionExpectation = expectation(description: "receiveCompletionExpectation")
        networkManagerStub.receiveCompletionExpectation = receiveCompletionExpectation

        let sut: ViewModel = .init(networkManager: networkManagerStub)

        sut.makeFailingRequest()
        networkManagerStub.createRequestPublisherResult.send(completion: .failure(expectedFailing))

        wait(for: [receiveCompletionExpectation], timeout: 0.5)
        XCTAssertEqual(sut.state, .failure(expectedFailing))
    }

    func testSuccessRequest() {
        let expectedResponse: UserList = [.fixture()]
        let receiveCompletionExpectation = expectation(description: "receiveCompletionExpectation")
        let receiveOutputExpectation = expectation(description: "receiveOutputExpectation")
        networkManagerStub.receiveCompletionExpectation = receiveCompletionExpectation
        networkManagerStub.receiveOutputExpectation = receiveOutputExpectation
        let sut: ViewModel = .init(networkManager: networkManagerStub)

        sut.fetchUserList()
        networkManagerStub.createRequestPublisherResult.send(expectedResponse)

        wait(for: [receiveOutputExpectation], timeout: 0.5)
        XCTAssertEqual(sut.state, .success(expectedResponse))
        networkManagerStub.createRequestPublisherResult.send(completion: .finished)
        wait(for: [receiveCompletionExpectation], timeout: 0.5)
        XCTAssertEqual(sut.state, .finished)
    }
}
