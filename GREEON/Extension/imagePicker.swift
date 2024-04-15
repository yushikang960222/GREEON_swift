//
//  imagePicker.swift
//  GREEON
//
//  Created by Yushi Kang on 3/20/24.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  var sourceType: UIImagePickerController.SourceType = .photoLibrary
  
  @Binding var attachedImages: [AttachedImageWrapper]  // 변경
  @Environment(\.presentationMode) private var presentationMode
  var completionHandler: ((UIImage?) -> Void)?
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator
    return imagePicker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        parent.attachedImages.append(AttachedImageWrapper(image: image, imageName: ""))
      }
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}

