//
//  Resolver+TestExtensions.swift
//  BluetoothFetcherTests
//
//  Created by Martin Lukacs on 07/07/2021.
//

import Resolver
@testable import BluetoothFetcher

extension Resolver {
    
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(parent: .main)
        Resolver.root = .test
    }
}
