import Foundation
import Observation


extension ObservationTrackingVC {
    final class ViewModel {
        var data: [[Item]] = [
            [
                Item(title: "first", imageName: "square.and.arrow.up", bgColor: .blue),
            ],
            [
                Item(title: "second", imageName: "square.and.arrow.up", bgColor: .green),
                Item(title: "second", imageName: "square.and.arrow.up", bgColor: .green),
            ],
            [
                Item(title: "third", imageName: "square.and.arrow.up", bgColor: .pink),
                Item(title: "third", imageName: "square.and.arrow.up", bgColor: .pink),
                Item(title: "third", imageName: "square.and.arrow.up", bgColor: .pink),
            ]
        ]
    }
}
