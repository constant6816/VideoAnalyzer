//
//  ViewController.swift
//  VideoAnalyzer
//
//  Created by 김호성 on 2024.10.27.
//

import UIKit
import AVFoundation
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var ivTest: UIImageView!
    private var avAsset: AVURLAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onClickAddVideo(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
    
    func temp() {
        guard let avAsset = avAsset else { return }
        Task {
            print(try? await avAsset.load(.duration))
        }
        
        let status = avAsset.status(of: .duration)
        print(status)
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
//        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            let previousImage = ivTest.image
//            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                DispatchQueue.main.async {
//                    guard let self = self, let image = image as? UIImage, self.ivTest.image == previousImage else { return }
//                    self.ivTest.image = image
//                }
//            }
//        }
        guard let itemProvider = results.first?.itemProvider, let typeIdentifier = itemProvider.registeredTypeIdentifiers.first else { return }
        
        if itemProvider.hasItemConformingToTypeIdentifier(typeIdentifier) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier, completionHandler: { [weak self] (url, error) in
                guard let url = url else { return }
                self?.avAsset = AVURLAsset(url: url)
                self?.temp()
            })
            
        }
        
    }
}
