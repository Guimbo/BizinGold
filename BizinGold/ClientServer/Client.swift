//
//  Client.swift
//  BizinGold
//
//  Created by Guilherme Araujo on 18/03/20.
//  Copyright © 2020 Guilherme Araujo. All rights reserved.
//

import Foundation
import SwiftGRPC
import SpriteKit

class Client {
    static let shared = Client()
    
    private(set) var client: GameServiceClient?
    
    var changed = false
    
    var clientExists: Bool {
        return client != nil
    }
    
    private init() {}
    
    
    func connect(address: String, port: String, completion: @escaping () -> Void) {
        client = GameServiceClient.init(address: "\(address):\(port)", secure: false, arguments: [])
        completion()
    }
    
    func sendMessageToAnotherPlayer(content:
        String, sender: MessageSender, username: String){
        var message = MessageToSend(message: content, messageSender: sender, username: username)
        do {
            try client?.send(message, completion: {(_,_) in })
        } catch {
            print("Deu ruim")
        }
    }
    


}
