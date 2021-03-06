//
//import UIKit
//
//extension GameViewController: UITableViewDataSource, UITableViewDelegate {
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
//    cell.selectionStyle = .none
//    
//    let message = messages[indexPath.row]
//    cell.apply(message: message)
//    
//    return cell
//  }
//  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return messages.count
//  }
//  
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    let height = MessageTableViewCell.height(for: messages[indexPath.row], maxSizeOfView: Float(self.view.bounds.width))
//    return height
//  }
//  
//  func insertNewMessageCell(_ message: Message) {
//    messages.append(message)
//    let indexPath = IndexPath(row: messages.count - 1, section: 0)
//    epicView.tableView.beginUpdates()
//    epicView.tableView.insertRows(at: [indexPath], with: .bottom)
//    epicView.tableView.endUpdates()
//    epicView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//  }
//}
