import Foundation
import Plot
import Publish

extension Theme where Site == SwiftWithAdamBlog {

    static var swiftWithAdamBlog: Self {
        Theme(
            htmlFactory: SwiftWithAdamBlogHTMLFactory(),
            resourcePaths: ["Resources/theme/styles.css"]
        )
    }

}

private struct SwiftWithAdamBlogHTMLFactory: HTMLFactory {

    func makeIndexHTML(for index: Index, context: PublishingContext<SwiftWithAdamBlog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                SiteMain {
                    ItemList(
                        context: context,
                        items: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<SwiftWithAdamBlog>,
                         context: PublishingContext<SwiftWithAdamBlog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: section.id)
                SiteMain {
                    H1(section.title)
                    ItemList(context: context, items: section.items, site: context.site)
                }
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<SwiftWithAdamBlog>, context: PublishingContext<SwiftWithAdamBlog>) throws -> HTML {
        let section = context.sections[item.sectionID]

        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    SiteHeader(context: context, selectedSelectionID: item.sectionID)
                    SiteMain {
                        Article {
                            Paragraph(section.title).class("item-eyebrow")
                            Paragraph(DateFormatter.dateOnly.string(from: item.date)).class("item-date")
                            H1(item.title)
                            Div(item.content.body).class("content")
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page, context: PublishingContext<SwiftWithAdamBlog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                SiteMain(page.body)
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<SwiftWithAdamBlog>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                SiteMain {
                    H1("Browse all tags")
                    List(page.tags.sorted()) { tag in
                        ListItem {
                            Link(tag.string,
                                 url: context.site.path(for: tag).absoluteString
                            )
                        }
                        .class("tag")
                    }
                    .class("all-tags")
                }
                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<SwiftWithAdamBlog>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                SiteMain {
                    H1 {
                        Text("Tagged with ")
                        Span(page.tag.string).class("tag")
                    }

                    Link("Browse all tags",
                        url: context.site.tagListPath.absoluteString
                    )
                    .class("browse-all")

                    ItemList(
                        context: context,
                        items: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
    }
}

private struct SiteHeader: Component {

    var context: PublishingContext<SwiftWithAdamBlog>
    var selectedSelectionID: SwiftWithAdamBlog.SectionID?

    var body: Component {
        Header {
            Image(URL(string: "/images/swift_logo.svg")!).class("logo")
            Link(context.site.name, url: "/").class("site-name")

            if SwiftWithAdamBlog.SectionID.allCases.count > 1 {
                navigation
            }
        }
    }

    private var navigation: Component {
        Navigation {
            List(SwiftWithAdamBlog.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]

                return Link(section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSelectionID ? "selected" : "")
            }
        }
    }

}

private struct SiteMain: ComponentContainer {

    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Element(name: "main", content: content)
    }

}

private struct ItemList: Component {

    var context: PublishingContext<SwiftWithAdamBlog>
    var items: [Item<SwiftWithAdamBlog>]
    var site: SwiftWithAdamBlog

    var body: Component {
        List(items) { item in
            let section = context.sections[item.sectionID]

            return Article {
                Paragraph(section.title).class("item-eyebrow")
                Paragraph(DateFormatter.dateOnly.string(from: item.date)).class("item-date")
                H1(Link(item.title, url: item.path.absoluteString))
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }

}

private struct SiteFooter: Component {

    var body: Component {
        Footer {
            Paragraph {
                Text("Follow me on ")
                Link("Twitter", url: "https://twitter.com/adamayoung")
                Text(" or ")
                Link("GitHub", url: "https://github.com/adamayoung")
                Text(".")
            }
            Paragraph("Adam Young © \(DateFormatter.year.string(from: Date())). All rights reserved.")
        }
    }

}

extension DateFormatter {

    static var dateOnly: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }

    static var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }

}
