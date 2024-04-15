//
//  Home.swift
//  GREEON_SwiftUi
//
//  Created by Yushi Kang on 2/17/24.
//

import SwiftUI

struct Home: View {
  @State var index = 0
  @State var circlePosition: CGFloat = 0
  @State private var isnoticeAndfaqPresented = false
  @State private var isinquiryPresented = false
  
  var body: some View {
    ZStack{
      Color(hex: 0xf3f4f5)
        .edgesIgnoringSafeArea(.all)
      VStack{
        ZStack{
          VStack {
            Spacer().frame(height: 10)
            Image("logo")
              .resizable()
              .frame(width: 140, height: 26)
            Spacer().frame(height: 15)
          }
        }
        //스크롤 뷰 (스크롤 인디케이터 숨김)
        ScrollView(showsIndicators: false){
          VStack{
            HStack{
              Spacer()
              Image("clip-path-group")
              Spacer().frame(width: 14)
            }
            Spacer().frame(height: 10)
            HStack(spacing: 0){
              Spacer().frame(width: 14)
              Text("복잡한")
                .font(.custom("SUITE-Light", size: 22))
              Spacer().frame(width: 5)
              Text("회원가입")
                .font(.custom("SUITE-Bold", size: 22))
                .foregroundColor(Color(hex: 0x428fec))
              Text("과")
                .font(.custom("SUITE-Light", size: 22))
              Spacer()
            }
            HStack(spacing: 0){
              Spacer().frame(width: 14)
              Text("번거로운")
                .font(.custom("SUITE-Light", size: 22))
              Spacer().frame(width: 5)
              Text("충전기 결제")
                .font(.custom("SUITE-Bold", size: 22))
                .foregroundColor(Color(hex: 0x0069cb))
              Text("를")
                .font(.custom("SUITE-Light", size: 22))
              Spacer()
            }
            HStack(spacing: 0){
              Spacer().frame(width:14)
              Text("손쉽고 간편하게")
                .font(.custom("SUITE-Bold", size: 22))
                .foregroundColor(Color(hex: 0x00ab84))
              Spacer()
            }
            Spacer().frame(height: 20)
            ZStack{
              Color(hex: 0xffffff)
              VStack{
                Spacer().frame(height: 30)
                HStack(spacing: 0){
                  Spacer().frame(width: 14)
                  Text("님의")
                    .font(.custom("SUITE-Bold", size: 18))
                  Spacer().frame(width: 5)
                  Text("충전 내역")
                    .font(.custom("SUITE-Bold", size: 18))
                  Spacer()
                }
                Spacer().frame(height: 20)
                HStack{
                  Spacer().frame(width: 20)
                  VStack(alignment: .leading) {
                    Text("충전량")
                      .font(.custom("SUITE-Medium", size: 16))
                    Spacer().frame(height: 5)
                    Text("kWh")
                  }
                  Spacer()
                  Image("red_path")
                  Spacer().frame(width: 20)
                }
                Spacer().frame(height: 20)
                HStack{
                  Spacer().frame(width: 20)
                  VStack(alignment: .leading) {
                    Text("충전금액")
                      .font(.custom("SUITE-Medium", size: 16))
                    Spacer().frame(height: 5)
                    Text("원")
                      .font(.custom("SUITE-Medium", size: 16))
                  }
                  Spacer()
                  Image("yellow_path")
                  Spacer().frame(width: 20)
                }
                Spacer().frame(height: 20)
                HStack{
                  Spacer().frame(width: 20)
                  VStack(alignment: .leading) {
                    Text("충전횟수")
                      .font(.custom("SUITE-Medium", size: 16))
                    Spacer().frame(height: 5)
                    Text("회")
                      .font(.custom("SUITE-Medium", size: 16))
                  }
                  Spacer()
                  Image("green_path")
                  Spacer().frame(width: 20)
                }
                Spacer().frame(height: 30)
                HStack{
                  Spacer().frame(width: 14)
                  Text("자주 이용한 충전소")
                    .font(.custom("SUITE-Bold", size: 18))
                  Spacer()
                }
                Spacer().frame(height: 10)
                
                //가로 스크롤 뷰 (스크롤 인디케이터 숨김)
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack{
                    Spacer().frame(width: 20)
                    Button(action: {
                      // 버튼이 클릭되었을 때 동작
                    }) {
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0xd1d1d1), lineWidth: 1)
                        .frame(width: 130, height: 60)
                        .background(Color.white)
                    }
                    .foregroundColor(.white)
                    Spacer().frame(width: 14)
                    Button(action: {
                      // 버튼이 클릭되었을 때 동작
                    }) {
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0xd1d1d1), lineWidth: 1)
                        .frame(width: 130, height: 60)
                        .background(Color.white)
                    }
                    .foregroundColor(.white)
                    Spacer().frame(width: 14)
                    Button(action: {
                      // 버튼이 클릭되었을 때 동작
                    }) {
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0xd1d1d1), lineWidth: 1)
                        .frame(width: 130, height: 60)
                        .background(Color.white)
                    }
                    .foregroundColor(.white)
                    Spacer().frame(width: 14)
                    Button(action: {
                      // 버튼이 클릭되었을 때 동작
                    }) {
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0xd1d1d1), lineWidth: 1)
                        .frame(width: 130, height: 60)
                        .background(Color.white)
                    }
                    .foregroundColor(.white)
                    Spacer().frame(width: 20)
                  }
                  Spacer().frame(width: 20)
                }
                Spacer().frame(height: 30)
                HStack{
                  Spacer().frame(width: 14)
                  Text("나의 충전 패턴")
                    .font(.custom("SUITE-Bold", size: 18))
                  Spacer()
                }
                GeometryReader { geometry in
                  HStack {
                    Spacer().frame(width: 20)
                    
                    Button(action: {
                      // 버튼이 클릭되었을 때 동작
                      HapticManager.instance.impact(style: .rigid)
                    }) {
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0xd1d1d1), lineWidth: 1)
                        .frame(width: min(geometry.size.width - 40, 500), height: 60)
                        .background(Color.white)
                        .overlay(
                          VStack{
                            Text("자주 이용하는 패턴을 분석해 결제를 더 손쉽게 할 수 있어요.")
                              .font(.custom("SUITE-Regular", size: 14))
                          }
                            .foregroundColor(Color(hex: 0x545860))
                        )
                    }
                    Spacer().frame(width: 20)
                  }
                }
                Spacer().frame(height: 90)
                
                GeometryReader { geometry in
                  HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                      // 버튼이 클릭되었을 때 동작
                      HapticManager.instance.impact(style: .rigid)
                    }) {
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0x545860), lineWidth: 1)
                        .frame(width: min(geometry.size.width / 2.2, 200), height: min(geometry.size.width / 2.2, 200))
                        .background(Color.white)
                        .overlay(
                          VStack{
                            Spacer()
                            Image("charger_black")
                            Spacer().frame(height: 20)
                            Text("충전기 설치 신청")
                              .font(.custom("SUITE-Medium", size: 16))
                            Spacer()
                          }
                            .foregroundColor(Color(hex: 0x545860))
                        )
                    }
                    Spacer()
                    VStack(alignment:.leading, spacing: 10) {
                      Button(action: {
                        isnoticeAndfaqPresented.toggle()
                        HapticManager.instance.impact(style: .rigid)
                      }) {
                        RoundedRectangle(cornerRadius: 10)
                          .stroke(Color(hex: 0xef3346), lineWidth: 1)
                          .frame(width: min(geometry.size.width / 2.2, 195), height: (min(geometry.size.width / 2.2, 195) / 2) - 5)
                          .background(Color.white)
                          .overlay(
                            HStack{
                              Spacer().frame(width: 22)
                              Image("notice")
                              Spacer()
                              Text("공지사항&FAQ")
                                .font(.custom("SUITE-Medium", size: 16))
                              Spacer()
                            }
                              .foregroundColor(Color(hex: 0x545860))
                          )
                      }
                      .fullScreenCover(isPresented: $isnoticeAndfaqPresented, content: {
                        noticeAndfaq()
                      })
                      Button(action: {
                        isinquiryPresented.toggle()
                        HapticManager.instance.impact(style: .rigid)
                      }) {
                        RoundedRectangle(cornerRadius: 10)
                          .stroke(Color(hex: 0xff9800), lineWidth: 1)
                          .frame(width: min(geometry.size.width / 2.2, 195), height: (min(geometry.size.width / 2.2, 195) / 2) - 5)
                          .background(Color.white)
                          .overlay(
                            HStack{
                              Spacer().frame(width: 22)
                              Image("support")
                              Spacer()
                              Text("1:1문의")
                                .font(.custom("SUITE-Medium", size: 16))
                              Spacer()
                            }
                              .foregroundColor(Color(hex: 0x545860))
                          )
                      }
                      .fullScreenCover(isPresented: $isinquiryPresented, content: {
                        inquiry()
                      })
                    }
                    Spacer()
                  }
                }
                Spacer().frame(height: 260)
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  Home()
}

// SwiftUI를 UIKit으로 호스팅하기 위한 UIViewController
class HomeViewController: UIHostingController<Home> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: Home())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

