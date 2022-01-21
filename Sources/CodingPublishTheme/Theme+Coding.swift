import Foundation
import Plot
import Publish

public extension Theme where Site: CodingWebsite {

    static var coding: Self {
        Theme(
            htmlFactory: CodingWebsiteHTMLFactory(),
            resourcePaths: ["Resources/theme/styles.css"]
        )
    }

}

private struct CodingWebsiteHTMLFactory<Site: CodingWebsite>: HTMLFactory {

    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site, googleAnalyticsID: context.site.googleAnalyticsID),
            .body {
                SiteHeader(context: context)
                Main {
                    ItemList(
                        context: context,
                        items: context.allItems(sortedBy: \.date, order: .descending),
                        site: context.site
                    )
                }
                SiteFooter(site: context.site)
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site, googleAnalyticsID: context.site.googleAnalyticsID),
            .body {
                SiteHeader(context: context, selectedSelectionID: section.id)
                Main {
                    H1(section.title)
                    ItemList(
                        context: context,
                        items: section.items,
                        site: context.site
                    )
                }
                SiteFooter(site: context.site)
            }
        )
    }

    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        let section = context.sections[item.sectionID]

        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site, googleAnalyticsID: context.site.googleAnalyticsID),
            .body {
                SiteHeader(context: context, selectedSelectionID: item.sectionID)
                Main {
                    Article {
                        Paragraph(section.title).class("item-eyebrow")
                        Paragraph(item.date, formatter: .dateOnly).class("item-date")
                        H1(item.title)
                        Div(item.content.body).class("content")
                    }
                }
                SiteFooter(site: context.site)
            }
        )
    }

    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site, googleAnalyticsID: context.site.googleAnalyticsID),
            .body {
                SiteHeader(context: context)
                Main(page.body)
                SiteFooter(site: context.site)
            }
        )
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }

}

private struct SiteHeader<Site: CodingWebsite>: Component {

    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID? = nil

    var body: Component {
        Header {
            if let imagePath = context.site.imagePath {
                Image(imagePath.absoluteString).class("logo")
            }

            Link(context.site.name, url: "/").class("site-name")

            if Site.SectionID.allCases.count > 1 {
                navigation
            }
        }
    }

    private var navigation: Component {
        Navigation {
            List(Site.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]

                return Link(section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSelectionID ? "selected" : "")
            }
        }
    }

}

private struct ItemList<Site: CodingWebsite>: Component {

    var context: PublishingContext<Site>
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            let section = context.sections[item.sectionID]

            return Article {
                Paragraph(section.title).class("item-eyebrow")
                Paragraph(item.date, formatter: .dateOnly).class("item-date")
                H1(Link(item.title, url: item.path.absoluteString))
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }

}

private struct SiteFooter<Site: CodingWebsite>: Component {

    var site: Site

    var body: Component {
        Footer {
            Paragraph {
                Text("Follow me on ")
                Link("Twitter", url: "https://twitter.com/\(site.twitterUsername)")
                Text(" or ")
                Link("GitHub", url: "https://github.com/\(site.gitHubUsername)")
                Text(".")
            }
            Paragraph {
                Text(site.author)
                Text(" © ")
                Text(Date(), formatter: .year)
                Text(". All rights reserved.")
            }
        }
    }

}
