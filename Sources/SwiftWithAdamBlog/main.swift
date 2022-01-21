import CodingPublishTheme
import Foundation
import Plot
import Publish
import SplashPublishPlugin

try SwiftWithAdamBlog().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .coding),
    .generateRSSFeed(including: [.swift, .tooling]),
    .generateSiteMap()
])
