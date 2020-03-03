//
//  GameViewController.swift
//  BizinGold
//
//  Created by Guilherme Araujo on 12/02/20.
//  Copyright © 2020 Guilherme Araujo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let chatRoom = ChatRoom.shared
    let epicView = EpicView()
    var messages: [Message] = []
    var username = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        chatRoom.delegate = self
        chatRoom.setupNetworkCommunication()
        chatRoom.joinChat(username: username)
        self.view.addSubview(epicView)
        self.configEpicView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatRoom.stopChatSession()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        epicView.tableView.dataSource = self
        epicView.tableView.delegate = self
        epicView.messageInputBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.view = SKView(frame: self.view.frame)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configEpicView(){
        self.epicView.snp.makeConstraints{ make in
            make.height.equalToSuperview()
            make.width.equalTo(300)
            make.left.bottom.top.equalToSuperview()
        }
    }
    
}

//MARK - Message Input Bar
extension GameViewController: MessageInputDelegate {
  func sendWasTapped(message: String) {
    chatRoom.send(message: message)
    print("Enviando")
    print(message)
  }
}

extension GameViewController: ChatRoomDelegate {
    func received(message: Message) {
        print("Receiving")
        print(message)
        insertNewMessageCell(message)
        checkGiveUp(message: message)
      }
    
    func checkGiveUp(message: Message){
        if message.message == "DESISTO" {
    
            self.alert_one_option(titleAlert: "FIM DE JOGO", messageAlert: "Ocorrreu uma desistência na partida. A partida está encerrada.", buttonDismiss: "OK")
            
        }
    }
    


}

extension GameViewController {

  @objc func keyboardWillChange(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        let messageBarHeight = epicView.messageInputBar.bounds.size.height
      let point = CGPoint(x: epicView.messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0)
      let inset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.size.height, right: 0)
      UIView.animate(withDuration: 0.25) {
        self.epicView.messageInputBar.center = point
        self.epicView.tableView.contentInset = inset
      }
    }
  }

  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let messageBarHeight:CGFloat = 60.0
    let size = epicView.bounds.size
    epicView.tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height - messageBarHeight - epicView.safeAreaInsets.bottom)
    epicView.messageInputBar.frame = CGRect(x: 0, y: size.height - messageBarHeight - self.view.safeAreaInsets.bottom, width: size.width, height: messageBarHeight)
  }
    
    func alert_one_option(titleAlert: String, messageAlert: String, buttonDismiss: String){
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: buttonDismiss, style: .cancel) {
               UIAlertAction in
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension GameViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
    cell.selectionStyle = .none
    
    let message = messages[indexPath.row]
    cell.apply(message: message)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height = MessageTableViewCell.height(for: messages[indexPath.row], maxSizeOfView: Float(self.view.bounds.width))
    return height
  }
  
  func insertNewMessageCell(_ message: Message) {
    messages.append(message)
    let indexPath = IndexPath(row: messages.count - 1, section: 0)
    epicView.tableView.beginUpdates()
    epicView.tableView.insertRows(at: [indexPath], with: .bottom)
    epicView.tableView.endUpdates()
    epicView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
  }
}


