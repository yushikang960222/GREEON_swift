//
//  eventView.swift
//  GREEON
//
//  Created by Yushi Kang on 3/8/24.
//

import SwiftUI
import Combine

class EventViewModel: ObservableObject {
  @Published var eventInfos: [eventInfo] = []
  @Published var isLoading: Bool = false
  
  private var cancellables: Set<AnyCancellable> = []
  
  struct eventInfo {
    var title: String
    var infotxt: String
    var date: String
    var status: String
  }
  
  func fetchData() {
    isLoading = true
    // Alamofire로 구현, 실제 API 응답 데이터를 eventInfos에 할당해야함
    
    // 아래는 더미데이터임. api 연결 후 대체해야함
    self.eventInfos = [
      eventInfo(title: "제목제목",
                infotxt: "내용내용어쩌구저쩌구이러쿵저러쿵",
                date: "날짜날짜",
                status: "상태상태"
               )
    ]
    isLoading = false
  }
}

struct eventView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @ObservedObject var viewModel = EventViewModel()
  
  init() {
    // 위에서 fetchdata를 가져와서 초기화 후 사용
    viewModel.fetchData()
  }
  
  var body: some View {
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
        Text("이벤트")
          .font(.custom("SUITE-Bold", size: 24))
        Spacer()
      }
      Spacer().frame(height: 10)
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    ScrollView{
      ZStack{
        VStack{
          if viewModel.isLoading {
            Spacer().frame(height: 230)
            ProgressView()
              .onAppear {
                viewModel.fetchData()
              }
            Spacer().frame(height: 30)
            Text("잠시만 기다려주세요.")
              .font(.custom("SUITE-Regular", size: 18))
            Spacer()
          } else if !viewModel.eventInfos.isEmpty {
            // 데이터가 있는 경우
            ForEach(viewModel.eventInfos, id: \.title) { eventInfo in
              eventInfoView(eventInfo: eventInfo)
            }
          } else {
            // 데이터가 없는 경우
            VStack{
              Spacer().frame(height: 110)
              Image("noEvent")
                .resizable()
                .frame(width: 125, height: 200, alignment: .center)
                .padding()
              Text("진행중인 이벤트가 없습니다.")
                .font(.custom("SUITE-Bold", size: 20))
                .foregroundColor(Color(hex: 0x545860))
            }
          }
        }
      }
    }
    .frame(minHeight: 0, maxHeight: .infinity)
  }
}

struct eventInfoView: View {
  var eventInfo: EventViewModel.eventInfo
  
  var body: some View {
    ZStack{
      VStack{
        Spacer().frame(height: 30)
        HStack{
          Spacer().frame(width: 20)
          Button(action: {
            // 버튼 선택시 동작
          }) {
            HStack{
              Image("event_ing")
              Spacer().frame(width: 20)
              VStack(alignment: .leading){
                Text(eventInfo.title)
                  .font(.custom("SUITE-Bold", size: 18))
                  .foregroundColor(Color(hex: 0x545860))
                Spacer().frame(height: 10)
                Text(eventInfo.infotxt)
                  .font(.custom("SUITE-Regular", size: 14))
                  .foregroundColor(Color(hex: 0x545860))
                Spacer().frame(height: 5)
                HStack{
                  Text(eventInfo.date)
                    .font(.custom("SUITE-Light", size: 12))
                    .foregroundColor(Color(hex: 0x545860))
                  Spacer()
                  Text(eventInfo.status)
                    .font(.custom("SUITE-ExtraBold", size: 12))
                    .foregroundColor(Color(hex: 0x545860))
                  Spacer().frame(width: 14)
                }
              }
            }
          }
          Spacer()
        }
        Spacer().frame(height: 20)
        HStack{
          Spacer().frame(width: 14)
          LineView()
          Spacer().frame(width: 14)
        }
      }
    }
  }
}

#Preview {
  eventView()
}
