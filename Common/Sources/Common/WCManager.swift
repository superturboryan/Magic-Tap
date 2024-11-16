//
//  WCManager.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Combine
import WatchConnectivity

public final class WCManager: NSObject, ObservableObject {
    
    @Published public var isReachable = false
    
    private let session = WCSession.default
    private var cancellables: [AnyCancellable] = []

    public override init() {
        super.init()
        setupWCSession()
    }
    
    private func setupWCSession() {
        guard WCSession.isSupported() else {
            return
        }
        
        session.delegate = self
        session.activate()
    }

    func sendMessage(_ message: [String: Any]) {
        guard session.isReachable else {
            print("Session is not reachable")
            return
        }
        session.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
    }
}

private extension WCManager {
    
    func handleAction(_ action: String) {
        #if os(iOS)
        print("iOS received action: \(action)")
        #elseif os(watchOS)
        print("watchOS received action: \(action)")
        #endif
    }
}

extension WCManager: WCSessionDelegate {
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activated: \(activationState.rawValue)")
        
        session.publisher(for: \.isReachable)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReachable in
            self?.isReachable = isReachable
        }
        .store(in: &cancellables)
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Message received: \(message)")
        if let action = message["action"] as? String {
            self.handleAction(action)
        }
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        print("Reachability changed: \(session.isReachable)")
    }
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session inactive")
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("Session deactivated")
        session.activate() // Reactivate session if needed
    }
    #endif
}
