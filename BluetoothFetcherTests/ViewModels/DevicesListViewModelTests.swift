//
//  BluetoothRepositoryTests.swift
//  BluetoothFetcherTests
//
//  Created by Martin Lukacs on 07/07/2021.
//

import XCTest
import Resolver
import Combine
import CoreBluetooth
@testable import BluetoothFetcher

class DevicesListViewModelTests: XCTestCase {
    var subjectToTest: DevicesListViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        Resolver.resetUnitTestRegistrations()
        Resolver.test.register { BluetoothDeviceRepositoryMock() as BluetoothDeviceServicing }
            .implements(BluetoothDeviceRepositoryTestings.self)
            .scope(.shared)
        subjectToTest = DevicesListViewModel()
        cancellables = []
    }

    func testIsCurrentlyScanningLinkToRepository() throws {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            XCTAssertTrue(self.subjectToTest.isCurrentlyScanning)
        }
    }
    
    func testThatViewModelsCallsStartScanning() throws {
        subjectToTest.startScanningForDevices()
        let bluetoothRepository: BluetoothDeviceServicing = Resolver.test.resolve()
        guard let mock = bluetoothRepository as? BluetoothDeviceRepositoryTestings else {
            return XCTFail("Should be a mock class")
        }
        XCTAssertTrue(mock.startScanningCalled)
    }
}
