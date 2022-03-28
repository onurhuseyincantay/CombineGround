import XCTest

public final class TestObserver: NSObject, XCTestObservation {
    public override init() { }

    public func testCase(
      _ testCase: XCTestCase,
      didFailWithDescription description: String,
      inFile filePath: String?,
      atLine lineNumber: Int
    ) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}
