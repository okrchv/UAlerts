// Generated by Create API
// https://github.com/CreateAPI/CreateAPI
//
// swiftlint:disable all

import Foundation

public struct WebHookModel: Codable {
    public var webHookURL: String?

    public init(webHookURL: String? = nil) {
        self.webHookURL = webHookURL
    }

    private enum CodingKeys: String, CodingKey {
        case webHookURL = "webHookUrl"
    }
}