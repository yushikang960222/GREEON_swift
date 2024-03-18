//
//  noticeAndqna.swift
//  GREEON
//
//  Created by Yushi Kang on 3/14/24.
//

import SwiftUI
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

class NoticeViewModel: ObservableObject {
  @Published var notices: [String] = []
  @Published var faqs: [String] = []
  
  init() {
    fetchNotice()
    fetchFAQs()
  }
  
  func fetchNotice() {
    self.notices = ["공지사항 내용 1", "공지사항 내용 2", "공지사항 내용 3"]
  }
  
  func fetchFAQs() {
    self.faqs = ["FAQ 내용 1", "FAQ 내용 2", "FAQ 내용 3"]
  }
}

struct noticeAndfaq: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var selCategory: Category = .notice // 기본 선택 카테고리
  @State private var notices: [String] = []
  @State private var faqs: [String] = []
  @State private var isNoticeDetailViewPresented = false
  @State private var isFAQDetailViewPresented = false
  @ObservedObject var viewModel = NoticeViewModel() // @ObservedObject로 변경
  
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
              ForEach(viewModel.notices, id: \.self) { notice in
                HStack{
                  Spacer().frame(width: 20)
                  Button(action: {
                    // 공지사항 버튼이 클릭되었을 때 수행할 동작
                    self.showNoticeDetail(notice: notice)
                  }) {
                    HStack{
                      Text(notice)
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
            case .faq:
              ForEach(viewModel.faqs, id: \.self) { faq in
                HStack{
                  Spacer().frame(width: 20)
                  Button(action: {
                    // FAQ 버튼이 클릭되었을 때 수행할 동작
                    self.showFAQDetail(faq: faq)
                  }) {
                    HStack{
                      Text(faq)
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
          }
        }
      }
    }
    .onAppear {
      self.viewModel.fetchNotice()
    }
    .fullScreenCover(isPresented: $isNoticeDetailViewPresented) {
      if let Notice = viewModel.notices.first {
        NoticeDetailView(notice: Notice)
      } else {
        EmptyView()
      }
    }
    .fullScreenCover(isPresented: $isFAQDetailViewPresented) {
      if let FAQView = viewModel.faqs.first {
        faqDetailView(FaqDetail: FAQView)
      } else {
        EmptyView()
      }
    }
  }
  
  func showNoticeDetail(notice: String) {
    isNoticeDetailViewPresented = true
  }
  
  func showFAQDetail(faq: String) {
    isFAQDetailViewPresented = true
  }
}

struct NoticeDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  let notice: String
  
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
            Text(notice)
              .font(.custom("SUITE-Bold", size: 24))
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        VStack{
          Spacer().frame(height: 30)
          Text(notice)
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer()
      }
    }
  }
}

struct faqDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  let FaqDetail: String
  
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
            Text(FaqDetail)
              .font(.custom("SUITE-Bold", size: 24))
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        VStack{
          Spacer().frame(height: 30)
          Text(FaqDetail)
            .font(.custom("SUITE-Regular", size: 16))
            .foregroundColor(Color(hex: 0x545860))
        }
        Spacer()
      }
    }
  }
}



#Preview {
  noticeAndfaq()
}
