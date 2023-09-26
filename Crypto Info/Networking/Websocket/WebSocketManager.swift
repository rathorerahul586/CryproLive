//
//  WebSocketManager.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 25/09/23.
//

import Foundation

class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    weak var delegate: WebSocketManagerDelegate?

    init(url: URL) {
        super.init()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveData()
    }

    func sendText(_ text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
    }

    func receiveData() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.delegate?.didReceiveMessage(text)
                default:
                    break
                }
                self?.receiveData()
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            }
        }
    }
}
