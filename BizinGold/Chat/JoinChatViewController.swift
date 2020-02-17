//
//  MainViewController.swift
//  BizinGold
//
//  Created by Guilherme Araujo on 13/02/20.
//  Copyright © 2020 Guilherme Araujo. All rights reserved.
//

import UIKit
import SnapKit

class JoinChatViewController: UIViewController {
    let backgroundImage: UIImageView = {
        let bgImage = UIImageView()
        bgImage.image = UIImage(named: "bizingo")
        return bgImage
    }()
    
    lazy var logoImageView = UIImageView()
    lazy var shadowView = UIView()
    lazy var nameTextField = TextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        backgroundImage.snp.makeConstraints{ make in
            make.size.equalToSuperview()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }

}


extension JoinChatViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let chatRoomVC = GameViewController()
    if let username = nameTextField.text {
      chatRoomVC.username = username
    }
    navigationController?.pushViewController(chatRoomVC, animated: true)
    return true
  }
}

class TextField: UITextField {
  let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}

