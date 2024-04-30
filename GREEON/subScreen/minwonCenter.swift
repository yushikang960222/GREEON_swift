//
//  minwonCenter.swift
//
//
//  Created by Yushi Kang on 3/7/24.
//

import SwiftUI
import WebKit

struct WebViewer: UIViewRepresentable {
  let urlString: String
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    if let url = URL(string: urlString) {
      let request = URLRequest(url: url)
      uiView.load(request)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebViewer
    
    init(_ parent: WebViewer) {
      self.parent = parent
    }
  }
}

struct minwonCenter: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    ZStack{
      VStack(alignment: .leading) {
        Spacer().frame(height: 15)
        HStack{
          Spacer().frame(width: 14)
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
            Image("back")
          }
          Spacer()
        }
        Spacer().frame(height: 23)
        HStack{
          Spacer().frame(width: 14)
          Text("불편민원신고센터")
            .font(.custom("SUITE-Bold", size: 24))
          Spacer()
        }
        Spacer().frame(height: 10)
      }
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    ZStack{
      VStack{
        WebViewer(urlString: "https://ev.or.kr/nportal/partcptn/initInconfortReportAction.do")
          .edgesIgnoringSafeArea(.all)
      }
    }
  }
}

#Preview {
  minwonCenter()
}
