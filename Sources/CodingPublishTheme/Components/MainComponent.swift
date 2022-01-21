import Foundation
import Plot

extension ElementDefinitions {

    /// Definition for the `<main>` element.
    public enum Main: ElementDefinition { public static var wrapper = Node.main }

}

/// A container component that's rendered using the `<h1>` element.
typealias Main = ElementComponent<ElementDefinitions.Main>
