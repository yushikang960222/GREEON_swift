//
//  customTabbarViewController.swift
//  Pods
//
//  Created by Yushi Kang on 2/21/24.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    setupMiddleButton()
  }
  
  // TabBarButton – Setup Middle Button
  func setupMiddleButton() {
    
    let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
    
    //STYLE THE BUTTON YOUR OWN WAY
    
    middleBtn.backgroundColor = .green
    middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
    
    //add to the tabbar and add click event
    self.tabBar.addSubview(middleBtn)
    middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
    
    self.view.layoutIfNeeded()
  }
  
  // Menu Button Touch Action
  @objc func menuButtonAction(sender: UIButton) {
    self.selectedIndex = 2
    print("MenuButton")
  }
}
