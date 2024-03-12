//
//  KMView.swift
//  GREEON
//
//  Created by Yushi Kang on 2/8/24.
//

import UIKit
import CoreLocation
import KakaoMapsSDK

enum Mode: Int {
  case hidden = 0,
       show,
       tracking
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension KMView: KakaoMapEventDelegate {
  func compassDidTapped(kakaoMap: KakaoMap) {
    print("compass tapped")
    
    kakaoMap.resetCameraOrientation()
  }
}

class KMView: MapViewController, GuiEventDelegate, UITextFieldDelegate {
  
  @IBOutlet var headerView: UIView!
  @IBOutlet var searchTxtField: UITextField!
  var searchTextField: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchTxtField.delegate = self
    
    searchTxtField.frame.size.height = 40
    
    // 헤더부분 그림자 추가
    headerView.layer.shadowColor = UIColor(hex: 0x000000).cgColor
    headerView.layer.shadowOpacity = 0.25
    headerView.layer.shadowRadius = 3
    headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
    
    self.hideKeyboardWhenTappedAround()
  }
  
  override func addViews() {
    // 현재 위치 위도, 경도 가져오기
    let latitude = locationManager.location!.coordinate.latitude
    let longitude = locationManager.location!.coordinate.longitude
    
    let defaultPosition = MapPoint(longitude: longitude, latitude: latitude)
    
    let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
    
    if mapController?.addView(mapviewInfo) == Result.OK {
      print("OK")
      
      // function으로 등록해 놓은 애들 끌고오기
      createSpriteGUI()
      createLabelLayer()
      createPoiStyle()
      createPois()
      showCompass()
      showScaleBar()
    }
  }
  
