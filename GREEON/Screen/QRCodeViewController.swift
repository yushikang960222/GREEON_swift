//
//  QRCodeViewController.swift
//  GREEON
//
//  Created by Yushi Kang on 2/5/24.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  @IBOutlet var QRCodeScanner: UIView!
  
  var captureSession: AVCaptureSession!
  var previewLayer: AVCaptureVideoPreviewLayer!
  
  // 카메라 권한 확인 알림
  var isPermissionActive: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupCamera()
    
  }
  
  func setupCamera() {
    captureSession = AVCaptureSession()
    
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    let videoInput: AVCaptureDeviceInput
    
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
    
    // 중복 추가 방지
    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed()
      return
    }
    
    let metadataOutput = AVCaptureMetadataOutput()
    
    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)
      
      // metadataOutput의 델리게이트를 메인 큐에서 호출
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.qr]
    } else {
      failed()
      return
    }
    
    // 비동기로 백그라운드에서 실행
    DispatchQueue.global(qos: .background).async {
      // 캡처 세션의 시작을 메인 큐에서 호출
      self.captureSession.startRunning()
    }
    
    // 메인 스레드에서 실행
    DispatchQueue.main.async {
      self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
      self.previewLayer.frame = self.QRCodeScanner.bounds
      self.previewLayer.videoGravity = .resizeAspectFill
      self.QRCodeScanner.layer.addSublayer(self.previewLayer)
    }
  }
  
  
  
  func failed() {
    let alert = UIAlertController(title: "QR코드 스캔을 사용할 수 없습니다.", message: "\n현재 카메라 권한이 허용되어 있지 않습니다.\n카메라 권한을 허용해주세요.", preferredStyle: .alert)
    
    // 추가 : 카메라 활성화 시 해당 알럿 비활성화
    if !isPermissionActive {
      let action = UIAlertAction(title: "설정하러 가기", style: .cancel) { _ in
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
      action.setValue(UIColor(hex:0x00ab84), forKey: "titleTextColor") // 버튼 텍스트 컬러 변경
      alert.addAction(action)
      
      // 카메라 활성화됨을 표시
      isPermissionActive = true
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  private var isViewAppeared = false
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if !isViewAppeared {
      isViewAppeared = true
      
      // QR코드 스캔 전에 권한 요청
      
      requestCameraPermission()
      
      // 권한이 허용되어 있지 않으면 권한을 요청하는 alert 띄우기
      if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
        requestCameraPermission()
        
      } else {
        DispatchQueue.main.async {
          if let session = self.captureSession, !session.isRunning {
            self.captureSession.startRunning()
          }
        }
      }
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // 추가된 부분: 뷰가 사라질 때 알림 활성화 플래그 초기화
    isPermissionActive = false
  }
  
  func requestCameraPermission() {
    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        guard let self = self else { return }
      
      if granted {
        // 권한이 허용 되면 QR스캔 시작
        DispatchQueue.main.async {
          if let session = self.captureSession, !session.isRunning {
            self.captureSession.startRunning()
          }
        }
      } else {
        // 권한이 거부된 경우 alert 표시
        DispatchQueue.main.async {
          self.failed()
        }
      }
    }
  }
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let stringValue = readableObject.stringValue else { return }
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      found(code: stringValue)
    }
    
    dismiss(animated: true)
  }
  
  func found(code: String) {
    print("Scanned QR Code: \(code)")
    // 여기에서 스캔된 QR 코드에 대한 작업을 수행해야함 (지금은 아무것도 없음)
  }
}
