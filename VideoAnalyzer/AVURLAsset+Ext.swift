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
//    
//    public func requestStatus<T>(_ property: AVAsyncProperty<AVURLAsset, T>) -> Future<AVAsyncProperty<AVURLAsset, T>.Status, Error> {
//        let status: CurrentValueSubject = CurrentValueSubject<AVAsyncProperty<AVURLAsset, T>.Status, Never>(self.status(of: property))
//        status.sink(receiveValue: { value in
//            switch value {
//            case .loaded(_):
//                return Future<AVAsyncProperty<AVURLAsset, T>.Status, Never>() { promise in
//                    promise(Result.success(value))
//                }
//            case .notYetLoaded, .loading, .failed(_):
//                break
//            }
//        })
//        return
//    }
}
