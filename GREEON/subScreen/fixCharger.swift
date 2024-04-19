//
//  fixCharger.swift
//  GREEON
//
//  Created by Yushi Kang on 4/18/24.
//

import SwiftUI

struct fixCharger: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
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
        Text("고장신고")
          .font(.custom("SUITE-Bold", size: 24))
        Spacer()
      }
      Spacer().frame(height: 10)
    }
    .background(Color.white)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    VStack{
      Spacer().frame(height: 30)
      
      Spacer()
    }
  }
}

#Preview {
  fixCharger()
}
