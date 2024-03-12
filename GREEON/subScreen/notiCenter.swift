//
//  notiCenter.swift
//  GREEON
//
//  Created by Yushi Kang on 2/27/24.
//

import SwiftUI

struct notiCenter: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  var body: some View {
    ZStack{
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
          Text("알림센터")
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
      .background(Color.white)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
      Spacer().frame(height: 30)
    }
    ScrollView{
      VStack{
        Spacer().frame(height: 30)
        HStack(spacing: 10){
          Spacer().frame(width: 14)
          Image("notification")
          Spacer().frame(width: 10)
          VStack(alignment: .leading){
            HStack{
              Text("충전 완료 안내")
                .font(.custom("SUITE-Bold", size: 18))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("1분 전")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 5)
            Text("충전이 완료되었습니다.\nGREEON을 이용해주셔서 감사합니다.")
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
          }
          Spacer()
        }
        Spacer().frame(height: 20)
        HStack{
          Spacer().frame(width: 14)
          LineView()
          Spacer().frame(width: 14)
        }
        Spacer().frame(height: 20)
        HStack(spacing: 10){
          Spacer().frame(width: 14)
          Image("notification")
          Spacer().frame(width: 10)
          VStack(alignment: .leading){
            HStack{
              Text("충전 종료 안내")
                .font(.custom("SUITE-Bold", size: 18))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("16분 전")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 5)
            Text("충전 종료 15분 전입니다.\n다음 이용자를 위해 종료시간에 맞춰 차량을 이동 주차 해주시기 바랍니다.")
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
          }
          Spacer()
        }
      } // 한 덩어리
      Spacer()
    }
    Spacer()
  }
}

#Preview {
    notiCenter()
}
