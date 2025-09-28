//
//  CounterFeatureTests.swift
//  CounterFeatureTests
//
//  Created by Imam on 28/09/25.
//

import ComposableArchitecture
import Testing

@testable import tca_tutorial

@MainActor
struct CounterFeatureTests {

    @Test func basics() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
