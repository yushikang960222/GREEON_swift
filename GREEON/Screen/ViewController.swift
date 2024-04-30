//
//  ViewController.swift
//  GREEON
//
//  Created by Yushi Kang on 2/1/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
  let locationManager = CLLocationManager()
  
  @IBOutlet var imgBtn: UIImageView!
  @IBOutlet var txtBtn: UILabel!
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    DispatchQueue.global(qos: .background).async {
      self.LocationAlertNeed()
    }
  }
  
  internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    DispatchQueue.main.async {
      self.LocationAlertNeed()
    }
    
    switch status {
      case .authorizedWhenInUse, .authorizedAlways:
        locationManager.startUpdatingLocation()
      case .denied, .restricted:
        self.showPermissionDeniedAlert()
      default:
        break
    }
  }
  
  func isLocationServiceEnabled(completion: @escaping (Bool) -> Void) {
    DispatchQueue.global().async {
      let isEnabled = CLLocationManager.locationServicesEnabled() &&
      (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
      
      DispatchQueue.main.async {
        completion(isEnabled)
      }
    }
  }
  
  func LocationAlertNeed() {
    DispatchQueue.global(qos: .background).async {
      if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
          case .notDetermined: // 권한을 아직 허용 안했을 경우
            self.requestAuth()
          case .restricted, .denied: // 거부한 경우
            self.showPermissionDeniedAlert()
          case .authorizedAlways, .authorizedWhenInUse: // 허용된 경우
            self.locationManager.startUpdatingLocation()
          @unknown default:
            break
        }
      } else {
        print("위치서비스 거부")
      }
    }
  }
  
  func requestAuth() {
    DispatchQueue.main.async {
      self.locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func showPermissionDeniedAlert() {
    DispatchQueue.main.async {
      self.showLocationPermissionDeniedAlert()
    }
  }
  
  @objc func imageTap(tapGestureRecognizer: UITapGestureRecognizer) {
    
    checkLocationServiceAndNavigate()
  }
  
  @objc func txtTap(tapGestureRecognizer: UITapGestureRecognizer) {
    
    checkLocationServiceAndNavigate()
  }
  
  func checkLocationServiceAndNavigate() {
    isLocationServiceEnabled { isEnabled in
      if isEnabled {
        self.navigateToMainViewController()
      } else {
        self.showLocationPermissionDeniedAlert()
      }
    }
  }
  
  func navigateToMainViewController() {
    guard let nextView = self.storyboard?.instantiateViewController(identifier: "LoginViewController") else {
      return
    }
    nextView.modalTransitionStyle = .coverVertical
    nextView.modalPresentationStyle = .fullScreen
    self.present(nextView, animated: true, completion: nil)
  }
  
  func saveAppState() {
    UserDefaults.standard.set(true, forKey: "LocationPermissionGranted")
  }
  
  func restoreAppState() {
    let isLocationPermissionGranted = UserDefaults.standard.bool(forKey: "LocationPermissionGranted")
    if isLocationPermissionGranted {
      navigateToMainViewController()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    restoreAppState()
    isLocationServiceEnabled { isEnabled in
      if !isEnabled {
        self.requestLocationPermission()
      }
    }
    
    let tapImageView = UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:)))
    imgBtn.isUserInteractionEnabled = true
    imgBtn.addGestureRecognizer(tapImageView)
    
    let tapTxtView = UITapGestureRecognizer(target: self, action: #selector(txtTap(tapGestureRecognizer:)))
    txtBtn.isUserInteractionEnabled = true
    txtBtn.addGestureRecognizer(tapTxtView)
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  func isLocationServiceEnabledSync(completion: @escaping (Bool) -> Void) {
    DispatchQueue.global().async {
      let isEnabled = CLLocationManager.locationServicesEnabled() &&
      (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
      
      DispatchQueue.main.async {
        completion(isEnabled)
      }
    }
  }
  
  func requestLocationPermission() {
    DispatchQueue.global(qos: .background).async {
      if CLLocationManager.locationServicesEnabled() {
        DispatchQueue.main.async {
          switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
              self.locationManager.requestWhenInUseAuthorization()
              print("Location 활성화할지 묻는 Alert 띄워짐")
            case .restricted, .denied:
              self.showLocationPermissionDeniedAlert()
              print("Alert 띄워짐")
            case .authorizedAlways, .authorizedWhenInUse:
              self.locationManager.startUpdatingLocation()
            @unknown default:
              break
          }
        }
      } else {
        print("위치서비스 거부")
      }
    }
  }
  
  func showLocationPermissionDeniedAlert() {
    let alert = UIAlertController(title: "위치서비스를 허용해주세요.", message: "\nGREEON은 주변의 충전소를 찾기 위해 위치서비스를 필수적으로 사용합니다.\n\n위치서비스를 아래와 같이 설정 해주세요.\n\n[항상 또는 사용하는 동안으로 설정]", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "설정하러 가기", style: .cancel) { _ in
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    action.setValue(UIColor(hex:0x00ab84), forKey: "titleTextColor") // 버튼 텍스트 컬러 변경
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    LocationAlertNeed()
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  @objc func applicationDidBecomeActive() {
    LocationAlertNeed()
  }
}
