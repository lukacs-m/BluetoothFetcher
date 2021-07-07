//
//  BluetoothFetcherApp.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//

import SwiftUI
import SwiftUICombineToolBox

@main
struct BluetoothFetcherApp: App {
    var body: some Scene {
        WindowGroup {
            DevicesListView().embedInNavigation()
        }
    }
}
