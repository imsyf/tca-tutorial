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
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: tca_tutorialApp.store)
        }
    }
}
