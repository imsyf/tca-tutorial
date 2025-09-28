//
//  CounterFeature.swift
//  tca-tutorial
//
//  Created by Imam on 27/09/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }
    
    enum CancelID {
        case timer
    }
    
    let decoder = JSONDecoder()
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    guard let url = URL(string: "https://fakestoreapi.com/products/\(count)") else { return }
                    
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let fact = try decoder.decode(Product.self, from: data)
                        await send(.factResponse(fact.title))
                    } catch {
                    }
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none

            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }.cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}

struct Product: Decodable {
    let title: String
}

struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            
            HStack {
                StyledButton(label: "-") {
                    store.send(.decrementButtonTapped)
                }
                
                StyledButton(label: "+") {
                    store.send(.incrementButtonTapped)
                }
            }
            
            StyledButton(label: "\(store.isTimerRunning ? "Stop" : "Start") timer") {
                store.send(.toggleTimerButtonTapped)
            }

            if store.count > 0 {
                StyledButton(label: "Fact") {
                    store.send(.factButtonTapped)
                }
            }
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}

struct StyledButton: View {
    let label: String
    let onTap: () -> Void

    var body: some View {
        Button(label) {
            onTap()
        }
        .font(.largeTitle)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}
