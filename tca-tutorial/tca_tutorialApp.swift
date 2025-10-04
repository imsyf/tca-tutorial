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
    static let store = Store(
        initialState: ContactsFeature.State(
            contacts: [
                Contact(id: UUID(), name: "Contact 1"),
                Contact(id: UUID(), name: "Contact 2"),
                Contact(id: UUID(), name: "Contact 3"),
            ]
        )
    ) {
        ContactsFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            ContactsView(store: tca_tutorialApp.store)
        }
    }
}
