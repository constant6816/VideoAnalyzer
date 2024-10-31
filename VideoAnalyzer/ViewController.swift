//
//  ViewController.swift
//  VideoAnalyzer
//
//  Created by 김호성 on 2024.10.27.
//

import UIKit
import AVFoundation
import PhotosUI
import Combine

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
    
    private func initializeVideo(url: URL) async throws {
        avAsset = AVURLAsset(url: url)
        
        let (duration, track) = try await avAsset!.load(.duration, .tracks)
        print(duration)
        print(track)
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
                guard let url = url, let self = self else { return }
                Task {
                    do {
                        try await self.initializeVideo(url: url)
                    } catch {
                        print("\(error)")
                    }
                }
            })
            
            
            
        }
        
    }
}

