import Foundation
import Plot
import Publish
import SplashPublishPlugin

try SwiftWithAdamBlog().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .swiftWithAdamBlog),
    .generateRSSFeed(including: [.swift, .tooling]),
    .generateSiteMap()
])
