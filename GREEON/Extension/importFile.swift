//
//  importFile.swift
//  GREEON
//
//  Created by Yushi Kang on 3/20/24.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
  @Binding var attachedImages: [AttachedImageWrapper]
  
  var completionHandler: ((UIImage?) -> Void)?
  
  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let viewController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image], asCopy: true)
    viewController.delegate = context.coordinator
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  class Coordinator: NSObject, UIDocumentPickerDelegate {
    let parent: DocumentPickerView
    
    init(parent: DocumentPickerView) {
      self.parent = parent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      guard let url = urls.first else { return }
      guard let imageData = try? Data(contentsOf: url) else { return }
      guard let image = UIImage(data: imageData) else { return }
      parent.attachedImages.append(AttachedImageWrapper(image: image, imageName: ""))
    }
  }
}
