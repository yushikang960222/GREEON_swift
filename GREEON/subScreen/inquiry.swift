//
//  inquiry.swift
//  GREEON
//
//  Created by Yushi Kang on 3/19/24.
//

import SwiftUI
import Combine

class InquiryListViewModel: ObservableObject {
  @Published var inquiryLists: [InquiryList] = []
  @Published var isDataLoaded: Bool = false
  @Published var attachedImages: [UIImage] = []
  @Published var showAlert: Bool = false
  @Published var EmptyAlert: Bool = false
  private var cancellables: Set<AnyCancellable> = []
  
  init() {
    fetchData()
  }
  
  func fetchData() {
    fetchInquiry()
      .sink { [weak self] inquiryLists in
        self?.inquiryLists = inquiryLists
        self?.isDataLoaded = true
      }
      .store(in: &cancellables)
  }
  
  func attachImage(image: UIImage, name: String) {
    attachedImages.append(image)
  }
  
  func fetchInquiry() -> AnyPublisher<[InquiryList], Never> {
    return Future<[InquiryList], Never> { promise in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
        let InquiryLists = [
          InquiryList(title: "문의내역이에용", content: "내용내용 1"),
          InquiryList(title: "문의는 포도가 넘모머꼬찌푼데", content: "내용내용 2"),
          InquiryList(title: "충전기가 고장났어효", content: "내용내용 3")
        ]
        promise(.success(InquiryLists))
      }
    }
    .eraseToAnyPublisher()
  }
  func submitInquiry(title: String, content: String, attachedImages: [AttachedImageWrapper], showAlert: Bool, resetContent: () -> Void) {
    guard !title.isEmpty, !content.isEmpty else {
            EmptyAlert = true
            return
        }
    
    let newInquiry = InquiryList(title: title, content: content)
    self.inquiryLists.append(newInquiry)
    for attachedImage in attachedImages {
      self.attachImage(image: attachedImage.image, name: attachedImage.imageName)
    }
    print("Setting showAlert to \(showAlert)")
    resetContent()
    self.showAlert = true
  }
}

struct AttachedImage {
  let image: UIImage
  let imageName: String
}

struct InquiryList: Identifiable {
  var id = UUID()
  var title: String
  var content: String
}

struct AttachedImageWrapper: Identifiable {
  let id = UUID()
  var image: UIImage
  var imageName: String
}

