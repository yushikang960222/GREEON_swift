//
//  myGreeon.swift
//  GREEON
//
//  Created by Yushi Kang on 2/27/24.
//

import SwiftUI
import UIKit

// UIKit으로 래핑한 SwiftUI 컨트롤러 생성
struct chargerCodeInputWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIViewController {
    let chargerCodeInputController = UIHostingController(rootView: chargerCodeInput())
    return chargerCodeInputController
  }
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}

struct receiptViewWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIViewController {
    let receiptViewController = UIHostingController(rootView: receiptView())
    return receiptViewController
  }
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}

struct myGreeon: View {
  @State private var issettingsViewPresented = false
  @State private var isnotiCenterPresented = false
  @State private var isChargerCodeInputPresented = false
  @State private var isreceiptViewPresented = false
  @State private var isminwonCenterPresented = false
  @State private var iseventViewPresented = false
  @State private var showAlert = false
  @State private var islogoutPresented = false
  
  var body: some View {
    ZStack{
      VStack{
        VStack(alignment: .leading) {
          Spacer().frame(height: 60)
          HStack{
            Spacer().frame(width: 14)
            Text("나의 그리온")
              .font(.custom("SUITE-Bold", size: 24))
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        
        ScrollView(showsIndicators: false){
          VStack{
            Spacer().frame(height: 50)
            HStack(spacing: 5){
              Text("") // api로 유저정보 불러와야함
                .font(.custom("SUITE-ExtraBold", size: 20))
                .foregroundColor(Color(hex: 0x00ab84))
              Text("님 반가워요!")
                .font(.custom("SUITE-ExtraBold", size: 20))
                .foregroundColor(Color(hex: 0x545860))
            }
            Spacer().frame(height: 10)
            HStack{
              Text("내 포인트 :")
                .font(.custom("SUITE-ExtraBold", size: 20))
                .foregroundColor(Color(hex: 0x545860))
              Text("P")
                .font(.custom("SUITE-ExtraBold", size: 20))
                .foregroundColor(Color(hex: 0x00ab84))
            }
            Spacer().frame(height: 30)
            
            GeometryReader { geometry in
              HStack {
                Spacer().frame(width: 14)
                
                Button(action: {
                  isnotiCenterPresented.toggle()
                }) {
                  RoundedRectangle(cornerRadius: 10)
                    .frame(width: min(geometry.size.width / 3.5, 200), height: min(geometry.size.width / 3.5, 200))
                    .background(Color.white)
                    .overlay(
                      VStack{
                        Spacer()
                        Image("alert")
                        Spacer()
                        Text("알림센터")
                          .font(.custom("SUITE-Medium", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                        Spacer()
                      }
                    )
                    .foregroundColor(Color(hex: 0xffffff))
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .fullScreenCover(isPresented: $isnotiCenterPresented, content: {
                  notiCenter()
                })
                Spacer()
                Button(action: {
                  // 버튼이 클릭되었을 때 동작
                }) {
                  RoundedRectangle(cornerRadius: 10)
                    .frame(width: min(geometry.size.width / 3.5, 200), height: min(geometry.size.width / 3.5, 200))
                    .background(Color.white)
                    .overlay(
                      VStack{
                        Spacer()
                        Image("account")
                        Spacer()
                        Text("개인정보 관리")
                          .font(.custom("SUITE-Medium", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                        Spacer()
                      }
                    )
                    .foregroundColor(Color(hex: 0xffffff))
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                Spacer()
                Button(action: {
                  issettingsViewPresented.toggle()
                }) {
                  RoundedRectangle(cornerRadius: 10)
                    .frame(width: min(geometry.size.width / 3.5, 200), height: min(geometry.size.width / 3.5, 200))
                    .background(Color.white)
                    .overlay(
                      VStack{
                        Spacer()
                        Image("settings")
                        Spacer()
                        Text("환경설정")
                          .font(.custom("SUITE-Medium", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                        Spacer()
                      }
                    )
                    .foregroundColor(Color(hex: 0xffffff))
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                Spacer().frame(width: 14)
                  .fullScreenCover(isPresented: $issettingsViewPresented, content: {
                    settingsView()
                  })
              }
            }
            Spacer().frame(height: 150)
            HStack{
              Spacer().frame(width: 14)
              VStack(alignment: .leading) {
                Text("충전/결제")
                  .font(.custom("SUITE-ExtraBold", size: 20))
                  .foregroundColor(Color(hex: 0xa0a0a0))
                Spacer().frame(height: 30)
                Button(action: {
                  isChargerCodeInputPresented.toggle()
                }) {
                  Text("충전기 번호로 찾기")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                .sheet(isPresented: $isChargerCodeInputPresented, content: {
                  chargerCodeInputWrapper()
                })
                Spacer().frame(height: 40)
                Text("이용내역")
                  .font(.custom("SUITE-ExtraBold", size: 20))
                  .foregroundColor(Color(hex: 0xa0a0a0))
                Spacer().frame(height: 30)
                Button(action: {
                  isreceiptViewPresented.toggle()
                }) {
                  Text("나의 이용내역")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                .sheet(isPresented: $isreceiptViewPresented, content: {
                  receiptViewWrapper()
                })
                Spacer().frame(height: 40)
                Text("고객지원")
                  .font(.custom("SUITE-ExtraBold", size: 20))
                  .foregroundColor(Color(hex: 0xa0a0a0))
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("공지사항&FAQ")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 30)
                Button(action: {
                  iseventViewPresented.toggle()
                }) {
                  Text("이벤트")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                .fullScreenCover(isPresented: $iseventViewPresented, content: {
                  eventView()
                })
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("1:1문의")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("고장신고")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("충전기설치신청")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 30)
                Button(action: {
                  isminwonCenterPresented.toggle()
                }) {
                  Text("불편민원신고센터")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                .fullScreenCover(isPresented: $isminwonCenterPresented, content: {
                  minwonCenter()
                })
                Spacer().frame(height: 40)
                Text("GREEON")
                  .font(.custom("SUITE-ExtraBold", size: 20))
                  .foregroundColor(Color(hex: 0xa0a0a0))
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("GREEON 소개")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("통합서비스이용약관")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 30)
                Button(action: {
                  // 버튼 선택시
                }) {
                  Text("개인정보처리방침")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                }
                Spacer().frame(height: 50)
              }
              Spacer()
            }
            Button(action: {
              self.showAlert = true
            }) {
              Text("로그아웃")
                .font(.custom("SUITE-Medium", size: 16))
                .foregroundColor(Color(hex: 0x545860))
                .underline()
            }
            .alert(isPresented: $showAlert) {
              Alert(title: Text("로그아웃"), message: Text("정말 로그아웃 하시겠습니까?"), primaryButton: .destructive(Text("로그아웃")) {
                islogoutPresented.toggle()
              }, secondaryButton: .cancel(Text("취소")))
            }
            Spacer().frame(height: 100)
          }
          .fullScreenCover(isPresented: $islogoutPresented) {
              loginView()
          }
        }
      }
    }
  }
}


#Preview {
  myGreeon()
}

class myGreeonViewController: UIHostingController<myGreeon> {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder, rootView: myGreeon())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


