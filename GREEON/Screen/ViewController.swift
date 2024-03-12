//
//  ViewController.swift
//  GREEON
//
//  Created by Yushi Kang on 2/1/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  var name = ("chabiee", "yeongmin")
  
  // 로케이션매니저 초기설정으로 위치 권한 확인
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
  
  // 위치 권한이 거부되었을 경우 알럿을 띄우기 위한 기본 세팅
  func isLocationServiceEnabled(completion: @escaping (Bool) -> Void) {
    DispatchQueue.global().async {
      let isEnabled = CLLocationManager.locationServicesEnabled() &&
      (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
      
      DispatchQueue.main.async {
        completion(isEnabled)
      }
    }
  }
  
  
  // 위치서비스 권한이 허용되어 있는지 확인
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
  
  // 이미지 터치 시 메인으로 이동
  @objc func imageTap(tapGestureRecognizer: UITapGestureRecognizer) {
    
    // 위치 서비스가 허용되어 있으면 MainViewController로 이동
    checkLocationServiceAndNavigate()
  }
  
  // 텍스트 터치 시 메인으로 이동
  @objc func txtTap(tapGestureRecognizer: UITapGestureRecognizer) {
    
    // 위치 서비스가 허용되어 있으면 MainViewController로 이동
    checkLocationServiceAndNavigate()
  }
  
  // 위치 서비스 권한 확인 후 이동 처리
  func checkLocationServiceAndNavigate() {
    // 위치 서비스 권한 확인 후 처리
    isLocationServiceEnabled { isEnabled in
      if isEnabled {
        self.navigateToMainViewController()
      } else {
        self.showLocationPermissionDeniedAlert()
      }
    }
  }
  
  // 위치 서비스가 허용되어 있으면 MainViewController로 이동
  func navigateToMainViewController() {
    guard let nextView = self.storyboard?.instantiateViewController(identifier: "LoginViewController") else {
      return
    }
    nextView.modalTransitionStyle = .coverVertical
    nextView.modalPresentationStyle = .fullScreen
    self.present(nextView, animated: true, completion: nil)
  }
  
  // 앱의 상태를 저장 (동작 안하는것같은데)
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
    
    // 이미 위치 권한이 허용된 경우 MainViewController로 이동 (이것도 동작 안하는것같은데)
    restoreAppState()
    
    // 위치 서비스가 허용되지 않은 경우 위치 권한 요청
    isLocationServiceEnabled { isEnabled in
      if !isEnabled {
        self.requestLocationPermission()
      }
    }
    
    // 이미지 터치 제스처 등록
    let tapImageView = UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:)))
    imgBtn.isUserInteractionEnabled = true
    imgBtn.addGestureRecognizer(tapImageView)
    
    // 텍스트 터치 제스처 등록
    let tapTxtView = UITapGestureRecognizer(target: self, action: #selector(txtTap(tapGestureRecognizer:)))
    txtBtn.isUserInteractionEnabled = true
    txtBtn.addGestureRecognizer(tapTxtView)
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  // 위치 서비스가 허용되어 있는지 동기적으로 확인
  func isLocationServiceEnabledSync(completion: @escaping (Bool) -> Void) {
    DispatchQueue.global().async {
      let isEnabled = CLLocationManager.locationServicesEnabled() &&
      (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
      
      DispatchQueue.main.async {
        completion(isEnabled)
      }
    }
  }
  
  // 권한 인식 및 권한 거부 시 알럿 띄우기
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
  
  // 권한 허용할때까지 계속 알럿을 띄우게 함
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    LocationAlertNeed()
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  @objc func applicationDidBecomeActive() {
    LocationAlertNeed()
  }
}
