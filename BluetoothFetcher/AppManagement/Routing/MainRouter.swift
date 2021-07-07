//
//  MainRouter.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//

import Foundation
import SwiftUI
import SwiftUICombineToolBox

/// Type of pages in the routing system
enum PageType {
    case peripheralDetail
}

/// Params needed to acces and instanciate navigation flow
struct PageInfos {
    let type: PageType
    let data: Any?
}

/// Main routing protocol
protocol MainNavigation {
    func routeToPage(for destination: PageInfos) -> AnyView
}

extension MainNavigation {
    func routeToPage(for destination: PageInfos) -> AnyView {
        switch destination.type {
        case .peripheralDetail:
            guard let infos = destination.data as? BluetoothDeviceInfo else {
                return Text("Could not parse the peripheral Data").eraseToAnyView()
            }
            return DeviceDetailsView(deviceInfos: infos).eraseToAnyView()
        }
    }
}

/// Main router for navigation flow
final class MainRouter: MainNavigation {}
