//
//  RedactionShimmeringModifier.swift
//  TripWise
//
//  Created by Edoardo Pavan on 28/01/25.
//

import Foundation
import Shimmer
import SwiftUI

struct RedactionShimmeringModifier: ViewModifier {
    let redacted: Bool

    func body(content: Content) -> some View {
        if !redacted {
            content
        } else {
            content
                .disabled(true)
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
}

extension View {
    @ViewBuilder
    func redactAndShimmer(active: Bool = true) -> some View {
        if active {
            modifier(RedactionShimmeringModifier(redacted: active))
        } else {
            self
        }
    }
}
