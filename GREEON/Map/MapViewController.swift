//
//  MapViewController.swift
//  GREEON
//
//  Created by Yushi Kang on 2/1/24.
//


import UIKit
import KakaoMapsSDK
import CoreLocation

class MapViewController: UIViewController, MapControllerDelegate, CLLocationManagerDelegate {
  
  required init?(coder aDecoder: NSCoder) {
    _observerAdded = false
    _auth = false
    _appear = false
    _locationServiceAuthorized = CLAuthorizationStatus.notDetermined
    _locationManager = CLLocationManager()
    _locationManager.distanceFilter = kCLDistanceFilterNone
    _locationManager.headingFilter = kCLHeadingFilterNone
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest
    _currentHeading = 0
    _currentPosition = GeoCoordinate()
    _mode = .hidden
    _moveOnce = false
    super.init(coder: aDecoder)
    
    _locationManager.delegate = self
    
  }
  
  deinit {
    mapController?.stopRendering()
    mapController?.stopEngine()
    
    print("deinit")
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    mapContainer = self.view as? KMViewContainer
    
    //KMController 생성.
    mapController = KMController(viewContainer: mapContainer!)!
    mapController!.delegate = self
    
    mapController?.initEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    addObservers()
    _appear = true
    if mapController?.engineStarted == false {
      mapController?.startEngine()
    }
    
    if mapController?.rendering == false {
      mapController?.startRendering()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    _appear = false
    mapController?.stopRendering()  //렌더링 중지.
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    removeObservers()
    mapController?.stopEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
  }
  
  // 인증 성공시 delegate 호출.
  func authenticationSucceeded() {
    // 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
    // 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
    if _auth == false {
      _auth = true
    }
    
    if mapController?.engineStarted == false {
      mapController?.startEngine()    //엔진 시작 및 렌더링 준비. 준비가 끝나면 MapControllerDelegate의 addViews 가 호출된다.
      mapController?.startRendering() //렌더링 시작.
    }
  }
  
  // 인증 실패시 호출.
  func authenticationFailed(_ errorCode: Int, desc: String) {
    print("error code: \(errorCode)")
    print("desc: \(desc)")
    _auth = false
    switch errorCode {
      case 400:
        showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
        break;
      case 401:
        showToast(self.view, message: "지도 종료(API인증 키 오류)")
        break;
      case 403:
        showToast(self.view, message: "지도 종료(API인증 권한 오류)")
        break;
      case 429:
        showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
        break;
      case 499:
        showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
        
        // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
          print("retry auth...")
          
          self.mapController?.authenticate()
        }
        break;
      default:
        break;
    }
  }
  
  func addViews() {
    
    // 현재 위치 위도, 경도 가져오기
    let latitude = locationManager.location!.coordinate.latitude
    let longitude = locationManager.location!.coordinate.longitude
    
    // lat, lng를 위에 설정해놓은 코드로 불러오기
    let defaultPosition = MapPoint(longitude: longitude, latitude: latitude)
    
    // 맵 그리기
    let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 17)
    
    // KakaoMap 추가
    if mapController?.addView(mapviewInfo) == Result.OK {
      print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
    }
  }
  
  func displayMarker(_ position: CLLocationCoordinate2D, _ message: String) {
    // 마커와 인포윈도우를 표시하는 로직을 구현합니다.
  }
  
  //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
  }
  
  func viewWillDestroyed(_ view: ViewBase) {
    
  }
  
  func addObservers(){
    NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
    _observerAdded = true
  }
  
  func removeObservers(){
    NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    
    _observerAdded = false
  }
  
  @objc func willResignActive(){
    mapController?.stopRendering()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
  }
  
  @objc func didBecomeActive(){
    mapController?.startRendering() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
  }
  
  func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center;
    view.addSubview(toastLabel)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    
    UIView.animate(withDuration: 0.4,
                   delay: duration - 0.4,
                   options: UIView.AnimationOptions.curveEaseOut,
                   animations: {
      toastLabel.alpha = 0.0
    },
                   completion: { (finished) in
      toastLabel.removeFromSuperview()
    })
  }
  
  var mapContainer: KMViewContainer? // 맵 컨테이너 설정 (앱에서 보여지는 뷰)
  var mapController: KMController? // 맵 컨트롤러 설정
  var _observerAdded: Bool // 맵 옵저버
  var _auth: Bool // 맵 인증
  var _appear: Bool
  var _timer: Timer?
  var _currentPositionPoi: Poi? // 현재위치 POI 설정
  var _currentDirectionArrowPoi: Poi? // 현재위치 화살표 POI 설정
  var _currentDirectionPoi: Poi? // 현재위치 나침반 POI 설정
  var _currentHeading: Double
  var _currentPosition: GeoCoordinate // 내 위치를 GeoCoordinate로 지정
  var _mode: Mode
  var _moveOnce: Bool
  var _locationManager: CLLocationManager // 카카오맵의 locationmanager (현재위치 값 불러오는 locationmanager하고 다름)
  var _locationServiceAuthorized: CLAuthorizationStatus
  var currentLatLng: [String: Double] = [:] // 위도, 경도
  var locationManager = CLLocationManager() // location manager (현재위치 값 불러오기 위한 세팅)
  var currentLocation: CLLocation! // 내 위치 저장
  
}




//import UIKit
//import NMapsMap
//import CoreLocation
//
//class MapViewController: UIViewController, CLLocationManagerDelegate {
//
//  var locationManager = CLLocationManager() // location manager
//  var currentLocation: CLLocation! // 내 위치 저장
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // 현재 위치 위도, 경도 가져오기
//    let latitude = locationManager.location!.coordinate.latitude
//    let longitude = locationManager.location!.coordinate.longitude
//
//    let defaultCameraPosition = NMFCameraPosition(NMGLatLng(lat: latitude, lng: longitude), zoom: 16, tilt: 0, heading: 0)
//
//    let naverMapView = NMFNaverMapView(frame: UIScreen.main.bounds)
//    view.addSubview(naverMapView)
//
//    naverMapView.showCompass = true // 나침반
//    naverMapView.showScaleBar = true // 축척 바
//    naverMapView.showZoomControls = true // 줌 버튼
//    naverMapView.showLocationButton = true // 현재위치 버튼
//    naverMapView.mapView.mapType = .basic // 맵 종류 (기본값은 basic)
//    naverMapView.mapView.isIndoorMapEnabled = true // 실내 지도 활성화 여부
//    naverMapView.mapView.buildingHeight = 0.5 // 지도를 기울였을 때 건물 높이 (기본값 1)
//    naverMapView.mapView.zoomLevel = 16
//    naverMapView.mapView.positionMode = .normal
//    naverMapView.mapView.moveCamera(NMFCameraUpdate(position: defaultCameraPosition))
//
//    setLocationData()
//
//    func setLocationData() {
//      locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//    }
//  }
//}

