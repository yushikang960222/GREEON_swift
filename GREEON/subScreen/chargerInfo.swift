//
//  chargerInfo.swift
//  GREEON
//
//  Created by Yushi Kang on 2/20/24.
//

import SwiftUI

struct chargerInfo: View {
  @State private var ischargerSelectViewPresented = false

  var body: some View {
    ZStack{
      
      VStack{
        Spacer().frame(height: 10)
        
        Rectangle()
          .frame(width: 40, height: 4)
          .foregroundColor(Color(hex: 0xd1d1d1))
          .cornerRadius(3)
        
        Spacer().frame(height:50)
        
        VStack(alignment: .leading) {
          
          HStack{
            Spacer().frame(width: 14)
            
            VStack(alignment: .leading){
              
              Text("") // 여기는 검색한 내용이 나와야 함
                .font(.custom("SUITE-ExtraBold", size: 22))
                .foregroundColor(Color(hex: 0x545860))
              Spacer().frame(height: 2)
              Text("검색 결과")
                .font(.custom("SUITE-ExtraBold", size: 24))
                .foregroundColor(Color(hex: 0x00ab84))
            }
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        
        ScrollView{
          
          VStack{
            
            Spacer().frame(height: 15)
            
            Button(action: {
              ischargerSelectViewPresented.toggle()
              print("어마무시한 버튼")
            }) {
              ZStack{
                
                HStack{
                  
                  Spacer().frame(width: 14)
                  
                  VStack(alignment: .leading){
                    
                    HStack(spacing: 5){
                      
                      Image("available")
                      Text("충전가능") // 충전 가능 여부
                        .font(.custom("SUITE-medium", size: 12))
                      
                      Spacer()
                    }
                    Spacer().frame(height: 10)
                    HStack{
                      Text("그리온 충전소") // 충전소 이름
                        .font(.custom("SUITE-Bold", size: 20))
                    }
                    Spacer().frame(height: 10)
                    HStack(spacing: 5){
                      Image("logo")
                        .resizable()
                        .frame(width: 54, height: 10)
                      Text("|")
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("") // 개방여부
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("|")
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("Km") // 킬로미터
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    Spacer().frame(height: 15)
                    HStack(spacing: 5){
                      Image("available_fast")
                      Text("완속")
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("대") // 완속충전기 총 몇대
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("|")
                        .font(.custom("SUITE-Regular", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("AC3상") // 충전기 종류
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    Spacer().frame(height: 5)
                    HStack(spacing: 5){
                      Image("available_notfast")
                      Text("급속")
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("대") // 급속충전기 총 몇대
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("|")
                        .font(.custom("SUITE-Regular", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("DC콤보, 차데모") // 충전기 종류
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    Spacer().frame(height: 18)
                    HStack(spacing: 5){
                      Text("완속충전금액")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("원/kWh") // 완속 충전 금액
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    Spacer().frame(height: 6)
                    HStack(spacing: 5){
                      Text("급속충전금액")
                        .font(.custom("SUITE-Regular", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("원/kWh") // 급속 충전 금액
                        .font(.custom("SUITE-Bold", size: 14))
                        .foregroundColor(Color(hex: 0x545860))
                    }
                    Spacer().frame(height: 10)
                    Text("(회원가 기준, 결제금액의 5% 적립)")
                      .font(.custom("SUITE-Regular", size: 14))
                      .foregroundColor(Color(hex: 0x545860))
                    Spacer().frame(height: 14)
                    
                    HStack(spacing: 5){
                      Text("회원가")
                        .font(.custom("SUITE-Bold", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("원") // 회원가
                        .font(.custom("SUITE-Bold", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("|")
                        .font(.custom("SUITE-Bold", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("비회원가")
                        .font(.custom("SUITE-Bold", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Text("원") // 비회원가
                        .font(.custom("SUITE-Bold", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      
                      Spacer()
                      
                      Button(action: {
                        // 버튼이 클릭되었을 때 수행할 동작
                        print("째깐한 버튼")
                      }) {
                        HStack{
                          Image("fork")
                          Text("길찾기") // 버튼에 표시될 텍스트
                            .font(.custom("SUITE-Bold", size: 16))
                        }
                        .foregroundColor(Color.white)
                        .frame(width: 100, height: 38)
                        .background(Color(hex: 0x0069cb))
                        .cornerRadius(35)
                      }
                      Spacer().frame(width: 14)
                    }
                  }
                }
              }
              .fullScreenCover(isPresented: $ischargerSelectViewPresented, content: {
                chargerSelectView()
              })
            }// 버튼 하나
          }
          
          // vstack 마지막
          Spacer()
        }
      }
    }
  }
}

#Preview {
  chargerInfo()
}

class chargerInfoController: UIHostingController<chargerInfo> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: chargerInfo())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 추가적인 설정이 필요하다면 여기에서 수행
    }
}
