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
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    public override init() {
        super.init()
        setupWCSession()
    }
    
    public func sendAction(_ action: Action) {
        let encodedAction = (try? encoder.encode(action)) ?? Data()
        sendMessage([
            Action.key : encodedAction
        ])
    }
}

private extension WCManager {
    
    func setupWCSession() {
        guard WCSession.isSupported() else {
            return
        }
        session.delegate = self
        session.activate()
    }
    
    func sendMessage(_ message: [String: any Codable]) {
        guard session.isReachable else {
            print("Session is not reachable")
            return
        }
        session.sendMessage(
            message,
            replyHandler: nil,
            errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        )
    }
        
    func postNotification(for action: Action) {
        NotificationCenter.default.postFromMainThread(
            name: Action.key.notification,
            object: nil,
            userInfo: [
                Action.key : action
            ]
        )
    }
}

extension WCManager: WCSessionDelegate {
    
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("Session activated: \(activationState.rawValue)")
        
        session.publisher(for: \.isReachable)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReachable in
            self?.isReachable = isReachable
        }
        .store(in: &cancellables)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        print("Message received: \(message)")
        guard
            let actionData = message[Action.key] as? Data,
            let action = try? decoder.decode(Action.self, from: actionData)
        else {
            return
        }
        postNotification(for: action)
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

extension NotificationCenter {
    
    func postFromMainThread(
        name: Notification.Name,
        object: (any Sendable)?,
        userInfo: [String : any (Sendable & Codable)]
    ) {
        DispatchQueue.main.async { [object, userInfo] in
            NotificationCenter.default.post(
                name: name,
                object: object,
                userInfo: userInfo
            )
        }
    }
}