struct inquiry: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var inquiryTitle: String = ""
  @State private var inquiryText: String = ""
  @State private var isEditing: Bool = false
  @State private var selCategory: Category = .inquiry
  @ObservedObject var viewModel = InquiryListViewModel()
  @State private var selectedItem: String = ""
  @State private var isDetailPresented = false
  @State private var inquiryList: [String] = []
  @State private var openCamera = false
  @State private var openPhoto = false
  @State private var openDocument = false
  @State private var selImage: UIImage?
  @State private var capImage: UIImage?
  @State private var EmptyAlert = false
  @State private var showAlert = false
  @State private var attachedImages: [AttachedImageWrapper] = []
  
  let maxLength = 3000
  
  enum Category {
    case inquiry
    case inquiryList
  }
  
  func submitInquiry() {
    if inquiryTitle.isEmpty || inquiryText.isEmpty {
      EmptyAlert = true
      return
    }
    viewModel.submitInquiry(title: inquiryTitle,
                            content: inquiryText,
                            attachedImages: attachedImages,
                            showAlert: true,
                            resetContent: {
      inquiryTitle = ""
      inquiryText = ""
      attachedImages.removeAll()
    })
  }
  
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
        Text("1:1문의")
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
          Text("문의하기").tag(Category.inquiry)
          Text("문의내역").tag(Category.inquiryList)
        }
        Spacer().frame(width: 14)
      }
      .pickerStyle(SegmentedPickerStyle())
      ScrollView {
        HStack{
          Spacer().frame(width: 14)
          VStack{
            Spacer().frame(height: 30)
            switch selCategory {
              case .inquiry:
                VStack(alignment: .leading) {
                  TextField("제목을 입력해주세요.", text: $inquiryTitle)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                    .font(.custom("SUITE-Regular", size: 16))
                    .foregroundColor(Color(hex: 0x545860))
                    .background(Color(hex: 0xf9f9f9))
                  Spacer().frame(height: 20)
                  ZStack(alignment: .topLeading) {
                    let placeholder: String = "내용을 입력해주세요."
                    TextEditor(text: $inquiryText)
                      .font(.custom("SUITE-Regular", size: 16))
                      .frame(height: 300)
                      .foregroundColor(Color(hex: 0x545860))
                      .lineSpacing(10)
                      .background(Color(hex: 0xf9f9f9))
                      .cornerRadius(10)
                      .padding(.top, 5)
                      .padding(.horizontal, 5)
                      .padding(.bottom, 5)
                      .onReceive(inquiryText.publisher.collect()) { newText in
                        if newText.count > maxLength {
                          self.inquiryText = String(newText.prefix(maxLength))
                        }
                      }
                    RoundedRectangle(cornerRadius: 10)
                      .stroke(Color(hex: 0xf0f0f0), lineWidth: 1)
                    if inquiryText.isEmpty{
                      Text(placeholder)
                        .font(.custom("SUITE-Regular", size: 16))
                        .foregroundColor(Color(hex: 0xcdcdcd))
                        .padding(.top, 10)
                        .padding(.horizontal, 7)
                    }
                  }
                  HStack{
                    Spacer()
                    Text("\(inquiryText.count) / 3000")
                      .font(.custom("SUITE-Regular", size: 14))
                      .foregroundColor(Color(hex: 0x545860))
                    Spacer().frame(width: 14)
                  }
                  Spacer().frame(height: 30)
                  HStack{
                    Text("첨부파일")
                      .font(.custom("SUITE-Regular", size: 16))
                      .foregroundColor(Color(hex: 0x545860))
                    Spacer().frame(width: 20)
                    Menu {
                      Button {
                        self.openCamera = true
                        HapticManager.instance.impact(style: .rigid)
                      } label: {
                        HStack {
                          Image(systemName: "camera.fill")
                          Text("사진촬영")
                        }
                      }
                      Menu("사진 가져오기") {
                        Button(action: {
                          self.openPhoto = true
                          HapticManager.instance.impact(style: .rigid)
                        }) {
                          HStack{
                            Image(systemName: "photo")
                            Text("사진 추가")
                          }
                        }
                        Button(action:{
                          self.openDocument = true
                          HapticManager.instance.impact(style: .rigid)
                        }) {
                          HStack{
                            Image(systemName: "folder")
                            Text("파일에서 가져오기")
                          }
                        }
                      }
                    } label: {
                      HStack{
                        Image("image")
                        Text("사진첨부")
                      }
                      .foregroundColor(.white)
                      .frame(width: 110, height: 36)
                      .background(Color(hex: 0x00ab84))
                      .cornerRadius(5)
                    }
                    Spacer()
                  }
                  Spacer().frame(height: 40)
                  VStack{
                    HStack{
                      Text("첨부파일 리스트")
                        .font(.custom("SUITE-Regular", size: 16))
                        .foregroundColor(Color(hex: 0x545860))
                      Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                      HStack{
                        Spacer().frame(width: 10)
                        ForEach(attachedImages) { attachedImage in
                          VStack(spacing: 3){
                            Image(uiImage: attachedImage.image)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 50, height: 50)
                            Button(action: {
                              attachedImages.removeAll(where: { $0.id == attachedImage.id })
                              HapticManager.instance.notification(type: .error)
                            }) {
                              HStack{
                                Spacer()
                                Image(systemName: "trash.fill")
                                  .foregroundColor(Color(hex: 0xef3346))
                                  .frame(width: 5, height: 5)
                                Spacer().frame(width: 10)
                                Text("삭제")
                                  .font(.custom("SUITE-Bold", size: 14))
                                  .foregroundColor(Color(hex: 0xef3346))
                                Spacer(minLength: 0)
                              }
                            }
                          }
                        }
                        Spacer().frame(width: 10)
                      }
                    }
                  }
                  Spacer().frame(height: 70)
                  HStack{
                    Spacer()
                    Button(action: {
                      submitInquiry()
                      HapticManager.instance.impact(style: .rigid)
                    }) {
                        HStack {
                            Text("등록")
                                .font(.custom("SUITE-Regular", size: 16))
                            Image("apply")
                        }
                    }
                    .alert(isPresented: $viewModel.EmptyAlert) {
                      HapticManager.instance.notification(type: .error)
                      return Alert(title: Text("접수 실패"), message: Text("\n제목과 내용을 모두 입력해주세요."), dismissButton: .cancel(Text("확인")))
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                      HapticManager.instance.notification(type: .error)
                      return Alert(title: Text("접수 완료"), message: Text("\n1:1문의가 성공적으로 접수되었습니다.\n빠른 시일 내에 답변드리겠습니다."), dismissButton: .cancel(Text("확인")))
                    }
                    Spacer().frame(width: 14)
                  }
                  Spacer().frame(height: 20)
                }
              case .inquiryList:
                ForEach(viewModel.inquiryLists) { inquiryList in
                  HStack{
                      Spacer().frame(width: 10)
                    Button(action: {
                      self.selectedItem = inquiryList.title
                      self.isDetailPresented = true
                      HapticManager.instance.impact(style: .rigid)
                    }) {
                      VStack{
                        HStack{
                          Text(inquiryList.title)
                            .font(.custom("SUITE-Regular", size: 16))
                            .foregroundColor(Color(hex: 0x545860))
                          Spacer()
                          Image("arrowRightAlt")
                        }
                        Spacer().frame(height: 50)
                      }
                    }
                    Spacer().frame(width: 20)
                  }
                }
            }
            Spacer().frame(height: 10)
          }
        }
        Spacer().frame(width: 14)
      }
    }
    .fullScreenCover(isPresented: $isDetailPresented) {
      if selCategory == .inquiryList {
        InquiryDetailView(inquiryList: viewModel.inquiryLists.first(where: { $0.title == selectedItem }) ?? InquiryList(title: "", content: ""))
      }
    }
    .fullScreenCover(isPresented: $openCamera) {
      CameraCaptureView(attachedImages: self.$attachedImages)
        .ignoresSafeArea(.all)
    }
    .fullScreenCover(isPresented: $openDocument) {
      DocumentPickerView(attachedImages: self.$attachedImages)
    }
    .fullScreenCover(isPresented: $openPhoto) {
      ImagePicker(attachedImages: self.$attachedImages)
    }
  }
}

