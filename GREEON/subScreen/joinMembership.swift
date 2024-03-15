//
//  joinMembership.swift
//  GREEON
//
//  Created by Yushi Kang on 3/4/24.
//

import SwiftUI
import Combine
import UIKit
import WebKit

class ValidationViewModel: ObservableObject {
  @Published var userEmail: String = ""
  @Published var isCheckingDuplicate: Bool = false
  @Published var emailValidationResult: String?
  @Published var userPassword: String = ""
  @Published var passwordValidationResult: String?
  @Published var confirmPassword: String = ""
  @Published var confirmPasswordValidationResult: String?
  
  private var cancellables: Set<AnyCancellable> = []
  
  init() {
    // 이메일 검증과 중복 확인
    $userEmail
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .sink { [weak self] email in
        self?.validateEmail()
        withAnimation {
          self?.isCheckingDuplicate = true
        }
        self?.checkDuplicateEmail()
      }
      .store(in: &cancellables)
    
    // 비밀번호 검증
    $userPassword
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .sink { [weak self] password in
        self?.validatePassword()
      }
      .store(in: &cancellables)
  }
  
  func validateEmail() {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,}"
    let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: userEmail)
    self.emailValidationResult = isValid ? "" : "정확한 이메일 주소를 입력해주세요."
  }
  
  func checkDuplicateEmail() {
    guard !userEmail.isEmpty else {
      isCheckingDuplicate = false
      emailValidationResult = nil
      return
    }
    
    // 서버 API를 호출하여 이메일 중복 여부 확인
    
    // 3초 후에 확인완료를 위해 디스패치큐 적용
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.isCheckingDuplicate = false
      self.emailValidationResult = " 🎉 사용가능한 이메일입니다."
    }
  }
  
  func validatePassword() {
    guard !userPassword.isEmpty else {
      self.passwordValidationResult = nil
      self.validateConfirmPassword()
      return
    }
    
    let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&*'])[A-Za-z\\d@$!%*#?&]{8,}$"
    let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: userPassword)
    self.passwordValidationResult = isValid ? " 🔒 안전한 비밀번호 입니다." : "비밀번호는 영어 대, 소문자, 숫자, 특수문자를 조합한 8자리 이상이여야 합니다"
    
    self.validateConfirmPassword()
  }
  
  func validateConfirmPassword() {
    guard !confirmPassword.isEmpty else {
      self.confirmPasswordValidationResult = nil
      return
    }
    
    let isMatched = userPassword == confirmPassword
    self.confirmPasswordValidationResult = isMatched ? " ✅ 비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다"
  }
  
  subscript<T>(dynamicMember keyPath: KeyPath<ValidationViewModel, T>) -> T {
    self[keyPath: keyPath]
  }
}


