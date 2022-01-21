import Foundation
import Publish

public protocol CodingWebsite: Website {

    var author: String { get }
    var twitterUsername: String { get }
    var gitHubUsername: String { get }
    var googleAnalyticsID: String? { get }

}
