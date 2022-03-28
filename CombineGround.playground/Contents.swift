import Combine

let sequencePublisher = [1, 2, 3, 4].publisher
let stringSequencePublisher = ["One", "Two", "Three", "Four"].publisher
var cancellables: Set<AnyCancellable> = []

sequencePublisher.sink { result in
    switch result {
    case .finished:
        print("Sequence Finished")
    case .failure:
        print("Imposible is nothing")
    }
} receiveValue: { value in
    print(value)
}.store(in: &cancellables)

let mergedSequencePublisher = stringSequencePublisher
    .zip(sequencePublisher)
    .flatMap { (stringPublisher, intPublisher) in
        Just("Int Value: \(intPublisher), String Value: \(stringPublisher)")
    }.map { $0 as String? }
    .eraseToAnyPublisher()
import UIKit
private let sequenceLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .brown
    return label
}()

mergedSequencePublisher
    .assign(to: \.text, on: sequenceLabel)
    .store(in: &cancellables)

mergedSequencePublisher.sink { result in
        switch result {
        case .finished:
            print("Sequence Finished")
        case .failure:
            print("Imposible is nothing")
        }
    } receiveValue: {
        print($0)
    }.store(in: &cancellables)

print("-------------------")
print(sequenceLabel.text)

import XCTest

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
ViewModelTests.defaultTestSuite.run()
