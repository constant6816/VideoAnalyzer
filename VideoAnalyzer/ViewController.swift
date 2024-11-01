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
                avAsset = AVURLAsset(url: url)
                
//                avAsset
                let imageGenerator = AVAssetImageGenerator(asset: avAsset!)
                imageGenerator.appliesPreferredTrackTransform = true
                imageGenerator.requestedTimeToleranceBefore = .zero
                imageGenerator.requestedTimeToleranceAfter = .zero
                // 썸네일을 얻고 싶은 시간 설정 (여기서는 첫 번째 프레임)
                let time = CMTime(value: 3, timescale: 1)

                do {
                    // 썸네일 이미지 얻기
                    print(time)
                    let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)


                    // CGImage를 UIImage로 변환
                    let thumbnail = UIImage(cgImage: cgImage)
                    
                    // 완료 클로저 호출
                    // return thumbnail.rotateImageIfNeeded()
                    DispatchQueue.main.async {
                        self.ivTest.image = thumbnail
                    }
                    
                } catch {
                    
                }
                
//                Task {
//                    let duration = try await self.avAsset?.load(.duration)
//                    print(duration)
//                }
            })
        }
        
    }
}