struct joinMembership: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var userEmailVerify: String = ""
  @StateObject private var viewModel = ValidationViewModel()
  @State private var isShowingWeb = false
  @State private var selectedAddress: String? = ""
  @State private var userAddress: String = ""
  @State private var selectedCarBrandOption: String = "차량 제조사 선택"
  private let options = ["현대자동차", "기아자동차", "쉐보레", "테슬라", "BMW", "AUDI", "Mercedes-Benz", "VolksWagen", "토요타", "기타 (차량모델에 직접입력)"]
  @State private var userCarName: String = ""
  @State private var userCarNumber: String = ""
  @State private var showAlert: Bool = false
  @State private var alertTitle: String = ""
  @State private var alertMessage: String = ""
  
  //  @State private var mapApiData: String =
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Spacer().frame(height: 15)
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          HStack{
            Spacer().frame(width: 14)
            Image("back")
            Spacer()
          }
        }
        Spacer().frame(height: 23)
        HStack{
          Spacer().frame(width: 14)
          Text("회원가입")
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
      .background(Color.white)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
      Spacer().frame(height: 30)
    }
    ScrollView(showsIndicators: false){
      HStack{
        Spacer().frame(width: 14)
        VStack(alignment: .leading){
          Spacer().frame(height: 30)
          Text("기본정보 입력 (필수)")
            .font(.custom("SUITE-Bold", size: 22))
            .foregroundColor(Color(hex: 0xafafaf))
          Spacer().frame(height: 30)
          Text("이메일")
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          HStack {
            TextField("이메일 주소", text: $viewModel.userEmail)
              .keyboardType(.emailAddress)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .multilineTextAlignment(.leading)
              .font(.custom("SUITE-Regular", size: 16))
            Button(action: {
              // 버튼이 클릭되었을 때 수행할 동작
              print("인증받기버튼")
            }) {
              HStack{
                Text("인증받기") // 버튼에 표시될 텍스트
                  .font(.custom("SUITE-Bold", size: 16))
              }
              .foregroundColor(Color.white)
              .frame(width: 100, height: 33)
              .background(Color(hex: 0x00ab84))
              .cornerRadius(35)
            }
          }
          Spacer().frame(height: 10)
          HStack(spacing: 5) {
            if viewModel.isCheckingDuplicate {
              ProgressView()
            }
            
            if let result = viewModel.emailValidationResult {
              Text(result)
                .font(.custom("SUITE-Bold", size: 14))
                .foregroundColor(result == " 🎉 사용가능한 이메일입니다." ? Color(hex: 0x00ab84) : .red)
            }
          }
          
          Spacer().frame(height: 20)
          
          Text("인증번호")
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          HStack{
            TextField("인증번호", text: $userEmailVerify)
              .keyboardType(.numberPad)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .multilineTextAlignment(.leading)
              .font(.custom("SUITE-Regular", size: 16))
            Button(action: {
              // 버튼이 클릭되었을 때 수행할 동작
              print("인증확인버튼")
            }) {
              HStack{
                Text("인증확인") // 버튼에 표시될 텍스트
                  .font(.custom("SUITE-Bold", size: 16))
              }
              .foregroundColor(Color.white)
              .frame(width: 100, height: 33)
              .background(Color(hex: 0x0069cb))
              .cornerRadius(35)
            }
          }
          
          Spacer().frame(height: 30)
          
          Text("비밀번호")
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          SecureField("비밀번호", text: $viewModel.userPassword, onCommit: {
            viewModel.validatePassword()
          })
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .multilineTextAlignment(.leading)
          .font(.custom("SUITE-Regular", size: 16))
          
          Spacer().frame(height: 10)
          if let result = viewModel.passwordValidationResult {
            Text(result)
              .foregroundColor(result == " 🔒 안전한 비밀번호 입니다." ? Color(hex: 0x00ab84) : .red)
              .font(.custom("SUITE-Bold", size: 14))
          }
          
          Spacer().frame(height: 20)
          
          SecureField("비밀번호 확인", text: $viewModel.confirmPassword, onCommit: {
            viewModel.validateConfirmPassword()
          })
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .multilineTextAlignment(.leading)
          .font(.custom("SUITE-Regular", size: 16))
          .onChange(of: viewModel.confirmPassword) { _ in
            viewModel.validateConfirmPassword()
          }
          
          Spacer().frame(height: 10)
          if let result = viewModel.confirmPasswordValidationResult {
            Text(result)
              .foregroundColor(result == " ✅ 비밀번호가 일치합니다." ? Color(hex: 0x00ab84) : .red)
              .font(.custom("SUITE-Bold", size: 14))
          }
          
          Spacer().frame(height: 30)
          
          Text("이름 (변경 불가)")
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer().frame(height: 10)
          Text("이름이름") // 나중에 api 연결해야함 (PASS로 인증받은 유저의 이름)
            .font(.custom("SUITE-Bold", size: 20))
            .foregroundColor(Color(hex: 0x545860))
          
          Spacer().frame(height: 30)
          
          Text("자택주소")
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer().frame(height: 10)
          HStack{
            TextField("주소", text: Binding<String>(
              get: { selectedAddress ?? "" },
              set: { selectedAddress = $0 }
            ))
            .font(.custom("SUITE-Regular", size: 16))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.leading)
            .foregroundColor(Color(hex: 0x545860))
            .disabled(true)
            Button(action: {
              isShowingWeb.toggle()
              print("주소찾기 버튼")
            }) {
              HStack{
                Text("주소 찾기") // 버튼에 표시될 텍스트
                  .font(.custom("SUITE-Bold", size: 16))
              }
              .foregroundColor(Color.white)
              .frame(width: 100, height: 33)
              .background(Color(hex: 0x0069cb))
              .cornerRadius(35)
            }
            .sheet(isPresented: $isShowingWeb) {
              WebView(selectedAddress: Binding<String>(
                get: { selectedAddress ?? "" },
                set: { selectedAddress = $0 }
              ))
            }
          }
          Spacer().frame(height: 10)
          TextField("상세주소 입력", text: $userAddress)
            .font(.custom("SUITE-Regular", size: 16))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.leading)
            .foregroundColor(Color(hex: 0x545860))
          
          Spacer().frame(height: 30)
          
          Text("휴대폰 번호")
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer().frame(height: 10)
          HStack{
            Text("SKT") // pass api 연결 필수
              .font(.custom("SUITE-Regular", size: 18))
              .foregroundColor(Color(hex: 0xafafaf))
            Spacer()
            Text("01012345678") // pass api 연결 필수
              .font(.custom("SUITE-Regular", size: 18))
              .foregroundColor(Color(hex: 0xafafaf))
            Spacer()
            Text("인증완료")
              .font(.custom("SUITE-Regular", size: 18))
              .foregroundColor(Color(hex: 0xafafaf))
          }
          
          Spacer().frame(height: 40)
          
          Text("차량정보 입력 (선택)")
            .font(.custom("SUITE-Bold", size: 22))
            .foregroundColor(Color(hex: 0xafafaf))
          Spacer().frame(height: 30)
          Menu {
            ForEach(options, id: \.self) { option in
              Button(action: {
                selectedCarBrandOption = option
              }) {
                Label(option, systemImage: option)
              }
              .frame(height: 30)
            }
          }
        label: {
          HStack {
            Text(selectedCarBrandOption)
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
            Image(systemName: "chevron.down")
              .imageScale(.small)
          }
        }
          Spacer().frame(height: 20)
          TextField("차량명 입력", text: $userCarName)
            .font(.custom("SUITE-Regular", size: 16))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.leading)
            .foregroundColor(Color(hex: 0x545860))
          Spacer().frame(height: 20)
          TextField("차량번호 입력", text: $userCarNumber)
            .font(.custom("SUITE-Regular", size: 16))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.leading)
            .foregroundColor(Color(hex: 0x545860))
          Spacer().frame(height: 50)
          HStack{
            Spacer()
            Button(action: {
              self.performSignUp()
            }) {
              HStack {
                Text("회원가입")
                  .font(.custom("SUITE-Regular", size: 16))
                Image("apply")
              }
            }
            .alert(isPresented: $showAlert) {
              Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .cancel(Text("확인"))
              )
            }
          }
          Spacer().frame(height: 40)
        }
        Spacer().frame(width: 14)
      }
    }
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
  func performSignUp() {
    // 필수 정보 누락 여부 확인
    guard !viewModel.userEmail.isEmpty,
          !viewModel.userPassword.isEmpty,
          !viewModel.confirmPassword.isEmpty,
          let selectedAddress = selectedAddress,
          !selectedAddress.isEmpty,
          !userAddress.isEmpty else {
      // 누락된 정보가 있을 경우, 알림 표시
      alertTitle = "필수입력 항목 누락"
      alertMessage = "\n기본정보 중 누락된 항목이 있습니다.\n누락된 항목 없이 입력해주세요.\n"
      showAlert.toggle()
      return
    }
    
    // 여기에서 회원가입 로직 수행
    
  }
}

struct WebView: UIViewRepresentable {
  @Binding var selectedAddress: String
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    let url = URL(string: "https://www.google.com") // 카카오주소검색 페이지로 연결
    let request = URLRequest(url: url!)
    uiView.load(request)
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    var parent: WebView
    
    init(_ parent: WebView) {
      self.parent = parent
      super.init()
      
      let contentController = WKUserContentController()
      contentController.add(self, name: "selectedAddressHandler")
      
      let configuration = WKWebViewConfiguration()
      configuration.userContentController = contentController
      
      let webView = WKWebView(frame: .zero, configuration: configuration)
      parent.selectedAddress = ""
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      // 웹페이지 로드 완료 후 필요한 코드
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == "selectedAddressHandler", let address = message.body as? String {
        parent.selectedAddress = address
      }
    }
  }
}

#Preview {
  joinMembership()
}

class joinMembershipViewController: UIHostingController<joinMembership> {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: joinMembership())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
