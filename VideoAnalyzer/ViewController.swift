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
    
//    private func importVideo(itemProvider: NSItemProvider, typeIdentifier: String) async {
//        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier, completionHandler: { [weak self] (url, error) in
//            guard let url = url, let self = self else { return }
//            avAsset = AVURLAsset(url: url)
//            
//            let duration = try await avAsset?.load(.duration)
//            
//            let time = CMTime(value: 3, timescale: 1)
//            
//            avAsset?.generateThumbnail(time: time, completion: { image in
//                DispatchQueue.main.async {
//                    self.ivTest.image = image
//                }
//            })
//        })
//    }
}

extension ViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider, let typeIdentifier = itemProvider.registeredTypeIdentifiers.first else { return }
        
        if itemProvider.hasItemConformingToTypeIdentifier(typeIdentifier) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier, completionHandler: { [weak self] (url, error) in
                guard let url = url, let self = self else { return }

                self.avAsset = AVURLAsset(url: url)

                Task {
                    do {
                        var duration: CMTime? {
                            didSet {
                                print(duration)
                                print("task end")
                            }
                        }
                        duration = try await self.avAsset?.load(.duration)
                        
                    } catch {
                        print(error)
                        if let avError = error as? AVError {
                            print(avError)
                        }
                    }
                }
                
                let time = CMTime(value: 3, timescale: 1)
                
                avAsset?.generateThumbnail(time: time, completion: { image in
                    DispatchQueue.main.async {
                        self.ivTest.image = image
                    }
                })
                
                print("Closure End")
            })
        }
        
    }
}
