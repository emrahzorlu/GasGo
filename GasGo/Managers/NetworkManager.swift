//
//  NetworkManager.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//

import Foundation
import Network

final class NetworkManager {
  static let shared = NetworkManager()
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue.global(qos: .background)
  private var isMonitoring = false

  private var _isConnected: Bool = false
  var isConnectedToInternet: Bool {
    return _isConnected
  }

  private init() {
    startMonitoring()
  }

  private func startMonitoring() {
    guard !isMonitoring else { return }
    monitor.pathUpdateHandler = { [weak self] path in
      self?._isConnected = path.status == .satisfied
    }
    monitor.start(queue: queue)
    isMonitoring = true
  }
}
