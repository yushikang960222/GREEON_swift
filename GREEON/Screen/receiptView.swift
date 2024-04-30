//
//  receiptView.swift
//  GREEON
//
//  Created by Yushi Kang on 2/28/24.
//

import SwiftUI

struct receiptView: View {
  @State private var searchStartDate = Date()
  @State private var searchEndDate = Date()
  
  struct chargeInfo {
    var date: String
    var time: String
    var stationName: String
    var paymentMethod: String
    var paymentAmount: String
  }
  
  let chargeInfos: [chargeInfo] = [
    chargeInfo(date: "2022-03-07",
               time: "12:34:00 ~ 13:01:31",
               stationName: "충전소1",
               paymentMethod: "신용카드",
               paymentAmount: "₩50,000") // api로 연결 필수
  ]
  
  var body: some View {
      VStack(alignment: .leading) {
        Spacer().frame(height: 60)
        HStack{
          Spacer().frame(width: 14)
          Text("이용내역")
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
      .background(Color.white)
      .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    HStack{
      Spacer().frame(width: 14)
      VStack(alignment: .leading){
        Spacer().frame(height: 20)
        HStack{
          Text("날짜조회")
            .font(.custom("SUITE-ExtraBold", size: 22))
            .foregroundColor(Color(hex: 0xafafaf))
          Spacer()
        }
        Spacer().frame(height: 20)
        HStack{
          Text("시작날짜")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x00ab84))
          Spacer().frame(width: 0)
          DatePicker(selection: $searchStartDate, in: ...Date(), displayedComponents: .date) {
          }
          .environment(\.locale, Locale(identifier: "Ko-KR"))
//          Spacer().frame(maxWidth: .infinity) // 프레임 치수가 정확하지 않은것 같다고 떠도 상관 없음 (UI상 보여주는거에 대해 문제 없음)
          Text("종료날짜")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x0069cb))
          Spacer().frame(width: 0)
          DatePicker(selection: $searchEndDate, in: ...Date(), displayedComponents: .date){
          }
          .environment(\.locale, Locale(identifier: "Ko-KR"))
          Spacer().frame(width: 14)
        }
        Spacer().frame(height: 20)
        Text("\(formattedDate(searchStartDate)) 부터 \(formattedDate(searchEndDate)) 까지의 이용내역입니다.")
          .font(.custom("SUITE-Regular", size: 16))
          .foregroundColor(Color(hex: 0x545860))
        Spacer().frame(height: 20)
      }
    }
    Divider()
      .frame(width: 600)
      .foregroundColor(Color(hex: 0x545860))
    ScrollView{
      VStack{
        ForEach(chargeInfos, id: \.date) { chargeInfo in
          chargeInfoView(chargeInfo: chargeInfo)
        }
      }
    }
  }
  func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
  }
}

struct chargeInfoView: View {
  var chargeInfo: receiptView.chargeInfo
  
  var body: some View {
    Button(action: {
      // 버튼 선택시 동작
    }) {
      VStack {
        Spacer().frame(height: 30)
        HStack {
          Spacer().frame(width: 20)
          Text("충전날짜 : ")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Text(chargeInfo.date)
            .font(.custom("SUITE-Regular", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
        Spacer().frame(height: 10)
        HStack {
          Spacer().frame(width: 20)
          Text("충전시간 : ")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Text(chargeInfo.time)
            .font(.custom("SUITE-Regular", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
        Spacer().frame(height: 10)
        HStack {
          Spacer().frame(width: 20)
          Text("충전소명 : ")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Text(chargeInfo.stationName)
            .font(.custom("SUITE-Regular", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
        Spacer().frame(height: 10)
        HStack {
          Spacer().frame(width: 20)
          Text("결제수단 : ")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Text(chargeInfo.paymentMethod)
            .font(.custom("SUITE-Regular", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
        Spacer().frame(height: 10)
        HStack {
          Spacer().frame(width: 20)
          Text("결제금액 : ")
            .font(.custom("SUITE-Bold", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Text(chargeInfo.paymentAmount)
            .font(.custom("SUITE-Regular", size: 14))
            .foregroundColor(Color(hex: 0x545860))
          Spacer()
        }
      }
    }
    Spacer().frame(height: 20)
    HStack{
      Spacer().frame(width: 14)
      LineView()
      Spacer().frame(width: 14)
    }
    Spacer().frame(height: 20)
  }
}
  


#Preview {
  receiptView()
}

class receiptViewController: UIHostingController<receiptView> {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: receiptView())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
