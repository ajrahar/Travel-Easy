import SwiftUI

enum Layout {
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let splash: CGFloat = 28
    }

    enum Spacing {
        static let tight: CGFloat = 4
        static let compact: CGFloat = 8
        static let normal: CGFloat = 12
        static let relaxed: CGFloat = 16
        static let section: CGFloat = 24
    }

    enum Auth {
        static let fieldHeight: CGFloat = 48
        static let iconSize: CGFloat = 64
    }

    enum Image {
        static let rowSize: CGFloat = 64
        static let carouselHeight: CGFloat = 200
        static let carouselContainerHeight: CGFloat = 220
        static let detailHeight: CGFloat = 240
    }
}