  func createLabelLayer() {
    let view = mapController?.getView("mapview") as! KakaoMap
    let manager = view.getLabelManager()
    let positionLayerOption = LabelLayerOptions(layerID: "PositionPoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
    let _ = manager.addLabelLayer(option: positionLayerOption)
    let directionLayerOption = LabelLayerOptions(layerID: "DirectionPoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10)
    let _ = manager.addLabelLayer(option: directionLayerOption)
  }
  
  // 현재위치를 터치했을때 뜨는 poi 아이콘 설정
  func createPoiStyle() {
    let view = mapController?.getView("mapview") as! KakaoMap
    let manager = view.getLabelManager()
    let Locationmarker = PoiIconStyle(symbol: UIImage(named: "map_ico_marker.png"))
    let perLevelStyle1 = PerLevelPoiStyle(iconStyle: Locationmarker, level: 0)
    let poiStyle1 = PoiStyle(styleID: "positionPoiStyle", styles: [perLevelStyle1])
    manager.addPoiStyle(poiStyle1)
    
    let direction = PoiIconStyle(symbol: UIImage(named: "map_ico_marker_direction.png"), anchorPoint: CGPoint(x: 0.5, y: 0.995))
    let perLevelStyle2 = PerLevelPoiStyle(iconStyle: direction, level: 0)
    let poiStyle2 = PoiStyle(styleID: "directionArrowPoiStyle", styles: [perLevelStyle2])
    manager.addPoiStyle(poiStyle2)
    
    let area = PoiIconStyle(symbol: UIImage(named: "map_ico_direction_area.png"), anchorPoint: CGPoint(x: 0.5, y: 0.995))
    let perLevelStyle3 = PerLevelPoiStyle(iconStyle: area, level: 0)
    let poiStyle3 = PoiStyle(styleID: "directionPoiStyle", styles: [perLevelStyle3])
    manager.addPoiStyle(poiStyle3)
  }
  
  func createPois() {
    let view = mapController?.getView("mapview") as! KakaoMap
    let manager = view.getLabelManager()
    let positionLayer = manager.getLabelLayer(layerID: "PositionPoiLayer")
    let directionLayer = manager.getLabelLayer(layerID: "DirectionPoiLayer")
    
    // 현위치마커의 몸통에 해당하는 POI
    let poiOption = PoiOptions(styleID: "positionPoiStyle", poiID: "PositionPOI")
    poiOption.rank = 1
    poiOption.transformType = .decal    //화면이 기울여졌을 때, 지도를 따라 기울어져서 그려지도록 한다.
    let latitude = locationManager.location!.coordinate.latitude
    let longitude = locationManager.location!.coordinate.longitude
    
    let defaultPosition = MapPoint(longitude: longitude, latitude: latitude)
    
    _currentPositionPoi = positionLayer?.addPoi(option:poiOption, at: defaultPosition)
    
    // 현위치마커의 방향표시 화살표에 해당하는 POI
    let poiOption2 = PoiOptions(styleID: "directionArrowPoiStyle", poiID: "DirectionArrowPOI")
    poiOption2.rank = 3
    poiOption2.transformType = .absoluteRotationDecal
    
    _currentDirectionArrowPoi = positionLayer?.addPoi(option:poiOption2, at: defaultPosition)
    
    // 현위치마커의 부채꼴모양 방향표시에 해당하는 POI
    let poiOption3 = PoiOptions(styleID: "directionPoiStyle", poiID: "DirectionPOI")
    poiOption3.rank = 2
    poiOption3.transformType = .decal
    
    _currentDirectionPoi = directionLayer?.addPoi(option:poiOption3, at: defaultPosition)
    
    _currentPositionPoi?.shareTransformWithPoi(_currentDirectionArrowPoi!)  //몸통이 방향표시와 위치 및 방향을 공유하도록 지정한다. 몸통 POI의 위치가 변경되면 방향표시 POI의 위치도 변경된다. 반대는 변경안됨.
    _currentDirectionArrowPoi?.shareTransformWithPoi(_currentDirectionPoi!) //방향표시가 부채꼴모양과 위치 및 방향을 공유하도록 지정한다.
  }
  
  // 현위치마커 버튼 GUI
  func createSpriteGUI() {
    let mapView = mapController?.getView("mapview") as! KakaoMap
    let spriteLayer = mapView.getGuiManager().spriteGuiLayer
    let spriteGui = SpriteGui("ButtonGui")
    
    spriteGui.arrangement = .horizontal
    spriteGui.bgColor = UIColor.clear
    spriteGui.splitLineColor = UIColor.white
    spriteGui.origin = GuiAlignment(vAlign: .top, hAlign: .left)
    
    let button = GuiButton("CPB")
    button.image = UIImage(named: "track_location_btn.png")
    button.padding = GuiPadding(left: 38, right: 0, top: 370, bottom: 0)
    
    spriteGui.addChild(button)
    
    spriteLayer.addSpriteGui(spriteGui)
    spriteGui.delegate = self
    spriteGui.show()
  }
  
  func guiDidTapped(_ gui: KakaoMapsSDK.GuiBase, componentName: String) {
    let button = gui.getChild(componentName) as! GuiButton
    switch _mode {
      case .hidden:
        _mode = .show   //현위치마커 표시
        button.image = UIImage(named: "track_location_btn_pressed.png")
        _timer = Timer.init(timeInterval: 0.3, target: self, selector: #selector(self.updateCurrentPositionPOI), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer!, forMode: RunLoop.Mode.common)
        startUpdateLocation()
        _currentPositionPoi?.show()
        _currentDirectionArrowPoi?.show()
        _moveOnce = true
        break;
      case .show:
        _mode = .tracking   //현위치마커 추적모드
        button.image = UIImage(named: "track_location_btn_compass_on.png")
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let trackingManager = mapView.getTrackingManager()
        trackingManager.startTrackingPoi(_currentDirectionArrowPoi!)
        trackingManager.isTrackingRoll = true
        _currentDirectionArrowPoi?.hide()
        _currentDirectionPoi?.show()
        break;
      case .tracking:
        _mode = .hidden     //현위치마커 숨김
        button.image = UIImage(named: "track_location_btn.png")
        _timer?.invalidate()
        _timer = nil
        stopUpdateLocation()
        _currentPositionPoi?.hide()
        _currentDirectionPoi?.hide()
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let trackingManager = mapView.getTrackingManager()
        trackingManager.stopTracking()
    }
    gui.updateGui()
  }
  
  func showCompass() {
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    
    mapView.setCompassPosition(origin: GuiAlignment(vAlign: .top, hAlign: .left), position: CGPoint(x: 16, y: 130))
    mapView.showCompass()
  }
  
  func showScaleBar() {
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    
    mapView.setScaleBarPosition(origin: GuiAlignment(vAlign: .middle, hAlign: .left), position: CGPoint(x: 66, y: 400))
    mapView.showScaleBar()
  }
  
  func compassTappedHanlder(_ kakaoMap: KakaoMap) {
    print("compass tapped")
    
    kakaoMap.resetCameraOrientation()
  }
  
  @objc func updateCurrentPositionPOI() {
    _currentPositionPoi?.moveAt(MapPoint(longitude: _currentPosition.longitude, latitude: _currentPosition.latitude), duration: 150)
    _currentDirectionArrowPoi?.rotateAt(_currentHeading, duration: 150)
    
    if _moveOnce {
      let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
      mapView.moveCamera(CameraUpdate.make(target: MapPoint(longitude: _currentPosition.longitude, latitude: _currentPosition.latitude), mapView: mapView))
      _moveOnce = false
    }
  }
  
  
  // 위치서비스 관련 설정
  func startUpdateLocation() {
    if _locationServiceAuthorized != .authorizedWhenInUse {
      _locationManager.requestWhenInUseAuthorization()
    }
    else {
      _locationManager.startUpdatingLocation()
      _locationManager.startUpdatingHeading()
    }
  }
  
  func stopUpdateLocation() {
    _locationManager.stopUpdatingHeading()
    _locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    _locationServiceAuthorized = status
    if _locationServiceAuthorized == .authorizedWhenInUse && (_mode == .show || _mode == .tracking) {
      _locationManager.startUpdatingLocation()
      _locationManager.startUpdatingHeading()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    _currentPosition.longitude = locations[0].coordinate.longitude
    _currentPosition.latitude = locations[0].coordinate.latitude
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    _currentHeading = newHeading.trueHeading * Double.pi / 180.0
  }
  
  func searchFieldDone(_ controller: KMView, message: String) {
    searchTxtField.text = message
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // 텍스트 필드에서 리턴(엔터) 키가 눌렸을 때 호출되는 메서드
    textField.resignFirstResponder()
    performSegue(withIdentifier: "chargerInfoController", sender: self)
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chargerInfoController" {
      if segue.destination is chargerInfoController {
        // 옵셔널 바인딩을 사용하여 안전하게 언래핑
      }
    }
  }
}

