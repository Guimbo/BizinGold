import UIKit
import SnapKit

extension JoinChatViewController {

    func configView(){
        view.addSubview(backgroundImage)
        loadViews()
        view.addSubview(shadowView)
        view.addSubview(logoImageView)
        view.addSubview(nameTextField)
        view.addSubview(portTextField)
        
    }

  func loadViews() {
    
    navigationItem.title = "Doge Chat!"

    logoImageView.image = UIImage(named: "doge")
    logoImageView.layer.cornerRadius = 4
    logoImageView.clipsToBounds = true

    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowRadius = 5
    shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    shadowView.layer.shadowOpacity = 0.5
    shadowView.backgroundColor = .black

    nameTextField.placeholder = "What's your username?"
    nameTextField.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.7764705882, blue: 0.6, alpha: 1)
    nameTextField.layer.cornerRadius = 8
    nameTextField.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    nameTextField.layer.borderWidth = 2
    
    nameTextField.delegate = self
    
    portTextField.placeholder = "Type the Room Port"
    portTextField.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.7764705882, blue: 0.6, alpha: 1)
    portTextField.layer.cornerRadius = 8
    portTextField.keyboardType = .numberPad
    portTextField.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    portTextField.layer.borderWidth = 2
    
    


    let backItem = UIBarButtonItem()
    backItem.title = "Run!"
    navigationItem.backBarButtonItem = backItem
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    logoImageView.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
    logoImageView.center = CGPoint(x: view.bounds.size.width / 2.0, y: logoImageView.bounds.size.height / 2.0 + view.bounds.size.height/4)
    shadowView.frame = logoImageView.frame

    nameTextField.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width - 40, height: 44)
    nameTextField.center = CGPoint(x: view.bounds.size.width / 2.0, y: logoImageView.center.y + logoImageView.bounds.size.height / 2.0 + 20 + 22)
    
    portTextField.snp.makeConstraints{ make in
        make.centerX.equalToSuperview()
        make.top.equalTo(nameTextField.snp.bottom).offset(10)
        make.height.equalTo(nameTextField.snp.height)
        make.width.equalTo(110)
    }

    
  }
}

extension MessageTableViewCell {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if isJoinMessage() {
      layoutForJoinMessage()
    } else {
      messageLabel.font = UIFont(name: "Helvetica", size: 17)
      messageLabel.textColor = .white
      
      let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3), height: .greatestFiniteMagnitude))
      messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
      
      if messageSender == .ourself {
        nameLabel.isHidden = true
        
        messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 16, y: bounds.size.height/2.0)
        messageLabel.backgroundColor = UIColor(red: 24 / 255, green: 180 / 255, blue: 128 / 255, alpha: 1.0)
      } else {
        nameLabel.isHidden = false
        nameLabel.sizeToFit()
        nameLabel.center = CGPoint(x: nameLabel.bounds.size.width / 2.0 + 16 + 4, y: nameLabel.bounds.size.height/2.0 + 4)
        
        messageLabel.center = CGPoint(x: messageLabel.bounds.size.width / 2.0 + 16, y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
        messageLabel.backgroundColor = .lightGray
      }
    }
    
    messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height / 2.0, 20)
  }
  
  func layoutForJoinMessage() {
    messageLabel.font = UIFont.systemFont(ofSize: 10)
    messageLabel.textColor = .lightGray
    messageLabel.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
    
    
    let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3), height: .greatestFiniteMagnitude))
    messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
    messageLabel.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2.0)
  }
  
  func isJoinMessage() -> Bool {
    if let words = messageLabel.text?.components(separatedBy: " ") {
      if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] == "joined" {
        return true
      }
    }
    return false
  }
}
