import SwiftUI

@MainActor
extension CoordinateSpace {
    // IOS16-PATCH: NamedCoordinateSpace and .coordinateSpace(_:) are iOS 17 APIs.
    static let multihopSelection: CoordinateSpace = .named("mullvad.multihopSelection")
    static let exitLocationScroll: CoordinateSpace = .named("mullvad.exitLocationScroll")
}
