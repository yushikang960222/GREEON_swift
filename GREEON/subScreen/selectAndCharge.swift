//
//  selectAndCharge.swift
//  GREEON
//
//  Created by Yushi Kang on 2/22/24.
//

import SwiftUI

struct selectAndCharge: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject private var viewModel = iconDisplayViewModel()
  @State private var ProgressInCharge = false
  
  var body: some View {
    ZStack{
      VStack(alignment: .leading) {
        Spacer().frame(height: 15)
        HStack{
          Spacer().frame(width: 14)
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          }) {
            Image("back")
          }
          Spacer()
        }
        Spacer().frame(height: 23)
        HStack{
          Spacer().frame(width: 14)
          Text("어쩌구저쩌구") // 충전소명 api 추가 필수
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
      .background(Color.white)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
      Spacer().frame(height: 30)
    }
    HStack{
      Spacer().frame(width: 14)
      ScrollView{
        HStack(alignment: .center){
          VStack(alignment: .center){
            Spacer().frame(height: 30)
            HStack(spacing: 5){
              Image("logo")
                .resizable()
                .frame(width: 54,height: 10)
              Text("| " + getCurrentTime() + "기준 충전기 현황")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Button(action: {
                // 버튼이 클릭되었을 때 수행할 동작
                print("싱크버튼 터치했어오")
              }) {
                HStack(spacing: 5) {
                  Image("sync")
                  
                  Text("새로고침")
                    .font(.custom("SUITE-Bold", size: 12))
                    .foregroundColor(Color.white)
                }
                .frame(width: 85, height: 24)
                .background(Color(hex: 0x545860))
                .cornerRadius(35)
              }
            }
            Spacer().frame(height: 20)
            HStack{
              Text("충전 가능한 충전기 종류")
                .font(.custom("SUITE-Regular", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
            }
          }
        }
        Spacer().frame(height: 30)
        HStack{
          VStack(alignment: .leading){
            HStack{
              Text("완속 충전기")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
            }
            Spacer().frame(height: 20)
          }
        }
        VStack{
          HStack{
            chargerInfomation()
          }
        }
        Spacer()
      }
      Spacer().frame(width: 14)
    }
  }
  
  func getCurrentTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm분"
    return dateFormatter.string(from: Date())
  }
}



#Preview {
  selectAndCharge()
}
