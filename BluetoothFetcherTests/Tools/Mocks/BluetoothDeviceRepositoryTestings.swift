//
//  BluetoothDeviceRepositoryTestings.swift
//  BluetoothFetcherTests
//
//  Created by Martin Lukacs on 07/07/2021.
//

import Foundation
import CoreBluetooth
import Combine
@testable import BluetoothFetcher

protocol BluetoothDeviceRepositoryTestings {
    var startScanningCalled: Bool { get }
    var stopScanningCalled: Bool { get }
    var connectToPeripheralDeviceCalled: Bool { get }
    var disconnectForPeripheralDeviceCalled: Bool { get }
}

final class BluetoothDeviceRepositoryMock: BluetoothDeviceServicing, BluetoothDeviceRepositoryTestings {
    var currentNearbyDevices: CurrentValueSubject<[UUID: BluetoothDeviceInfo], Never> = .init([:])
    var isCurrentlyScanning: CurrentValueSubject<Bool, Never> = .init(true)
    var currentServices: CurrentValueSubject<[CBService], Never> = .init([])
    var currentCharactericstics: CurrentValueSubject<[CBUUID: [CBCharacteristic]], Never> = .init([:])
    var startScanningCalled: Bool = false
    var stopScanningCalled: Bool = false
    var connectToPeripheralDeviceCalled: Bool = false
    var disconnectForPeripheralDeviceCalled: Bool = false
    
    func startScanning() {
        startScanningCalled = true
    }
    
    func stopScanning() {
        stopScanningCalled = true
    }
    
    func connectToPeripheralDevice(with peripheralInfos: BluetoothDeviceInfo) {
        connectToPeripheralDeviceCalled = true
    }
    
    func disconnectForPeripheralDevice() {
        disconnectForPeripheralDeviceCalled = true
    }
}
