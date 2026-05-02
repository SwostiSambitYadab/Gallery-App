//
//  NetworkMonitor.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import Foundation
import Network


final class NetworkMonitor {
    var isConnected: Bool?
    var connectionType: NWInterface.InterfaceType?
    static let shared = NetworkMonitor()
    
    private init() {
        startMonitoring()
    }
    
    /// - Monitor properties
    private var queue = DispatchQueue(label: "monitor_network")
    private var monitor = NWPathMonitor()
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                print("Netowrk connected: ", path.status == .satisfied)
                let types: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet, .loopback]
                if let type = types.first(where: { path.usesInterfaceType($0) }) {
                    self.connectionType = type
                    print("Network connection type: ", type)
                } else {
                    self.connectionType = nil
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
}