struct InquiryDetailView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @State private var showAlert = false
  let inquiryList: InquiryList
  
  var body: some View {
    ZStack{
      VStack{
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
            Button(action: {
              showAlert = true
              HapticManager.instance.impact(style: .rigid)
            }) {
              HStack(spacing: 3){
                Text("삭제")
                  .font(.custom("SUITE-Regular", size: 16))
                  .foregroundColor(Color(hex: 0xef3346))
                Image("delete")
              }
            }
            .alert(isPresented: $showAlert) {
              HapticManager.instance.notification(type: .warning)
              return Alert(title: Text("1:1문의 삭제"), message: Text("\n삭제 후 복원이 불가능합니다.\n정말 삭제 하시겠습니까?"), primaryButton: .destructive(Text("삭제")), secondaryButton: .cancel(Text("취소"))
              )
            }
            Spacer().frame(width: 14)
          }
          Spacer().frame(height: 23)
          HStack{
            Spacer().frame(width: 14)
            Text(inquiryList.title)
              .font(.custom("SUITE-Bold", size: 24))
            Spacer()
          }
          Spacer().frame(height: 10)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        ScrollView(showsIndicators: false){
          VStack{
            Spacer().frame(height: 30)
            HStack{
              Spacer().frame(width: 14)
              Text(inquiryList.content)
                .font(.custom("SUITE-Regular", size: 16))
                .foregroundColor(Color(hex: 0x545860))
              Spacer()
            }
          }
        }
        Spacer()
      }
    }
  }
}

#Preview {
  inquiry()
}
