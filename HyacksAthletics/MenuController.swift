//
//  MenuController.swift
//  HyacksAthletics
//
//  Created by Selena Liu on 2018-03-26.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class MenuController: NSObject {
    
    let blackView = UIView()
    let dummyView = UIView()
    
//    let tableView: UITableView = {/Users/selenaliu/Xcode projects/HyacksAthletics/HyacksAthletics/MenuController.swift
//        let tview = UITableView()
//        tview.backgroundColor = .white
//        return tview
//    }()
    
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            dummyView.backgroundColor = .white
            dummyView.frame = CGRect(x: -192, y: 0, width: 192, height: window.frame.height)

            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuController.handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(dummyView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.dummyView.frame = CGRect(x: 0, y: 0, width: self.dummyView.frame.width, height: self.dummyView.frame.height)

            }, completion: nil)
        }
       
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.dummyView.frame = CGRect(x: -192, y: 0, width: self.dummyView.frame.width, height: self.dummyView.frame.height)
        }, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
}
