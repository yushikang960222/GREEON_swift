//
//  LoginViewController.swift
//  GREEON
//
//  Created by Yushi Kang on 2/10/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet var emailTxtField: UITextField!
  @IBOutlet var passwordTxtField: UITextField!
  @IBOutlet var headerView: UIView!
  @IBOutlet var AuthBtn: UIButton!
  @IBOutlet var LoginBtn: UIButton!
  var showPasswordButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTxtField.delegate = self
    passwordTxtField.delegate = self
    
    // 회원가입 버튼 Radius보더 추가
    AuthBtn?.layer.cornerRadius = 18
    AuthBtn?.layer.borderWidth = 3
    AuthBtn?.layer.borderColor = UIColor(hex: 0x00ab84).cgColor
    
    // 헤더부분 그림자 추가
    headerView.layer.shadowColor = UIColor(hex: 0x000000).cgColor
    headerView.layer.shadowOpacity = 0.25
    headerView.layer.shadowRadius = 3
    headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
    
    emailTxtField.frame.size.height = 40
    passwordTxtField.frame.size.height = 40
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    view.addGestureRecognizer(tapGesture)
    
    showPasswordButton = UIButton(type: .system)
    showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    showPasswordButton.tintColor = UIColor(hex: 0x545860)
    showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
    
    // 비밀번호 보이기, 숨기기 버튼 설정
    let initialImageName = passwordTxtField.isSecureTextEntry ? "eye.slash" : "eye"
    showPasswordButton.setImage(UIImage(systemName: initialImageName), for: .normal)
    
    // 비밀번호 미 입력 시 토글 숨김
    showPasswordButton.isHidden = passwordTxtField.text?.isEmpty ?? true
    
    view.addSubview(showPasswordButton)
    showPasswordButton.topAnchor.constraint(equalTo: passwordTxtField.topAnchor, constant: 5).isActive = true
    showPasswordButton.trailingAnchor.constraint(equalTo: passwordTxtField.trailingAnchor, constant: -8).isActive = true
    showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    
    NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
  }
  
  // 다른곳을 탭했을 때 키보드 사라짐
  @objc func handleTap() {
    view.endEditing(true)
  }
  
  // 비밀번호 입력할때 토글 아이콘 설정
  @objc func togglePasswordVisibility() {
    passwordTxtField.isSecureTextEntry.toggle()
    let imageName = passwordTxtField.isSecureTextEntry ? "eye.slash" : "eye"
    showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
  }
  
  // 비밀번호 입력 시 토글을 보이게 할지 설정
  @objc func textFieldChange(_ notification: Notification) {
    guard let textField = notification.object as? UITextField else {
      return
    }
    
    let text = textField.text ?? ""
    
    showPasswordButton.isHidden = text.isEmpty
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text, let range = Range(range, in: text) {
      let updatedText = text.replacingCharacters(in: range, with: string)
      showPasswordButton.isHidden = updatedText.isEmpty
    } else {
      showPasswordButton.isHidden = string.isEmpty
    }
    return true
  }
  
  // 이메일과 비밀번호를 입력했는지 확인
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTxtField {
      passwordTxtField.becomeFirstResponder()
    } else if textField == passwordTxtField {
      validateAndLogin()
    }
    return false
  }
  
  // 로그인 버튼 터치 시 이메일과 비밀번호를 입력했는지 확인 후 이동
  @IBAction func PressLoginBtn(_sender: UIButton) {
    validateAndLogin()
  }
  
  // 이메일과 비밀번호를 입력 안하면 뜨는 alert
  func validateAndLogin() {
    guard let email = emailTxtField.text, !email.isEmpty else {
      showAlert(message: "\n이메일을 입력해주세요.\n")
      return
    }
    
    guard let password = passwordTxtField.text, !password.isEmpty else {
      showAlert(message: "\n비밀번호를 입력해주세요.\n")
      return
    }
    
    // 이메일 형식이 맞지 않을 경우 alert
    if !isValidEmail(email: email) {
      showAlert(message: "\n올바른 이메일 형식이 아닙니다.\n다시 확인해주세요.")
    }
    
    // 비밀번호 형식이 맞지 않을 경우 alert
    if !isValidPassword(password: password) {
      showAlert(message: "\n잘못된 비밀번호입니다.\n다시 확인해주세요.")
    }
    
    performLoginAndNavigateToMain()
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "로그인 오류", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alert.addAction(okAction)
    okAction.setValue(UIColor(hex: 0x00ab84), forKey: "titleTextColor") // 버튼 텍스트 컬러 변경
    present(alert, animated: true, completion: nil)
  }
  
  // 이메일 형식 정규식
  func isValidEmail(email: String) -> Bool {
    let emailReg = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._%+-]+\\.[A-Za-z]{3,}"
    let emailPred = NSPredicate(format: "Self Matches %@", emailReg)
    return emailPred.evaluate(with: email)
  }
  
  // 비밀번호 형식 정규식
  func isValidPassword(password: String) -> Bool {
    let passwordReg = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,}"
    let passwordPred = NSPredicate(format: "Self Matches %@", passwordReg)
    return passwordPred.evaluate(with: password)
  }
  
  // MainViewController로 이동
  func performLoginAndNavigateToMain() {
    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MainViewController") else { return }
    self.navigationController?.pushViewController(nextVC, animated: true)
    nextVC.modalPresentationStyle = .fullScreen
    nextVC.modalTransitionStyle = .coverVertical
    self.present(nextVC, animated: true, completion: nil)
  }
  
  @IBAction func AuthBtn(_ sender: UIButton) {
    gotoAuthViewController()
  }
  
  func gotoAuthViewController() {
    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AuthViewController") else { return }
    self.navigationController?.pushViewController(nextVC, animated: true)
    nextVC.modalPresentationStyle = .fullScreen
    nextVC.modalTransitionStyle = .coverVertical
    self.present(nextVC, animated: true, completion: nil)
  }
}
