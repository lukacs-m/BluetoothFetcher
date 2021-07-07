//
//  ServiceAndCharsTile.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//

import CoreBluetooth
import SwiftUI

struct ServiceAndCharsTile: View {
    let service: CBService
    let characteristics: [CBCharacteristic]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Service")
                .font(.headline)
                .fontWeight(.bold)
            Text("Service UUID: \(service.uuid)")
            Text("Service Is primary: \(service.isPrimary ? "true" : "false")")
            Divider()
            Text("Services Characteristics")
                .font(.headline)
                .fontWeight(.bold)
            ForEach(characteristics, id: \.uuid) { characteristic in
                VStack(alignment: .leading, spacing: 5) {
                    Text("UUID: \(characteristic.uuid)")
                    Text("Properties: \(characteristic.getProperties().joined(separator: ","))")
                }.padding(0)
            }.padding(0)
        }.padding(2)
    }
}

// struct ServiceAndCharsTile_Previews: PreviewProvider {
//    static var previews: some View {
//        ServiceAndCharsTile(service: <#CBService#>, characteristics: <#[CBCharacteristic]#>)
//    }
// }
