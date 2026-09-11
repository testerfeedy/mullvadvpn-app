// This Source Code Form is subject to the terms of the GPLv3 License.
// You can obtain a copy of the license at https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This file incorporates work covered by the following copyright and
// permission notice:
//
//   Copyright (c) Mullvad VPN AB. All rights reserved.
//
// SPDX-License-Identifier: GPL-3.0-only

import SwiftUI

// this is necessart because .move(edge. .top) propagates down to subsidiary views and
// contaminates their own transitions.

// IOS16-PATCH: TransitionPhase and visualEffect are iOS 17 APIs.
private struct TopSlideModifier: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content.offset(y: isActive ? -proxy.size.height : 0)
        }
    }
}

extension AnyTransition {
    public static var topSlide: AnyTransition {
        .modifier(
            active: TopSlideModifier(isActive: true),
            identity: TopSlideModifier(isActive: false)
        )
    }
}
