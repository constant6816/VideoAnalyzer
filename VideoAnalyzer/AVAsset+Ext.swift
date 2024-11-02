//
//  AVAsset+Ext.swift
//  VideoAnalyzer
//
//  Created by 김호성 on 2024.11.01.
//

import Foundation
import AVFoundation
import AVKit

extension AVAsset {
    
    func generateThumbnail(time: CMTime, completion: @escaping (UIImage?) -> Void) {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        
        let times = [NSValue(time: time)]
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
            if let image = image {
                completion(UIImage(cgImage: image))
            } else {
                completion(nil)
            }
        })
    }
    
    func generateThumbnail2(time: CMTime) async throws -> UIImage {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        
//        let times = [NSValue(time: time)]
        
        let thumbnail = try await imageGenerator.image(at: time).image
        return UIImage(cgImage: thumbnail)
        
    }
}

