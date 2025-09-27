//
//  tca_tutorialApp.swift
//  tca-tutorial
//
//  Created by Imam on 27/09/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct tca_tutorialApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            CounterView(store: tca_tutorialApp.store)
        }
    }
}
