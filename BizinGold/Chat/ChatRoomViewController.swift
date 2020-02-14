
import UIKit

class ChatRoomViewController: UIViewController {

  
//  let tableView = UITableView()
//  let messageInputBar = MessageInputView()
  let chatRoom = ChatRoom()
    
    let epicView = EpicView()
  
  var messages: [Message] = []
  
  var username = ""
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    chatRoom.delegate = self
    chatRoom.setupNetworkCommunication()
    chatRoom.joinChat(username: username)
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    self.view = epicView

    
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
    }
    
}

//MARK - Message Input Bar
extension ChatRoomViewController: MessageInputDelegate {
  func sendWasTapped(message: String) {
    chatRoom.send(message: message)
    print("Enviando")
    print(message)
  }
}

extension ChatRoomViewController: ChatRoomDelegate {
  func received(message: Message) {
    print("Receiving")
    print(message)
    insertNewMessageCell(message)
  }
  
  
}

extension ChatRoomViewController {

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
}
