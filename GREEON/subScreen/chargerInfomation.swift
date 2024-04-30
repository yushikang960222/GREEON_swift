//
//  chargerInfomation.swift
//
//
//  Created by Yushi Kang on 4/29/24.
//

import SwiftUI

struct chargerInfomation: View {
  @StateObject private var viewModel = iconDisplayViewModel()
  @State private var ProgressInCharge = false
  let Possible = ["available", "using", "error"]
  
  var body: some View {
    VStack(spacing: 10){
      ForEach(viewModel.iconDisplayCases, id: \.self) { iconDisplayCase in
        HStack{
          Spacer()
          VStack{
            ZStack{
              Rectangle()
                .frame(width: 90, height: 30)
                .cornerRadius(20)
                .foregroundColor(Color(hex: 0x0069cb))
              Text("7kWh") // kWh api 연결 필수
                .font(.custom("SUITE-ExtraBold", size: 16))
                .foregroundColor(Color(hex: 0xffffff))
              Image("available 1") // 사용가능 여부 api 연결 필수
                .offset(x: 38, y: -18)
            }
            Spacer().frame(height: 20)
            Text("1번 충전기") //MARK: - 충전기 번호 입력 필수
              .font(.custom("SUITE-Regular", size: 14))
              .foregroundColor(Color(hex: 0x545860))
          }
          Spacer()
          Spacer()
          Spacer()
          VStack(alignment: .leading){
            HStack(spacing: 0){
              Text("경과 시간 : ")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
              Text("시간 전 사용") // 최근 사용 시간 api 연결 필수
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
            }
            HStack(spacing: 0){
              Text("출차 예정 : ")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
              Text("정보 없음") // 충전 완료 시간 표기 필수
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundColor(Color(hex: 0x545860))
            }
            HStack{
              switch iconDisplayCase {
                case .ac_available:
                  HStack(spacing: 12) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .dc_available:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .chademo_available:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .nonfast_available:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .acAnddc_available:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .dcAndchademo_available:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .acAndchademo_available:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .dc_nonfast:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .ac_nonfast:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .chademo_nonfast:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .dc_chademo_ac:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .dc_chademo_nonfast:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .dc_ac_nonfast:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .chademo_ac_nonfast:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .allIcons:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_combo")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_icon")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    VStack{
                      IconDisplay(imageName: "non_fast")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        ProgressInCharge.toggle()
                        print("충전시작 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전시작")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0xffffff))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0x00ab84))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                      .fullScreenCover(isPresented: $ProgressInCharge, content: {
                        GREEON.ProgressInCharge()
                      })
                    }
                  }
                case .charging_1:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        print("충전중 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("충전 중")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0x545860))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0xd1d1d1))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                    }
                  }
                case .error_charger:
                  HStack(spacing: 10) {
                    VStack{
                      IconDisplay(imageName: "dc_nonavailable")
                      Text("DC콤보")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "chademo_nonavailable")
                      Text("DC차데모")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "ac3pin_nonavailable")
                      Text("AC3상")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    VStack{
                      IconDisplay(imageName: "nonfast_nonavailable")
                      Text("완속")
                        .font(.custom("SUITE-Medium", size: 10))
                        .foregroundColor(Color(hex: 0xd1d1d1))
                    }
                    HStack{
                      Spacer()
                      Spacer()
                      Button(action: {
                        print("고장 버튼 탭함")
                      }) {
                        HStack(spacing: 5) {
                          Text("고장")
                            .font(.custom("SUITE-Bold", size: 16))
                            .foregroundColor(Color(hex: 0x545860))
                        }
                        .frame(width: 80, height: 44)
                        .background(Color(hex: 0xd1d1d1))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                      }
                    }
                  }
              }
            }
          }
          Spacer()
        }
        Spacer().frame(height: 15)
      }
    }
  }
}

enum iconDisplayCase {
  case ac_available
  case dc_available
  case chademo_available
  case nonfast_available
  case acAnddc_available
  case dcAndchademo_available
  case acAndchademo_available
  case dc_nonfast
  case ac_nonfast
  case chademo_nonfast
  case dc_chademo_ac
  case dc_chademo_nonfast
  case dc_ac_nonfast
  case chademo_ac_nonfast
  case allIcons
  case charging_1
  case error_charger
}

class iconDisplayViewModel: ObservableObject {
  @Published var iconDisplayCases: [iconDisplayCase] = [.chademo_available, .error_charger, .charging_1]
}

struct IconDisplay: View {
  var imageName: String
  
  var body: some View {
    Image(imageName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 20, height: 20)
  }
}

#Preview {
  chargerInfomation()
}
