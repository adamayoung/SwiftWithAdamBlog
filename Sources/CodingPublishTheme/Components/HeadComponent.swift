import Foundation
import Publish
import Plot

public extension Node where Context == HTML.DocumentContext {

    static func head<T: Website>(
        for location: Location,
        on site: T,
        titleSeparator: String = " | ",
        stylesheetPaths: [Path] = ["/styles.css"],
        rssFeedPath: Path? = .defaultForRSSFeed,
        rssFeedTitle: String? = nil,
        googleAnalyticsID: String?
    ) -> Node {
        var title = location.title

        if title.isEmpty {
            title = site.name
        } else {
            title.append(titleSeparator + site.name)
        }

        var description = location.description

        if description.isEmpty {
            description = site.description
        }

        return .head(
            .unwrap(googleAnalyticsID) { googleAnalyticsID in
                .googleAnalyticsScript(googleAnalyticsID)
            },
            .unwrap(googleAnalyticsID) { googleAnalyticsID in
                .googleAnalyticsSetup(googleAnalyticsID)
            },
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .forEach(stylesheetPaths, { .stylesheet($0) }),
            .viewport(.accordingToDevice),
            .unwrap(site.favicon, { .favicon($0) }),
            .unwrap(rssFeedPath, { path in
                let title = rssFeedTitle ?? "Subscribe to \(site.name)"
                return .rssFeedLink(path.absoluteString, title: title)
            }),
            .unwrap(location.imagePath ?? site.imagePath, { path in
                let url = site.url(for: path)
                return .socialImageLink(url)
            })
        )
    }

}

public extension Node where Context == HTML.HeadContext {

    static func googleAnalyticsScript(_ googleTrackingID: String) -> Node {
        .script(
            .async(),
            .src("https://www.googletagmanager.com/gtag/js?id=\(googleTrackingID)")
        )
    }

    static func googleAnalyticsSetup(_ googleTrackingID: String) -> Node {
        .script(
            .text(
            """
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());

            gtag('config', '\(googleTrackingID)');
            """
            ))
    }

}
