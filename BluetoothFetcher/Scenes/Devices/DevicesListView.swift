//
//  DevicesListView.swift
//  BluetoothFetcher
//
//  Created by Martin Lukacs on 05/07/2021.
//  Copyright (c) 2021 Martin. All rights reserved.
//
//  This file was generated by the MVVM Xcode Templates
//

import Resolver
import SwiftUI
import SwiftUICombineToolBox

struct DevicesListView: View {
    @InjectedObject private var viewModel: DevicesListViewModel
    @Injected private var router: MainNavigation

    var body: some View {
        containerView
            .onAppear {
                guard !viewModel.isCurrentlyScanning else {
                    return
                }
                viewModel.startScanningForDevices()
            }
            .navigationTitle("Nearby Bluetooth Devices")
    }
}

private extension DevicesListView {
    var containerView: some View {
        Group {
            if viewModel.devices.isEmpty {
                emptyView
            } else {
                deviceListingView
            }
        }
    }
}

private extension DevicesListView {
    var emptyView: some View {
        HStack {
            Spacer()
            Text("No bluetooth device found yet. Scanning for devices is in process")
                .font(.subheadline)
                .lineLimit(2)
                .padding()
            Spacer()
        }
    }
}

private extension DevicesListView {
    var deviceListingView: some View {
        List {
            ForEach(viewModel.devices) { device in
                NavigationLink(destination: LazyView(router.routeToPage(for: PageInfos(type: .peripheralDetail, data: device)))) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(device.deviceInfo.name ?? "")
                        Text("Current RSSI: \(device.rssi)")
                    }.padding()
                }.buttonStyle(PlainButtonStyle())
                    .listRowInsets(EdgeInsets())
            }
        }
    }
}

struct DevicesListView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesListView()
    }
}