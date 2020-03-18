//
//  GameProvider.swift
//  BizinGold
//
//  Created by Guilherme Araujo on 18/03/20.
//  Copyright © 2020 Guilherme Araujo. All rights reserved.
//

import Foundation

class GameProvider: GameService {
    
    
    var channel: Channel
    
    var metadata: Metadata
    
    init() {}

    
    var host: String = ""
    
    var timeout: TimeInterval = 0.0
    
    
    private(set) var scene: GameScene?
    private(set) var controller: GameViewController?
    
    func setScene(scene: GameScene) {
        self.scene = scene
    }
    
    func setController(controller: GameViewController) {
        self.controller = controller
    }
    
    
    func send(request: Message, messageSender: MessageSender, username: String ) throws -> Empty {
        DispatchQueue.main.async {
        let chat = self.controller?.chatRoom as! GameViewController
        let message = MessageToSend(message: request.content, messageSender: messageSender, username: username)
        chat.insertNewMessageCell(message)
            
        }
        return Empty()
    }
    

    
    

}
