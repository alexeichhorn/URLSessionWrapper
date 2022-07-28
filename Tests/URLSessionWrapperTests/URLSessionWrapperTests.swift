import XCTest
@testable import URLSessionWrapper

final class URLSessionWrapperTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(URLSessionWrapper().text, "Hello, World!")
    }
}
