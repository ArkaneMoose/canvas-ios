//
// Copyright (C) 2019-present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import CoreData

public class Module: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var position: Int
    @NSManaged public var courseID: String
    @NSManaged public var published: Bool

    @discardableResult
    public static func save(_ items: [APIModule], forCourse courseID: String, in context: PersistenceClient) -> [Module] {
        return items.map { save($0, forCourse: courseID, in: context) }
    }

    @discardableResult
    public static func save(_ item: APIModule, forCourse courseID: String, in context: PersistenceClient) -> Module {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Module.id), item.id.value)
        let module: Module = context.fetch(predicate).first ?? context.insert()
        module.id = item.id.value
        module.courseID = courseID
        module.name = item.name
        module.position = item.position
        module.published = item.published
        return module
    }
}
