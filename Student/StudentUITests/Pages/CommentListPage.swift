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

import Foundation

enum CommentListPage: String, UITestElement, CaseIterable {
    case replyButton
    case replyTextView
    case tableView
}

struct CommentListItem: RawRepresentable, UITestElement {
    let rawValue: String

    static func item(_ id: String) -> CommentListItem {
        return CommentListItem(rawValue: id)
    }

    static func deleteButton(_ id: String) -> CommentListItem {
        return CommentListItem(rawValue: "\(id).deleteButton")
    }
}
