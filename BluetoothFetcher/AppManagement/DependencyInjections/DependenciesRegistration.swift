//
//  DependenciesRegistration.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the MVVM Xcode Templates
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerTools()
        registerRepositories()
        registerRouting()
        registerViewModels()
    }
}