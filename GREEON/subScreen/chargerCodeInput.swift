//
//  chargerCodeView.swift
//  GREEON
//
//  Created by Yushi Kang on 2/20/24.
//

import SwiftUI
import Combine

struct chargerCodeInput: View {
  
  @State private var inputValue: String = ""
  @State private var isTextFieldFocused: Bool = false
  @State private var showAlert: Bool = false
  @State private var isFullScreenModalPresented = false
  @State private var isLinkActive = false
  
  var body: some View {
    
    NavigationView { // NavigationView로 감싸기
      
      ZStack{
        
        VStack{
          
          Spacer().frame(height: 10)
          
          Rectangle()
            .frame(width: 40, height: 4)
            .foregroundColor(Color(hex: 0xd1d1d1))
            .cornerRadius(3)
          
          Spacer().frame(height: 20)
          
          HStack{
            
            Spacer().frame(width: 14)
            
            VStack(alignment: .leading) {
              
              Spacer().frame(height: 20)
              HStack(spacing: 0){
                Text("충전기 번호")
                  .font(.custom("SUITE-Bold", size: 30))
                  .foregroundColor(Color(hex: 0x00ab84))
                Text("를")
                  .font(.custom("SUITE-Bold", size: 30))
                  .foregroundColor(Color(hex: 0x545860))
              }
              Text("입력해주세요.")
                .font(.custom("SUITE-Bold", size: 30))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer()
          }
          Spacer().frame(height: 80)
          
          HStack{
            
            Spacer().frame(width: 14)
            
            TextField("충전기 번호 입력", text: $inputValue, onEditingChanged: { editing in
              isTextFieldFocused = editing
              // 보더 색상을 입력값에 따라 동적으로 변경
              if inputValue.count > 6 {
                isTextFieldFocused = true
              }
            })           .keyboardType(.numberPad)
              .padding()
              .textFieldStyle(PlainTextFieldStyle())
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .strokeBorder(
                    Color(hex: isTextFieldFocused ? 0x00ab84 : 0xd1d1d1),
                    lineWidth: 2
                  )
              )
              .font(.system(size: 24, weight: .bold))
              .onTapGesture {
                isTextFieldFocused = true
              }
              .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                isTextFieldFocused = true
              }
              .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                isTextFieldFocused = false
              }
              .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                handleInput()
              }
              .onTapGesture {
                hideKeyboard()
              }
              .onReceive(Just(inputValue)) { newValue in
                if newValue.count > 6 {
                  inputValue = String(newValue.prefix(6))
                  showAlert = true
                }
              }
            
            Spacer().frame(width: 14)
          }
          Spacer().frame(height: 80)
          
          HStack{
            
            Spacer()
            
              Button(action: {
                if inputValue.count > 6 {
                  showAlert = true
                } else {
                  isLinkActive.toggle()
                }
              }) {
                HStack {
                  Text("확인")
                    .font(.custom("SUITE-Regular", size: 16))
                  Image("apply")
                }
            }
              .fullScreenCover(isPresented: $isLinkActive, content: {
                chargerSelectView()
              })
            .padding(5) // 버튼 주위에 여백 추가
            .alert(isPresented: $showAlert) {
              Alert(title: Text("입력 오류"), message: Text("\n충전기 번호는 6자리여야 합니다.\n"), dismissButton: .default(Text("확인")))
            }
            
            Spacer().frame(width: 14)
          }
          Spacer()
        }
      }
    }
  }
  
  func handleInput() {
    // 입력된 숫자에 대한 처리를 여기에 추가
    if inputValue.count > 6 {
      inputValue = String(inputValue.prefix(6))
      showAlert = true
    }
    if let number = Int(inputValue) {
      print("유효한 숫자: \(number)")
      // 여기에서 숫자 처리 로직을 추가
    } else {
      print("유효하지 않은 숫자")
      // 유효하지 않은 숫자에 대한 처리 로직을 추가
    }
  }
  
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

#Preview {
  chargerCodeInput()
}

class chergerCodeInputController: UIHostingController<chargerCodeInput> {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: chargerCodeInput())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
