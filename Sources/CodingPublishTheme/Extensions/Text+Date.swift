import Foundation
import Plot

extension Text {

    init(_ date: Date, formatter: DateFormatter) {
        self.init(formatter.string(from: date))
    }

}
