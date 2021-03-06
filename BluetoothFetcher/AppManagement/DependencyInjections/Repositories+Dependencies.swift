//
//  Repositories+Dependencies.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the MVVM Xcode Templates
//

import Resolver

public extension Resolver {
    static func registerRepositories() {
        register { BluetoothRepository() as BluetoothDeviceServicing }.scope(.application)
    }
}
