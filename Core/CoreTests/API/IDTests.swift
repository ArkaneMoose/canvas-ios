//
// Copyright (C) 2018-present Instructure, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import XCTest
@testable import Core

class IDTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testStringLiteral() {
        let two: ID = "2"
        XCTAssertEqual(two, "2")
        XCTAssertEqual(two.description, two.value)
    }

    func testOtherStringLiterals() {
        XCTAssertEqual(ID(extendedGraphemeClusterLiteral: "❄︎"), "❄︎")
        XCTAssertEqual(ID(unicodeScalarLiteral: "ñ"), "ñ")
    }

    func testIntLiteral() {
        let foo: ID = 2
        XCTAssertEqual(foo, "2")
        XCTAssertEqual(foo, 2)
    }

    func testDecodeFromInt() {
        let data = """
                    {
                    "access_token": "token",
                    "token_type": "Bearer",
                    "user": {
                        "id": 3,
                        "name": "student",
                        "global_id": "1",
                        "effective_locale": "en"
                    },
                    "refresh_token": "refresh"
            }
            """.data(using: String.Encoding.utf8)!

        let token = try? JSONDecoder().decode(APIOAuthToken.self, from: data)
        XCTAssertEqual(token?.user.id, "3")
        XCTAssertEqual(token?.user.id, 3)
    }

    func testEncodeAndDecodeTogether() {
        let group = APIGroup.make(["id": "2"])
        let encoded = try! JSONEncoder().encode(group)
        let decoded = try! JSONDecoder().decode(APIGroup.self, from: encoded)
        XCTAssertEqual(decoded.id, "2")
        XCTAssertEqual(decoded.id.value, "2")
    }

    func testEncodeAndDecodeEmpty() {
        let group = APIGroup.make(["id": ""])
        let encoded = try! JSONEncoder().encode(group)
        let decoded = try! JSONDecoder().decode(APIGroup.self, from: encoded)
        XCTAssertEqual(decoded.id, "")
    }
}
