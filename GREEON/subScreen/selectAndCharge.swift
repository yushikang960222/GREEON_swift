//
//  selectAndCharge.swift
//  GREEON
//
//  Created by Yushi Kang on 2/22/24.
//

import SwiftUI

struct selectAndCharge: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack{
      VStack{
        Spacer().frame(height: 10)
        HStack{
          Spacer().frame(width: 10)
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          })
          {
            HStack(spacing: 2){
              Image("back")
            }
          }
          Spacer()
        }
        Spacer()
        ZStack{
          ScrollView{
            VStack{
              Spacer().frame(height: 10)
              HStack{
                Spacer().frame(width: 14)
                Text("어쩌구저쩌구")
                  .font(.custom("SUITE-Bold", size: 24))
                  .foregroundColor(Color(hex: 0x545860))
                Spacer()
              }
              Spacer().frame(height: 14)
              HStack(spacing: 5){
                Spacer().frame(width: 14)
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
                    
                    Text("새로고침") // 버튼에 표시될 텍스트
                      .font(.custom("SUITE-Bold", size: 12))
                      .foregroundColor(Color.white)
                  }
                  .frame(width: 85, height: 24)
                  .background(Color(hex: 0x545860))
                  .cornerRadius(35)
                }
                Spacer().frame(width: 14)
              }
              Spacer().frame(height: 20)
              HStack{
                Spacer().frame(width: 14)
                LineView()
                Spacer().frame(width: 14)
              }
              HStack{
                Spacer().frame(width: 14)
                Text("충전 가능한 충전기 종류")
                  .font(.custom("SUITE-Regular", size: 16))
                  .foregroundColor(Color(hex: 0x545860))
                Spacer()
              }
            }// vstack 마지막 라인
          }
        }
      }
    }
  }
  func getCurrentTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm분 "
    return dateFormatter.string(from: Date())
  }
}


#Preview {
  selectAndCharge()
}
