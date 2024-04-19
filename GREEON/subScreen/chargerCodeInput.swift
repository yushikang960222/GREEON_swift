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
  @State private var alertMessage: String = ""
  @State private var isFullScreenModalPresented = false
  @State private var isLinkActive = false
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack {
          Spacer().frame(height: 10)
          Rectangle()
            .frame(width: 40, height: 4)
            .foregroundColor(Color(hex: 0xd1d1d1))
            .cornerRadius(3)
          Spacer().frame(height: 20)
          HStack {
            Spacer().frame(width: 14)
            VStack(alignment: .leading) {
              Spacer().frame(height: 20)
              HStack(spacing: 0) {
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
          HStack {
            Spacer().frame(width: 14)
            TextField("충전기 번호 입력", text: $inputValue, onEditingChanged: { editing in
              isTextFieldFocused = editing
            })
            .keyboardType(.numberPad)
            .padding()
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                  Color(hex: isTextFieldFocused ? 0x00ab84 : 0xd1d1d1),
                  lineWidth: 2
                )
            )
            .font(.custom("SUITE-Bold", size: 24))
            .onTapGesture {
              isTextFieldFocused = true
            }
            .onReceive(Just(inputValue)) { newValue in
              if newValue.count > 6 {
                inputValue = String(newValue.prefix(6))
                showAlert = true
                alertMessage = "\n6자리보다 많은 숫자를 입력할 수 없습니다."
              }
            }
            Spacer().frame(width: 14)
          }
          Spacer().frame(height: 80)
          HStack {
            Spacer()
            Button(action: {
              if inputValue.isEmpty {
                showAlert = true
                alertMessage = "\n충전기 번호를 입력해주세요."
              } else if inputValue.count < 6 {
                showAlert = true
                alertMessage = "\n충전기 번호는 6자리여야 합니다."
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
            .padding(5)
            Spacer().frame(width: 14)
          }
          Spacer()
        }
        .fullScreenCover(isPresented: $isLinkActive, content: {
          chargerSelectView()
        })
      }
    }
    .alert(isPresented: $showAlert) {
      HapticManager.instance.notification(type: .error)
      return Alert(
      title: Text("입력 오류"), message: Text(alertMessage), dismissButton: .cancel(Text("확인")))
    }
  }
  
  func handleInput() {
    if inputValue.count < 6 {
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
