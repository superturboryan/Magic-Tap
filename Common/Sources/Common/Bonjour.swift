//
//  Bonjour.swift
//  Common
//
//  Created by Ryan on 2024-11-20.
//

import Network
import SwiftUI

public class BonjourServiceBrowser {
    
    private var browser: NWBrowser?
    private var connection: NWConnection?
    
    public init() {}

    public func startBrowsing() {
        let bonjourServiceName = "_ssh._tcp"
        browser = NWBrowser(for: .bonjour(type: bonjourServiceName, domain: nil), using: .tcp)
        browser?.stateUpdateHandler = { state in
            print("Browser state changed: \(state)")
        }
        browser?.browseResultsChangedHandler = { results, _  in
            for result in results {
                if case let .service(name, _, _, _) = result.endpoint {
                    print("Found service: \(name)")
                    if name == "MyAppService" {
                        self.connect(to: result)
                        break
                    }
                }
            }
        }

        browser?.start(queue: .main)
    }

    private func connect(to result: NWBrowser.Result) {
        connection = NWConnection(to: result.endpoint, using: .tcp)
        connection?.stateUpdateHandler = { state in
            print("Connection state changed: \(state)")
        }
        connection?.start(queue: .global())
        sendMessage("Hello from iOS!")
    }

    public func sendMessage(_ message: String) {
        guard let connection = connection else { return }
        let data = message.data(using: .utf8) ?? Data()
        connection.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("Send failed: \(error)")
            } else {
                print("Message sent")
            }
        }))
    }
}

@MainActor
public class BonjourServiceAdvertiser: ObservableObject {
    
    private var listener: NWListener?
    private var connection: NWConnection?
    
    @Published public var messages: [String] = []
    
    @Published public var isAdvertising = false
    @Published public var isConnected = false
    
    public init() {}

    public func startAdvertising() {
        do {
            isAdvertising = true
            listener = try NWListener(using: .tcp, on: 12345) // Port 12345
            listener?.service = NWListener.Service(name: "MyAppService", type: "_ssh._tcp")
            listener?.stateUpdateHandler = { state in
                state.self
                print("Listener state changed: \(state)")
            }
            listener?.newConnectionHandler = { @MainActor [weak self] connection in
                print("New connection established")
                
                self?.connection = connection
                connection.start(queue: .global())
                
                DispatchQueue.main.async {
                    self?.isAdvertising = false
                    self?.isConnected = true
                }
                
                self?.receiveMessages(on: connection)
            }
            listener?.start(queue: .global())
            print("Service advertised as '_ssh._tcp'")
        } catch {
            print("Failed to start listener: \(error)")
        }
    }
    
    public func stopAdvertising() {
        listener?.cancel()
        listener = nil
    }

    private func receiveMessages(on connection: NWConnection) {
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { [weak self] data, contentContext, isComplete, error in

            if let data = data, let message = String(data: data, encoding: .utf8) {
                print("Received message: \(message)")
                DispatchQueue.main.async {
                    self?.messages.append(message)
                }
            }
            
            if isComplete {
                print("Connection closed by client.")
                self?.isConnected = false
            } else {
                // Keep listening for more messages
                self?.receiveMessages(on: connection)
            }
        }
    }
}

