//
//  myGreeOn.swift
//  GREEON
//
//  Created by Yushi Kang on 2/26/24.
//

import SwiftUI

struct settingsView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  @State var switchLocationAllowToggle = true
  @State var switchPushAlertToggle = true
  @State var switchPushMarketingToggle = true
  @State var switchAutoLoginToggle = false
  
  var body: some View {
    VStack{
      VStack(alignment: .leading) {
        Spacer().frame(height: 15)
        HStack{
          Spacer().frame(width: 14)
        Button(action: {
          presentationMode.wrappedValue.dismiss()
          HapticManager.instance.notification(type: .success)
        }) {
            Image("back")
          }
          Spacer()
        }
        Spacer().frame(height: 23)
        HStack{
          Spacer().frame(width: 14)
          Text("환경설정")
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
      .background(Color.white)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
      Spacer().frame(height: 30)
      HStack{
        Spacer().frame(width: 14)
        VStack(alignment: .leading){
          Text("위치서비스 및 알림")
            .font(.custom("SUITE-ExtraBold", size: 20))
            .foregroundColor(Color(hex: 0xa0a0a0))
          Spacer().frame(height: 30)
          Toggle("위치기반 서비스 이용 동의", isOn: $switchLocationAllowToggle)
            .font(.custom("SUITE-Regular", size: 16))
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: 0x00ab84)))
          Spacer().frame(height: 30)
          Toggle("푸시 알림", isOn: $switchPushAlertToggle)
            .font(.custom("SUITE-Regular", size: 16))
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: 0x00ab84)))
          Spacer().frame(height: 30)
          Toggle("이벤트 및 혜택 알림", isOn: $switchPushMarketingToggle)
            .font(.custom("SUITE-Regular", size: 16))
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: 0x0069cb)))
          Spacer().frame(height: 40)
          Text("로그인")
            .font(.custom("SUITE-ExtraBold", size: 20))
            .foregroundColor(Color(hex: 0xa0a0a0))
          Spacer().frame(height: 30)
          Toggle("자동 로그인", isOn: $switchAutoLoginToggle)
            .font(.custom("SUITE-Regular", size: 16))
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: 0x0069cb)))
          Spacer().frame(height: 40)
          Text("앱 관리")
            .font(.custom("SUITE-ExtraBold", size: 20))
            .foregroundColor(Color(hex: 0xa0a0a0))
          Spacer().frame(height: 30)
          HStack{
            Text("앱 버전")
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
            VersionView()
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
          }
          Spacer()
        }
        Spacer().frame(width: 14)
      }
    }
  }
}

struct VersionView: View {
  var body: some View {
    if let appVersion = getAppVersion() {
      return Text("Ver \(appVersion)")
    } else {
      return Text("버전을 확인할 수 없습니다.")
    }
  }
  
  func getAppVersion() -> String? {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      return version
    }
    return nil
  }
}

#Preview {
  settingsView()
}

