//
//  ImagePicker.swift
//  KidzCorner
//
//  Created by Happy Guleria on 26/06/24.
//

import UIKit
import MobileCoreServices

protocol FilePickerManagerDelegate: AnyObject {
    func didPickImage(_ image: UIImage)
    func didPickPDF(_ url: URL)
}

class FilePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    weak var delegate: FilePickerManagerDelegate?
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentFilePicker() {
        let alert = UIAlertController(title: "Select File", message: "Choose an option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { _ in
            self.presentImagePicker()
        }))
        
        alert.addAction(UIAlertAction(title: "PDF", style: .default, handler: { _ in
            self.presentDocumentPicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController?.present(alert, animated: true, completion: nil)
    }    
    
    
     func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        viewController?.present(imagePicker, animated: true, completion: nil)
    }
    
     func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        viewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            delegate?.didPickImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true, completion: nil)
        
        if let url = urls.first {
            delegate?.didPickPDF(url)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
