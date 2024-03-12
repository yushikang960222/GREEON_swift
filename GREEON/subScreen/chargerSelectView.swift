//
//  chargerSelectView.swift
//  GREEON
//
//  Created by Yushi Kang on 2/20/24.
//

import SwiftUI
import Combine

struct chargerSelectView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var offset: CGSize = .zero
  @StateObject private var viewModel = ImageViewModel()
  @State private var isselectAndChargePresented = false
  
  var body: some View {
    ZStack{
      VStack{
        Spacer().frame(height: 15)
        HStack{
          Spacer().frame(width: 10)
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          })
          {
            HStack(spacing: 5){
              Image("back")
            }
          }
          Spacer()
        }
        Spacer().frame(height: 15)
        ZStack{
          Spacer().frame(height: 15)
          ScrollView(showsIndicators: false) {
            
            ZStack(alignment: .bottomTrailing) {
              VStack {
                Image("mask-group-2")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              }
              
              Button(action: {
                // 버튼이 클릭되었을 때 수행할 동작
                isselectAndChargePresented.toggle()
              }) {
                HStack {
                  Image("ev_chargerWhite")
                  
                  Text("충전기 선택") // 버튼에 표시될 텍스트
                    .font(.custom("SUITE-Bold", size: 16))
                    .foregroundColor(Color.white)
                }
                .frame(width: 130, height: 38)
                .background(Color(hex: 0x00ab84))
                .cornerRadius(35)
                .padding()
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
              }
              .fullScreenCover(isPresented: $isselectAndChargePresented, content: {
                selectAndCharge()
              })
            }
            
            ZStack{
              VStack{
                Spacer().frame(height: 20)
                HStack{
                  Spacer().frame(width: 14)
                  VStack(alignment: .leading){
                    
                    // MARK: api 연결 팁
                    
                    /* 여기에 들어가있는 정보 중 api로 연결하려면 alarmofire를 이용해서 각각의 apiData를
                     (@State private var "api데이터이름": String = "") 이렇게 정의 후 Text(api데이터이름)으로 대체 하면 됨 <""은 삭제 필수> */
                    
                    Text("그리온 충전소") // 충전소명
                      .font(.custom("SUITE-Bold", size: 20))
                      .foregroundColor(Color(hex: 0x545860))
                    
                    Spacer().frame(height: 5)
                    
                    HStack(spacing: 5){
                      Image("logo")
                        .resizable()
                        .frame(width: 54, height: 10)
                      Text("|")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("완전개방") // 개방여부
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("|")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("123Km") // 킬로미터
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    
                    Spacer().frame(height: 15)
                    
                    HStack(spacing: 5){
                      Image("ev_charger_green")
                      Text("충전가능 시간")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("|")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("24시간 운영") // 충전가능 시간
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 5){
                      Image("parking")
                      Text("유료") // 주차 금액
                        .font(.custom("SUITE-Regular", size: 14))
                      Text("|")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("10분당 500원") // 충전가능 시간
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    
                    Spacer().frame(height: 20)
                    
                    LineView()
                    
                    Spacer().frame(height: 20)
                    
                    Text("충전 가능한 충전기 종류")
                      .font(.custom("SUITE-Regular", size: 18))
                      .foregroundColor(Color(hex: 0x545860))
                  } // leading vstack 마지막
                  Spacer()
                  Spacer()
                } // spacer 14로 적용한 hstack 마지막
                
// MARK: 아래 이미지들은 백에서 이미지 등록 후 가져와야함
                Spacer().frame(height: 70)
                switch viewModel.displayCase {
                  case .ac:
                    ImageDisplay(imageName: "ac")
                  case .dc:
                    ImageDisplay(imageName: "dc")
                  case .chademo:
                    ImageDisplay(imageName: "chademo")
                  case .acAnddc:
                    HStack(spacing: 30) {
                      ImageDisplay(imageName: "ac")
                      ImageDisplay(imageName: "dc")
                    }
                  case .dcAndchademo:
                    HStack(spacing: 30) {
                      ImageDisplay(imageName: "dc")
                      ImageDisplay(imageName: "chademo")
                    }
                  case .acAndchademo:
                    HStack(spacing: 30) {
                      ImageDisplay(imageName: "ac")
                      ImageDisplay(imageName: "chademo")
                    }
                  case .allImages:
                    HStack(spacing: 30) {
                      ImageDisplay(imageName: "ac")
                      ImageDisplay(imageName: "dc")
                      ImageDisplay(imageName: "chademo")
                    }
                }
                Spacer().frame(height: 20)
                HStack{
                  Spacer().frame(width: 14)
                  LineView()
                  Spacer()
                  Spacer()
                }
                Spacer().frame(height: 20)
                
                VStack{
                  HStack{
                    Spacer().frame(width: 45)
                    VStack(alignment: .leading){
                      HStack{
                        Text("충전요금 | 회원가")
                          .font(.custom("SUITE-Regular", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                      }
                      Spacer().frame(height: 14)
                      HStack{
                        Image("check_blue")
                        Text("완속 :")
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("") // 완속 요금 [api 나오면 Text("\(apiData)원") 이렇게 쓰게되면 하단부 삭제 가능]
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("원") // 위의 완속 요금 api 연결 후 뒤에 텍스트만 붙이고 해당 라인 삭제
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                      }
                      Spacer().frame(height: 14)
                      HStack{
                        Image("check_green")
                        Text("급속 :")
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("") // 완속 요금 [api 나오면 Text("\(apiData)원") 이렇게 쓰게되면 하단부 삭제 가능]
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("원") // 위의 완속 요금 api 연결 후 뒤에 텍스트만 붙이고 해당 라인 삭제
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                      }
                    }
                    Spacer()
                    VStack(alignment: .leading){
                      HStack{
                        Text("충전요금 | 비회원가")
                          .font(.custom("SUITE-Regular", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                      }
                      Spacer().frame(height: 14)
                      HStack{
                        Image("check_blue")
                        Text("완속 :")
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("") // 완속 요금 [api 나오면 Text("\(apiData)원") 이렇게 쓰게되면 하단부 삭제 가능]
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("원") // 위의 완속 요금 api 연결 후 뒤에 텍스트만 붙이고 해당 라인 삭제
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                      }
                      Spacer().frame(height: 14)
                      HStack{
                        Image("check_green")
                        Text("급속 :")
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("") // 완속 요금 [api 나오면 Text("\(apiData)원") 이렇게 쓰게되면 하단부 삭제 가능]
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                        Text("원") // 위의 완속 요금 api 연결 후 뒤에 텍스트만 붙이고 해당 라인 삭제
                          .font(.custom("SUITE-Regular", size: 14))
                          .foregroundColor(Color(hex: 0x545860))
                      }
                    }
                    Spacer().frame(width: 45)
                  }
                  Spacer().frame(height: 20)
                  HStack{
                    Spacer()
                    Button(action: {
                      // 버튼이 클릭되었을 때 수행할 동작
                      print("아래의 녹색버턴")
                    }) {
                      HStack {
                        Image("addGroup")
                        
                        Text("멤버등록") // 버튼에 표시될 텍스트
                          .font(.custom("SUITE-Bold", size: 16))
                          .foregroundColor(Color.white)
                      }
                      .frame(width: 128, height: 38)
                      .background(Color(hex: 0x00ab84))
                      .cornerRadius(35)
                      .padding()
                      .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                    }
                    Button(action: {
                      // 버튼이 클릭되었을 때 수행할 동작
                      print("길찾기 버튼")
                    }) {
                      HStack {
                        Image("fork")
                        
                        Text("길찾기") // 버튼에 표시될 텍스트
                          .font(.custom("SUITE-Bold", size: 16))
                          .foregroundColor(Color.white)
                      }
                      .frame(width: 100, height: 38)
                      .background(Color(hex: 0x0069cb))
                      .cornerRadius(35)
                      .padding()
                      .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                    }
                    Spacer()
                  }
                }
                Spacer().frame(height: 60)
              } // vstack 마지막
              .onAppear {
                viewModel.fetchImagesWithAlamofire()
              }
            }
          }
        }
      }
    }
  }
  
  var backButton: some View {
    Button(action: {
      // 이전 화면으로 돌아가는 코드
      presentationMode.wrappedValue.dismiss()
    }) {
      HStack(spacing: 3) {
        Image(systemName: "arrow.left")
          .foregroundColor(Color(hex: 0x00ab84))
          .font(Font.system(size: 16, weight: .bold))
        Text("이전")
          .foregroundColor(Color(hex: 0x00ab84))
          .font(Font.custom("SUITE-Regular", size: 16))
      }
    }
    .frame(width: 70, height: 44)
    .contentShape(Rectangle())
  }
}

struct ImageDisplay: View {
  var imageName: String
  
  var body: some View {
    Group {
      Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 77, height: 77)
    }
  }
}

enum ImageDisplayCase {
  case ac
  case dc
  case chademo
  case acAnddc
  case dcAndchademo
  case acAndchademo
  case allImages
}

class ImageViewModel: ObservableObject {
  @Published var displayCase: ImageDisplayCase = .allImages
  
  func fetchImagesWithAlamofire() {
    
    // Alamofire를 사용하여 API로부터 이미지를 다운로드하는 로직을 작성
    // Alamofire.request를 사용해서 백엔드에 저장되어있는 이미지 URL에서 데이터를 가져와서 UIImage로 변환하고, 각각의 @Published 변수에 할당 후 사용
  }
}

// 라인 만드는 View
struct LineView: View {
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
      }
      .stroke(Color(hex: 0xd1d1d1), lineWidth: 1)
    }
  }
}

#Preview {
  chargerSelectView()
}
