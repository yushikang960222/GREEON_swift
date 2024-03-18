//
//  noticeAndqna.swift
//  GREEON
//
//  Created by Yushi Kang on 3/14/24.
//

import SwiftUI
import Combine
//import Alamofire

//class NoticeViewModel: ObservableObject {
//  @Published var notices: [String] = []
//  @Published var faqs: [String] = []
//
//  init() {
//    fetchNotice()
//    fetchFAQs()
//  }
//
//  func fetchNotice() {
//    let url = "" // 공지사항 api
//
//    AF.request(url)
//      .validate()
//      .responseString { response in
//        switch response.result {
//          case .success(let data):
//            DispatchQueue.main.async {
//              self.notices = [data] // 공지사항 데이터 처리
//            }
//          case .failure(let error):
//            print("Error: \(error)") // 에러 처리
//        }
//      }
//    self.notices = ["공지사항 내용 1", "공지사항 내용 2", "공지사항 내용 3"]
//  }
//  func fetchFAQs() {
//    let url = "" // faq api
//
//    AF.request(url)
//      .validate()
//      .responseString { response in
//        switch response.result {
//          case .success(let data):
//            DispatchQueue.main.async {
//              self.faqs = [data] // FAQ 데이터 처리
//            }
//          case .failure(let error):
//            print("Error: \(error)") // 에러 처리
//        }
//      }
//    self.faqs = ["FAQ 내용 1", "FAQ 내용 2", "FAQ 내용 3"]
//  }
//}

class noticeAndFaqViewModel: ObservableObject {
  @Published var notices: [Notice] = []
  @Published var faqs: [FAQ] = []
  @Published var isDataLoaded: Bool = false
  private var cancellables: Set<AnyCancellable> = []
  
  init() {
    fetchData()
  }
  
  func fetchData() {
    fetchNotice()
      .sink { [weak self] notices in
        self?.notices = notices
        self?.isDataLoaded = true
      }
      .store(in: &cancellables)
    
    fetchFAQs()
      .sink { [weak self] faqs in
        self?.faqs = faqs
        self?.isDataLoaded = true
      }
      .store(in: &cancellables)
  }
  
  func fetchNotice() -> AnyPublisher<[Notice], Never> {
    // 비동기로 공지사항 데이터를 가져오는 작업을 수행하고 해당 작업이 완료되면
    // 가져온 데이터를 반환하는 Publisher를 생성합니다.
    return Future<[Notice], Never> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
        // 예시로 1초 후에 데이터를 반환하도록 설정합니다.
        let notices = [
          Notice(title: "공지사항 1", content: "내용내용 1"),
          Notice(title: "공지사항 2", content: "내용내용 2"),
          Notice(title: "공지사항 3", content: "내용내용 3")
        ]
        promise(.success(notices))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func fetchFAQs() -> AnyPublisher<[FAQ], Never> {
    // 비동기로 FAQ 데이터를 가져오는 작업을 수행하고 해당 작업이 완료되면
    // 가져온 데이터를 반환하는 Publisher를 생성합니다.
    return Future<[FAQ], Never> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
        // 예시로 1초 후에 데이터를 반환하도록 설정합니다.
        let faqs = [
          FAQ(title: "FAQ 1", content: "내용내용 11111"),
          FAQ(title: "FAQ 2", content: "내용내용 22222"),
          FAQ(title: "FAQ 3", content: "내용내용 33333")
        ]
        promise(.success(faqs))
      }
    }
    .eraseToAnyPublisher()
  }
}

struct Notice: Identifiable {
  var id = UUID()
  var title: String
  var content: String
}

struct FAQ: Identifiable {
  var id = UUID()
  var title: String
  var content: String
}

struct noticeAndfaq: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var selCategory: Category = .notice // 기본 선택 카테고리
  @State private var notices: [String] = []
  @State private var faqs: [String] = []
  @ObservedObject var viewModel = noticeAndFaqViewModel() // @ObservedObject로 변경
  @State private var isDetailPresented = false // 단일 세부 사항 표시
  @State private var selectedItem: String = "" // 선택된 항목
  
  enum Category {
    case notice
    case faq
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
        Text("공지사항&FAQ")
          .font(.custom("SUITE-Bold", size: 24))
        Spacer()
      }
      Spacer().frame(height: 10)
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    VStack {
      Spacer().frame(height: 20)
      HStack{
        Spacer().frame(width: 14)
        Picker("Category", selection: $selCategory) {
          Text("공지사항").tag(Category.notice)
          Text("FAQ").tag(Category.faq)
        }
        Spacer().frame(width: 14)
      }
      .pickerStyle(SegmentedPickerStyle())
      ScrollView {
        VStack{
          Spacer().frame(height: 20)
          switch selCategory {
            case .notice:
              if viewModel.isDataLoaded {
                ForEach(viewModel.notices) { notice in
                  HStack{
                    Spacer().frame(width: 20)
                    Button(action: {
                      self.selectedItem = notice.title
                      self.isDetailPresented = true
                    }) {
                      HStack{
                        Text(notice.title)
                          .font(.custom("SUITE-Regular", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                        Spacer()
                        Image("arrowRightAlt")
                          .frame(height: 50)
                      }
                    }
                    Spacer().frame(width: 20)
                  }
                }
              } else {
                Text("데이터를 로드 중입니다...").padding()
              }
            case .faq:
              if viewModel.isDataLoaded {
                ForEach(viewModel.faqs) { faq in
                  HStack{
                    Spacer().frame(width: 20)
                    Button(action: {
                      self.selectedItem = faq.title
                      self.isDetailPresented = true
                    }) {
                      HStack{
                        Text(faq.title)
                          .font(.custom("SUITE-Regular", size: 16))
                          .foregroundColor(Color(hex: 0x545860))
                        Spacer()
                        Image("arrowRightAlt")
                          .frame(height: 50)
                      }
                    }
                    Spacer().frame(width: 20)
                  }
                }
              } else {
                Text("데이터를 로드 중입니다...").padding()
              }
          }
        }
      }
    }
    .fullScreenCover(isPresented: $isDetailPresented) {
      if selCategory == .notice {
        NoticeDetailView(notice: viewModel.notices.first(where: { $0.title == selectedItem }) ?? Notice(title: "", content: ""))
      } else {
        faqDetailView(FaqDetail: viewModel.faqs.first(where: { $0.title == selectedItem }) ?? FAQ(title: "", content: ""))
      }
    }
    .onAppear {
      self.viewModel.fetchData()
    }
  }
}

struct NoticeDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  let notice: Notice
  
  var body: some View {
    ZStack{
      VStack{
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
            Text(notice.title)
              .font(.custom("SUITE-Bold", size: 24))
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        VStack{
          Spacer().frame(height: 30)
          HStack{
            Spacer().frame(width: 14)
            Text(notice.content)
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
          }
        }
        Spacer()
      }
    }
  }
}

struct faqDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  let FaqDetail: FAQ
  
  var body: some View {
    ZStack{
      VStack{
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
            Text(FaqDetail.title)
              .font(.custom("SUITE-Bold", size: 24))
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        VStack{
          Spacer().frame(height: 30)
          HStack{
            Spacer().frame(width: 14)
            Text(FaqDetail.content)
              .font(.custom("SUITE-Regular", size: 16))
              .foregroundColor(Color(hex: 0x545860))
            Spacer()
          }
        }
        Spacer()
      }
    }
  }
}



#Preview {
  noticeAndfaq()
}
