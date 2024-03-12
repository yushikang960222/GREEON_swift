//
//  AuthViewController.swift
//  GREEON
//
//  Created by Yushi Kang on 2/11/24.
//

import UIKit

class AuthViewController: UIViewController {
  @IBOutlet var checkAllBtnTap: UIButton!
  @IBOutlet var checkTotal: UIButton!
  @IBOutlet var checkUserInfo: UIButton!
  @IBOutlet var checkLocation: UIButton!
  @IBOutlet var checkSMS: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // 체크박스들
  @IBAction func checkAll(_ sender: UIButton) {
    setAllCheck(!sender.isSelected) // 전체 체크 감지
    updateCheckState() // 체크 감지 후 업데이트
  }
  
  @IBAction func checkTotal(_ sender: UIButton) {
    sender.isSelected.toggle()
    updateCheckState()
  }
  
  @IBAction func checkUserInfo(_ sender: UIButton) {
    sender.isSelected.toggle()
    updateCheckState()
  }
  
  @IBAction func checkLocation(_ sender: UIButton) {
    sender.isSelected.toggle()
    updateCheckState()
  }
  
  @IBAction func checkSMS(_ sender: UIButton) {
    sender.isSelected.toggle()
    updateCheckState()
  }
  
  // 전체 체크 감지하는 함수
  private func setAllCheck(_ isSelected: Bool) {
    print("isSelected: \(isSelected)")
    
    checkAllBtnTap.isSelected = isSelected
    checkTotal.isSelected = isSelected
    checkUserInfo.isSelected = isSelected
    checkLocation.isSelected = isSelected
    checkSMS.isSelected = isSelected
  }
  
  // 체크 감지 후 업데이트 하는 함수
  private func updateCheckState() {
    let allSel = checkTotal.isSelected &&
    checkUserInfo.isSelected &&
    checkLocation.isSelected &&
    checkSMS.isSelected
    
    checkAllBtnTap.isSelected = allSel
  }
  
  
  // 뒤로 돌아가기 버튼
  @IBAction func backBtn(_ sender: UIButton) {
    dismissAnimation()
  }
  
  // 로그인으로 되돌아가는 코드
  func gotoLoginViewController() {
    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") else { return }
    nextVC.modalPresentationStyle = .fullScreen
    nextVC.modalTransitionStyle = .coverVertical
    self.present(nextVC, animated: true, completion: nil)
  }
  
  // 모달이 닫히는 효과
  func dismissAnimation() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func nextBtn(_ sender: UIButton) {
    if checkTotal.isSelected && checkUserInfo.isSelected && checkLocation.isSelected
    {
      // 필수체크항목 체크 시 다음화면으로 이동
      gotoJoin()
    } else {
      // 필수체크항목 미체크 시 알럿
      showAgreementAlert()
    }
  }
  
  func showAgreementAlert() {
    let alert = UIAlertController(title: "알림", message: "\n필수 약관에 동의해주세요.\n", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func gotoJoin() {
    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "joinMembershipViewController") else { return }
    self.navigationController?.pushViewController(nextVC, animated: true)
    nextVC.modalPresentationStyle = .fullScreen
    nextVC.modalTransitionStyle = .coverVertical
    self.present(nextVC, animated: true, completion: nil)
  }
}
