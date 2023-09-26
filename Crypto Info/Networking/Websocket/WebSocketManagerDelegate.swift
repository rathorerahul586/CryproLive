//
//  WebSocketManagerDelegate.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 25/09/23.
//

import Foundation

protocol WebSocketManagerDelegate: AnyObject {
    func didReceiveMessage(_ message: String)
}
