//
//  loginView.swift
//  GREEON
//
//  Created by Yushi Kang on 3/15/24.
//

import SwiftUI
import Combine

struct MainViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
    return mainViewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct AuthViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let authViewController = storyboard.instantiateViewController(identifier: "AuthViewController")
    return authViewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct loginView: View {
  @State private var userEmail: String = ""
  @State private var userPassword: String = ""
  @State private var showAlert: Bool = false
  @State private var alertMessage: String = ""
  @State private var isMainViewPresented = false
  @State private var isAuthViewPresented = false
  
  // 이메일 정규식
  private var emailPredicate: NSPredicate {
    NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
  }
  
  // 비밀번호 정규식
  private var passwordPredicate: NSPredicate {
    NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,}")
  }
  
  var body: some View {
    ZStack{
      VStack(alignment: .leading) {
        Spacer().frame(height: 60)
        HStack{
          Spacer().frame(width: 14)
          Text("로그인")
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    VStack{
      Spacer().frame(height: 80)
      HStack{
        Spacer().frame(width: 14)
        VStack(alignment: .leading){
          Image("logo")
          Spacer().frame(height: 30)
          Text("안녕하세요.")
            .font(.custom("SUITE-Medium", size: 18))
          Text("쉽고 빠른 전기차 충전 GREEON 입니다.")
            .font(.custom("SUITE-Medium", size: 18))
          Spacer().frame(height: 10)
          Text("로그인해주세요.")
            .font(.custom("SUITE-Regular", size: 14))
        }
        Spacer()
      }
      Spacer().frame(height: 30)
      HStack{
        Spacer().frame(width: 14)
        TextField("이메일 주소", text: $userEmail)
          .keyboardType(.emailAddress)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .multilineTextAlignment(.leading)
          .font(.custom("SUITE-Regular", size: 16))
        Spacer().frame(width: 14)
      }
      Spacer().frame(height: 20)
      HStack{
        Spacer().frame(width: 14)
        SecureField("비밀번호", text: $userPassword)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .multilineTextAlignment(.leading)
          .font(.custom("SUITE-Regular", size: 16))
        Spacer().frame(width: 14)
      }
      Spacer().frame(height: 20)
      HStack{
        Spacer().frame(width: 14)
        Button(action: {
          loginButtonAction()
        }) {
          HStack {
            Text("로그인")
              .font(.custom("SUITE-Bold", size: 16))
              .foregroundColor(Color(hex: 0xffffff))
          }
          .frame(maxWidth: .infinity)
          .frame(height: 40)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(Color(hex: 0x00ab84))
          )
        }
        Spacer().frame(width: 14)
      }
      Spacer()
      Spacer()
      HStack{
        Spacer().frame(width: 20)
        VStack(alignment: .leading){
          HStack{
            Text("아직 회원이 아니신가요?")
              .font(.custom("SUITE-Medium", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
            Button(action: {
              isAuthViewPresented.toggle()
            }) {
              HStack {
                Text("회원가입")
                  .font(.custom("SUITE-Bold", size: 16))
                  .foregroundColor(Color(hex: 0x545860))
              }
              .frame(width: 94, height: 38)
              .overlay(
                RoundedRectangle(cornerRadius: 20)
                  .stroke(Color(hex: 0x00ab84), lineWidth: 4)
              )
            }
            Spacer().frame(width: 20)
          }
          Spacer().frame(height: 30)
          HStack{
            Text("이메일을 잊으셨나요?")
              .font(.custom("SUITE-Medium", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
            Button(action: {
              // 버튼 선택시
            }) {
              Text("이메일 찾기")
                .font(.custom("SUITE-Bold", size: 16))
                .foregroundColor(Color(hex: 0x0069cb))
            }
            Spacer().frame(width: 30)
          }
          Spacer().frame(height: 30)
          HStack{
            Text("비밀번호를 잊으셨나요?")
              .font(.custom("SUITE-Medium", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
            Button(action: {
              // 버튼 선택시
            }) {
              Text("비밀번호 찾기")
                .font(.custom("SUITE-Bold", size: 16))
                .foregroundColor(Color(hex: 0x0069cb))
            }
            Spacer().frame(width: 30)
          }
        }
      }
      Spacer().frame(height: 30)
    }
    .alert(isPresented: $showAlert) {
      Alert(title: Text("로그인 오류"), message: Text(alertMessage), dismissButton: .cancel(Text("확인")))
    }
    .fullScreenCover(isPresented: $isMainViewPresented) {
      MainViewControllerWrapper()
        .edgesIgnoringSafeArea(.all)
    }
    .fullScreenCover(isPresented: $isAuthViewPresented) {
      AuthViewControllerWrapper()
        .edgesIgnoringSafeArea(.all)
    }
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
  private func loginButtonAction() {
    if userEmail.isEmpty {
      showAlert = true
      alertMessage = "\n이메일 주소를 입력해주세요."
    } else if !emailPredicate.evaluate(with: userEmail) {
      showAlert = true
      alertMessage = "\n올바른 이메일 형식이 아닙니다.\n다시 확인해주세요."
    } else if userPassword.isEmpty {
      showAlert = true
      alertMessage = "\n비밀번호를 입력해주세요."
    } else if !passwordPredicate.evaluate(with: userPassword) {
      showAlert = true
      alertMessage = "\n잘못된 비밀번호입니다.\n다시 확인해주세요."
    } else {
      isMainViewPresented = true
    }
  }
}

#Preview {
  loginView()
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

class loginViewController: UIHostingController<loginView> {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: loginView())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
