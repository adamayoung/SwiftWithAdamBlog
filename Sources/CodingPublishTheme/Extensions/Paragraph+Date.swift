import Foundation
import Plot

extension Paragraph {

    init(_ date: Date, formatter: DateFormatter) {
        self.init(formatter.string(from: date))
    }

}
