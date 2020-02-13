//
//  MainViewController.swift
//  BizinGold
//
//  Created by Guilherme Araujo on 13/02/20.
//  Copyright © 2020 Guilherme Araujo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var PlayerName: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func callGame(_ sender: Any) {
        
        let gameNavigation = UINavigationController(rootViewController: GameViewController())
        gameNavigation.modalPresentationStyle = .fullScreen
        self.present(gameNavigation, animated: true, completion: nil)
    }
}
