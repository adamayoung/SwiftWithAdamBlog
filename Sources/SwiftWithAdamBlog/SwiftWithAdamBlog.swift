import Foundation
import Plot
import Publish

struct SwiftWithAdamBlog: Website {

    enum SectionID: String, WebsiteSectionID {
        case swift
        case tooling
    }

    struct ItemMetadata: WebsiteItemMetadata { }

    var url = URL(string: "https://swiftwithadam.com")!
    var name = "Swift with Adam"
    var description = "Articles on everything you need to know about Swift"
    var language: Language { .english }
    var imagePath: Path? { Path("/images/swift_logo.svg") }
    var favicon: Favicon? { Favicon(path: "/images/swift_logo.svg", type: "image/svg+xml") }

}
