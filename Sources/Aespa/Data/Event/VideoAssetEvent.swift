//
//  File.swift
//  
//
//  Created by YoungBin Lee on 4/18/24.
//

import Combine
import Photos

public typealias AssetEventSubject = PassthroughSubject<AssetEvent, Never>

public enum AssetEvent {
    case added([PHAsset])
    case deleted([PHAsset])
}

public extension [VideoAsset] {
    /// If you want to delete your current `VideoAsset` based on a `PHAsset`, use this method.
    /// The `id` of a `VideoAsset` is the `id` of the encapsulated `PHAsset`, and this method operates based on that.
    ///
    /// If your goal is simply to keep `VideoAssets` up to date, consider using the `fetchVideoFiles` of `AespaSession`.
    /// `fetchVideoFiles` utilizes caching internally, allowing for faster and more efficient data updates.
    func remove(_ asset: PHAsset) -> [VideoAsset] {
        filter { $0.phAsset.localIdentifier != asset.localIdentifier }
    }
}

public extension [PhotoAsset] {
    /// If you want to delete your current `PhotoAsset` based on a `PHAsset`, use this method.
    /// The `id` of a `VideoAsset` is the `id` of the encapsulated `PHAsset`, and this method operates based on that.
    ///
    /// If your goal is simply to keep `PhotoAsset` up to date, consider using the `fetchPhotoFiles` of `AespaSession`.
    /// `fetchPhotoFiles` utilizes caching internally, allowing for faster and more efficient data updates.
    func remove(_ asset: PHAsset) -> [PhotoAsset] {
        filter { $0.asset.localIdentifier != asset.localIdentifier }
    }
}
