//
//  BluetoothRepository.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//

import Combine
import CoreBluetooth
import Foundation

/// Contains all usefull information on a specific bluetooth device
struct BluetoothDeviceInfo: Identifiable {
    let id: UUID
    let rssi: NSNumber
    let deviceInfo: CBPeripheral
    let deviceAdvertisementData: [String: Any]
    let isConnectable: Bool
}

/// Main protocol
protocol BluetoothDeviceServicing {
    // MARK: - Central Service

    var currentNearbyDevices: CurrentValueSubject<[UUID: BluetoothDeviceInfo], Never> { get }
    var isCurrentlyScanning: CurrentValueSubject<Bool, Never> { get }

    func startScanning()
    func stopScanning()
    func connectToPeripheralDevice(with peripheralInfos: BluetoothDeviceInfo)
    func disconnectForPeripheralDevice()

    // MARK: - Peripheral

    var currentServices: CurrentValueSubject<[CBService], Never> { get }
    var currentCharactericstics: CurrentValueSubject<[CBUUID: [CBCharacteristic]], Never> { get }
}

final class BluetoothRepository: NSObject, BluetoothDeviceServicing {
    private var nearbyBluetoothDevices: [UUID: BluetoothDeviceInfo] = [:]
    private var deviceCharactericstics: [CBUUID: [CBCharacteristic]] = [:]
    private var centralManager: CBCentralManager!
    private var peripheralDevice: CBPeripheral?

    private(set) var isCurrentlyScanning = CurrentValueSubject<Bool, Never>(false)
    private(set) var currentNearbyDevices = CurrentValueSubject<[UUID: BluetoothDeviceInfo], Never>([:])
    private(set) var currentServices = CurrentValueSubject<[CBService], Never>([])
    private(set) var currentCharactericstics = CurrentValueSubject<[CBUUID: [CBCharacteristic]], Never>([:])

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        guard centralManager.state == .poweredOn, !centralManager.isScanning else {
            return
        }
        let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        isCurrentlyScanning.send(true)
        centralManager.scanForPeripherals(withServices: nil, options: options)
    }

    func stopScanning() {
        centralManager.stopScan()
        isCurrentlyScanning.send(false)
    }

    func connectToPeripheralDevice(with peripheralInfos: BluetoothDeviceInfo) {
        peripheralDevice = peripheralInfos.deviceInfo
        guard let newPeripheralDevice = peripheralDevice else {
            return
        }
        stopScanning()
        peripheralDevice?.delegate = self
        centralManager.connect(newPeripheralDevice)
    }

    func disconnectForPeripheralDevice() {
        guard let oldPeripheralDevice = peripheralDevice else {
            return
        }
        peripheralDevice = nil
        deviceCharactericstics = [:]
        currentServices.send([])
        currentCharactericstics.send([:])
        centralManager.cancelPeripheralConnection(oldPeripheralDevice)
    }
}

// MARK: - Bluetooth management

extension BluetoothRepository: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else {
            return
        }
        startScanning()
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        guard peripheral.name != nil else {
            return
        }
        let isConnectable = advertisementData["kCBAdvDataIsConnectable"] as? Bool ?? false
        nearbyBluetoothDevices[peripheral.identifier] = BluetoothDeviceInfo(id: peripheral.identifier,
                                                                            rssi: RSSI,
                                                                            deviceInfo: peripheral,
                                                                            deviceAdvertisementData: advertisementData,
                                                                            isConnectable: isConnectable)
        currentNearbyDevices.send(nearbyBluetoothDevices)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let currentPeripheral = peripheralDevice else {
            return
        }
        currentPeripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("Connected")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error?.localizedDescription ?? "Unknown")
    }
}

extension BluetoothRepository: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        currentServices.send(services)
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if error != nil {
            print("Error discovering Characteristics: \(error!.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else { return }
        deviceCharactericstics[service.uuid] = characteristics
        currentCharactericstics.send(deviceCharactericstics)
    }
}
