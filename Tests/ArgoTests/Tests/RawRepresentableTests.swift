import XCTest
import Argo

enum TestRawString: String {
  case CoolString
  case NotCoolStringBro
}

enum TestRawInt: Int {
  case zero
  case one
}

extension TestRawString: Argo.Decodable { }
extension TestRawInt: Argo.Decodable { }

class RawRepresentable: XCTestCase {
  func testStringEnum() {
    let json = Value.object([
      "string": Value.string("CoolString"),
      "another": Value.string("NotCoolStringBro")
      ])

    let string: TestRawString? = (json <| "string").value
    let another: TestRawString? = (json <| "another").value
    XCTAssert(TestRawString.CoolString == string)
    XCTAssert(TestRawString.NotCoolStringBro == another)
  }

  func testIntEnum() {
    let json = Value.object([
      "zero": Value.number(0),
      "one": Value.number(1)
      ])

    let zero: TestRawInt? = (json <| "zero").value
    let one: TestRawInt? = (json <| "one").value
    XCTAssert(TestRawInt.zero == zero)
    XCTAssert(TestRawInt.one == one)
  }
}
