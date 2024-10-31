//
//  AVURLAsset+Ext.swift
//  VideoAnalyzer
//
//  Created by 김호성 on 2024.10.31.
//

import Foundation
import AVFoundation
import Combine

extension AVURLAsset {
    public func requestStatus<T>(_ property: AVAsyncProperty<AVURLAsset, T>) -> Future<AVAsyncProperty<AVURLAsset, T>.Status, Error> {
        return Future() { promise in
            let status = self.status(of: property)
            switch status {
            case .notYetLoaded,.loading, .failed(_):
                return promise(Result.failure(<#any Error#>))
            case .loaded(_):
                return promise(Result.success(status))
            }
        }
    }
}
