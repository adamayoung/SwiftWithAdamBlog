import CodingPublishTheme
import Foundation
import Plot
import Publish

struct SwiftWithAdamBlog: CodingWebsite {

    enum SectionID: String, WebsiteSectionID {
        case swift
        case architecture
        case tooling
    }

    struct ItemMetadata: WebsiteItemMetadata { }

    let url = URL(string: "https://swiftwithadam.com")!
    let name = "Swift with Adam"
    let author = "Adam Young"
    let description = "Articles on everything you need to know about Swift"
    let language = Language.english
    let imagePath: Path? = Path("/images/swift_logo.svg")
    let twitterUsername = "adamayoung"
    let gitHubUsername = "adamayoung"
    let googleAnalyticsID: String? = "G-VJ2DFPZ6Z9"

}
