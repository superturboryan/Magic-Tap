//
//  WCManager.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Combine
import SwiftUI
import WatchConnectivity

public enum MessageKeys {
    public static let perform = "Perform"
    public static let select = "Select"
}

public final class WCManager: NSObject, ObservableObject {
    
    @Published public var isReachable = false
    
    private let session = WCSession.default
    private var cancellables: [AnyCancellable] = []
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    
    public var cachedAction: Action = .none
    
    var performActionPayload: [String: any Codable] {
        [MessageKeys.perform : encode(cachedAction)]
    }
    
    var selectActionPayload: [String: any Codable] {
        [MessageKeys.select : encode(cachedAction)]
    }
    
    public override init() {
        super.init()
        setupWCSession()
    }
    
    public func sendAction(_ action: Action) {
        cachedAction = action
        sendMessage(performActionPayload)
    }
    
    public func updateSelectedAction(_ action: Action) {
        cachedAction = action
        sendMessage(selectActionPayload)
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
    
    func postNotification(named: String, for action: Action) {
        NotificationCenter.default.postFromMainThread(
            name: named.notification,
            object: nil,
            userInfo: [
                named : action
            ]
        )
    }
    
    func encode(_ action: Action) -> Data {
        (try? encoder.encode(action)) ?? Data()
    }
    
    func decode(_ data: Data) -> Action {
        (try? decoder.decode(Action.self, from: data)) ?? .none
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
        
        updateSelectedAction(cachedAction)
    }
    
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        print("Message received: \(message)")
        
        if let actionToPerformData = message[MessageKeys.perform] as? Data {
            postNotification(named:MessageKeys.perform, for: decode(actionToPerformData))
        }
        
        if let selectedActionData = message[MessageKeys.select] as? Data {
            postNotification(named: MessageKeys.select, for: decode(selectedActionData))
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

private extension NotificationCenter {
    
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

public extension String {
    
    var notification: Notification.Name { .init(self) }
}
