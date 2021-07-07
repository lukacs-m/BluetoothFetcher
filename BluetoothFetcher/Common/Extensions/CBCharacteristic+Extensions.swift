//
//  CBCharacteristic+Extensions.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//

import CoreBluetooth

extension CBCharacteristic {
    func getProperties() -> [String] {
        var properties: [String] = []
        switch self.properties {
        case let str where str.contains(.read):
            properties.append("Read")
        case let str where str.contains(.write):
            properties.append("Write")
        case let str where str.contains(.notify):
            properties.append("Notify")
        case let str where str.contains(.broadcast):
            properties.append("Broadcast")
        default:
            break
        }
        return properties
    }
}
