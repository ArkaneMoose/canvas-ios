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
import SoSeedySwift
@testable import Core

public struct RecordableAPI: API {
    var baseURL: URL {
        let url = Keychain.currentSession?.baseURL ?? "https://canvas.instructure.com/"
        return URL(string: url)!
    }
    var accessToken: String {
        return Keychain.currentSession?.token ?? ""
    }

    private static var defaultUrlSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        return configuration
    }

    var urlSession: URLSession = URLSession(configuration: RecordableAPI.defaultUrlSessionConfiguration)

    public init(urlSession: URLSession? = nil) {
        if let session = urlSession {
            self.urlSession = session
        }

    }

    @discardableResult
    public func makeRequest<R: APIRequestable>(_ requestable: R, callback: @escaping (R.Response?, URLResponse?, Error?) -> Void) -> URLSessionTask? {
        do {
            let request: URLRequest = try requestable.urlRequest(relativeTo: baseURL, accessToken: accessToken)
            let absoluteURL: String = request.url!.absoluteString
            let response = VCR.shared.response(for: absoluteURL)
            if (response != nil) {
                let data = response!.data(using: .utf8)!
                do {
                    callback(try requestable.decode(data), nil, nil)
                } catch {
                    callback(nil, nil, error)
                }
                return nil
            }

            let task = urlSession.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return callback(nil, response, error)
                }
                let stringResponse = String(data: data, encoding: .utf8)!
                VCR.shared.recordResponse(stringResponse, for: absoluteURL)
                do {
                    callback(try requestable.decode(data), response, error)
                } catch let error {
                    callback(nil, response, error)
                }
            }
            task.resume()
            return task
        } catch {
            callback(nil, nil, error)
            return nil
        }
    }
}
