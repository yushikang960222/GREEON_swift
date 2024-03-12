//
//  AppDelegate.swift
//  GREEON
//
//  Created by Yushi Kang on 2/1/24.
//

import UIKit
import KakaoMapsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    //        sleep(2)
    
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    //            print("1.5초뒤에 실행돼용")
    //            // 여기에 지연 후 실행할 코드 작성 (api 연결 시 필요)
    //        }
    
    sleep(2) // api 연결 후 삭제!!!!
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  
  
}



