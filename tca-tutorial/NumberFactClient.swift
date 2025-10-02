//
//  NumberFactClient.swift
//  tca-tutorial
//
//  Created by Imam on 29/09/25.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

struct Product: Decodable {
    let title: String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fetch: { number in
            let decoder = JSONDecoder()
            let (data, _) = try await URLSession.shared.data(
                from: URL(string: "https://fakestoreapi.com/products/\(number)")!
            )
            let fact = try decoder.decode(Product.self, from: data)
            return fact.title
        }
    )
    
    static let testValue = Self(
        fetch: { "\($0) is a good number." }
    )
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
