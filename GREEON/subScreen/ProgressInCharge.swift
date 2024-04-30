//
//  ProgressInCharge.swift
//  GREEON
//
//  Created by Yushi Kang on 4/29/24.
//

import SwiftUI

struct CircularProgressView: View {
  let progress: Double
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(
          Color(hex: 0xd1d1d1),
          lineWidth: 30
        )
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          Color(hex: 0x00ab84),
          style: StrokeStyle(
            lineWidth: 30,
            lineCap: .butt
          )
        )
        .rotationEffect(.degrees(-90))
        .animation(.easeOut, value: progress)
      
    }
  }
}

struct ProgressInCharge: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State var progress: Double = 0
  @State private var completeAlert = false
  @State private var navigateToChargeCompleteInfo = false
  
  var body: some View {
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
        Text("충전중입니다.")
          .font(.custom("SUITE-Bold", size: 24))
        Spacer()
      }
      Spacer().frame(height: 10)
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    ScrollView{
      VStack {
        Spacer().frame(height: 50)
        ZStack {
          CircularProgressView(progress: progress)
          VStack{
            Text("충전완료")
              .font(.custom("SUITE-Medium", size: 20))
            Spacer().frame(height: 20)
            Text("\(progress * 100, specifier: "%.0f")%")
              .font(.custom("SUITE-ExtraBold", size: 34))
              .foregroundColor(Color(hex: 0x00ab84))
          }
        }
        .frame(width: 180, height: 180)
        Spacer().frame(height: 50)
        Group{
          HStack{
            Spacer()
            VStack{
              Text("충전시간")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer().frame(height: 10)
              HStack{
                Text("시간")
                  .font(.custom("SUITE-Light", size: 14))
                  .foregroundColor(Color(hex: 0x545860))
                Text("분")
                  .font(.custom("SUITE-Light", size: 14))
                  .foregroundColor(Color(hex: 0x545860))
              }
            }
            Spacer()
            Divider()
            Spacer()
            VStack{
              Text("충전량")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer().frame(height: 10)
              HStack{
                Text("")
                  .font(.custom("SUITE-Light", size: 14))
                  .foregroundColor(Color(hex: 0x545860))
                Text("kWh")
                  .font(.custom("SUITE-Light", size: 14))
                  .foregroundColor(Color(hex: 0x545860))
              }
            }
            Spacer()
          }
          .frame(height: 50)
        }
        Spacer().frame(height: 30)
        HStack{
          Spacer().frame(width: 14)
          VStack{
            HStack{
              Text("시작 일시")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("") // 충전 시작 일시 api 연결 필수
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 20)
            HStack{
              Text("충전 금액")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("원") // 현재 충전 금액 api 연결 필수
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 20)
            HStack{
              Text("충전기 온도")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("℃")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 20)
            HStack{
              Text("배터리 잔량")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("kW 잔량")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 20)
            HStack{
              Text("충전 종료 예상시간")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
              Text("") // 충전 종료 예상시간 api 연결 필수
            }
          }
          Spacer().frame(width: 14)
        }
        Spacer().frame(height: 50)
        // 이 아래 부분은 삭제 필수 (실제 충전 퍼센트를 api로 연결하기 때문에 삭제 필수)
        HStack {
          Slider(value: $progress, in: 0...1) // 슬라이더 추가 및 범위 수정
            .padding(.horizontal, 20) // 슬라이더의 양쪽 여백 추가
        }
      }
    }
    .onChange(of: progress) { newValue in
      if Int(newValue) == 1 {
        completeAlert = true
      }
    }
    .alert(isPresented: $completeAlert) {
      HapticManager.instance.notification(type: .success)
      return Alert(title: Text("충전 완료"),
                   message: Text("\n충전이 완료되었습니다.\n확인버튼을 탭하여 결제내역을 확인하여 주세요."),
                   dismissButton: .default(Text("충전내역 확인")) {
        navigateToChargeCompleteInfo = true
      }
      )
    }
    .fullScreenCover(isPresented: $navigateToChargeCompleteInfo) {
      ChargeCompleteInfo()
    }
  }
}

struct ChargeCompleteInfo: View {
  var body: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: 60)
      HStack{
        Spacer().frame(width: 14)
        Text("충전 완료")
          .font(.custom("SUITE-Bold", size: 24))
        Spacer()
      }
      Spacer().frame(height: 10)
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    HStack{
      Spacer().frame(width: 14)
      VStack{
        Spacer().frame(height: 30)
        HStack{
          Text("충전이 완료되었습니다.\n아래 결제내역을 확인하여 주세요.")
            .font(.custom("SUITE-Medium", size: 18))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
        Spacer().frame(height: 20)
        Group{
          VStack{
            Divider()
          }
        }
        Spacer().frame(height: 20)
        HStack{
          Text("충전소 정보")
            .font(.custom("SUITE-Medium", size: 18))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
        Spacer().frame(height: 30)
        HStack{
          Text("시작일시")
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
          Text("") // 충전 시작 일시
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer().frame(height: 20)
        HStack{
          Text("종료일시")
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
          Text("") // 충전 종료 일시
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer().frame(height: 20)
        HStack{
          Text("충전시간")
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
          Text("") // 충전 소요 시간
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer().frame(height: 20)
        HStack{
          Text("충전량")
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
          Text("kWh") // 전체 충전 량
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer().frame(height: 20)
        HStack{
          Text("최종 결제 금액")
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
          Text("원")
            .font(.custom("SUITE-Medium", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer()
        HStack{
          Spacer()
          Button(action: {
            // 결제 api 연결 필수
            HapticManager.instance.impact(style: .rigid)
          }) {
            HStack {
              Text("결제하기")
                .font(.custom("SUITE-Regular", size: 16))
              ZStack{
                Rectangle()
                  .frame(width: 60, height: 60)
                  .cornerRadius(30)
                Image(systemName: "creditcard")
                  .resizable()
                  .frame(width: 27, height: 20)
                  .foregroundColor(Color(hex: 0xffffff))
              }
            }
          }
        }
      }
      Spacer().frame(width: 14)
    }
  }
}

#Preview {
  ChargeCompleteInfo()
}

#Preview {
  ProgressInCharge()
}
