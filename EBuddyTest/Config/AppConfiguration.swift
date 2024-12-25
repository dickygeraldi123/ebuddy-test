//
//  AppConfiguration.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import Combine

struct AppConfiguration {
    let baseURL: String
    let isMockEnabled: Bool

    static let staging = AppConfiguration(
        baseURL: "https://mock-staging.example.com",
        isMockEnabled: true
    )
    
    static let production = AppConfiguration(
        baseURL: "https://prod.example.com",
        isMockEnabled: false
    )
}

final class AppEnvironment: ObservableObject {
    @Published var configuration: AppConfiguration

    init() {
#if DEBUG
        self.configuration = .staging
#else
        self.configuration = .production
#endif
    }
}
