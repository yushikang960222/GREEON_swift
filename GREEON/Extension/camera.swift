//
//  camera.swift
//  GREEON
//
//  Created by Yushi Kang on 3/20/24.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraCaptureView: UIViewControllerRepresentable {
  @Binding var attachedImages: [AttachedImageWrapper]
  @Environment(\.presentationMode) var presentationMode
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: CameraCaptureView
    
    init(parent: CameraCaptureView) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let uiImage = info[.originalImage] as? UIImage {
        let newImage = AttachedImageWrapper(image: uiImage, imageName: "Captured Image")
        parent.attachedImages.append(newImage)
      }
      parent.presentationMode.wrappedValue.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<CameraCaptureView>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.sourceType = .camera
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraCaptureView>) {
  }
}
