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
    @IBOutlet weak var cvFrame: UICollectionView!
    private var avAsset: AVURLAsset?
    private var duration: CMTime? {
        didSet {
            guard let duration = duration else { return }
            DispatchQueue.main.async { [weak self] in
                self?.cvFrame.dataSource = self
                self?.cvFrame.reloadData()
                self?.cvFrame.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvFrame.delegate = self
        cvFrame.register(UINib(nibName: String(describing: FrameCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: FrameCollectionViewCell.self))
        cvFrame.contentInset = .init(top: 0, left: cvFrame.bounds.width/2, bottom: 0, right: cvFrame.bounds.width/2)
    }
    
    @IBAction func onClickAddVideo(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
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
                    self.duration = try await self.avAsset?.load(.duration)
                }
                
                let time = CMTime(value: 3, timescale: 1)
                
                self.avAsset?.generateThumbnail(time: time, completion: { image in
                    DispatchQueue.main.async {
                        self.ivTest.image = image
                    }
                })
            })
        }
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(CMTimeGetSeconds(duration!)*10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FrameCollectionViewCell
        if let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FrameCollectionViewCell.self), for: indexPath) as? FrameCollectionViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: FrameCollectionViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! FrameCollectionViewCell
        }
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let centerPoint = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            print("\(indexPath.row)")
            self.avAsset?.generateThumbnail(time: CMTimeMultiplyByRatio(duration!, multiplier: Int32(indexPath.row), divisor: Int32(Int(CMTimeGetSeconds(duration!)*10))), completion: { image in
                DispatchQueue.main.async {
                    self.ivTest.image = image
                }
            })
        }
    }
}
