//
//  File.swift
//
//
//  Created by Young Bin on 2023/05/25.
//

import Foundation
import Combine

final class VideoFileManager {
    // Dependencies
    private let fileManager: FileManager
    
    private let videoFileGenerator: VideoFileGeneratingService
    private let pathProvider: VideoFilePathProvidingService
    private let albumHandler: AlbumHandlingService
    
    private(set) var videoFilePipeline = CurrentValueSubject<[VideoFile], Error>([])
    
    convenience init(option: AespaOption.Asset) {
        self.init(
            option,
            videoFileGenerator: VideoFileGeneratingService(),
            pathProvider: VideoFilePathProvidingService(option: option),
            videoAlbumHandler: AlbumHandlingService(albumName: option.albumName)
        )
    }
    
    init(
        _ option: AespaOption.Asset,
        videoFileGenerator: VideoFileGeneratingService,
        pathProvider: VideoFilePathProvidingService,
        videoAlbumHandler: AlbumHandlingService,
        fileManager: FileManager = FileManager.default
    ) {
        self.fileManager = fileManager
        
        self.pathProvider = pathProvider
        
        self.videoFileGenerator = videoFileGenerator
        self.albumHandler = videoAlbumHandler
        
        self.fetch()
    }
}

extension VideoFileManager {
    func requestFilePath() throws -> URL {
        try pathProvider.process(.generatingNewFilePath)
    }
    
    /// Fetching recorded asset(video) with given path and
    /// generate and return a wrapper instance(`VideoFile`)
    func add(videoFile: VideoFile) async throws {
        try await albumHandler.process(.addition(path: videoFile.path))
        
        var files = videoFilePipeline.value // old values
        files.append(videoFile) // new values
        
        videoFilePipeline.send(files)
    }
    
    /// Delete the `VideoFile` from file system & album roll
    func delete(videoFile: VideoFile) throws {
        var files = videoFilePipeline.value
        
        guard let index = files.firstIndex(where: { $0.path == videoFile.path }) else {
            throw AespaError.album(reason: .videoNotExist)
        }
        
        // Delete from disk
        try fileManager.removeItem(at: videoFile.path)
        // TODO: Delete from album
        
        // Delete from memory
        files.remove(at: index)
        videoFilePipeline.send(files)
    }
    
    /// Initialize the on memory data to on disk data
    @discardableResult
    func fetch() -> [VideoFile] {
        do {
            let directoryPath = try pathProvider.process(.getRootDirectoryPath)
            
            // Returns file's name, not file's path
            let filePaths = try fileManager
                .contentsOfDirectory(atPath: directoryPath.path)
                .map { name -> URL in
                    return directoryPath.appendingPathComponent(name)
                }
            
            let files = filePaths
                .map { filePath -> VideoFile in
                    return videoFileGenerator.process(.generatingVideoFile(path: filePath))
                }
            
            videoFilePipeline.send(files)
            
            return files
        } catch let error {
            LoggingManager.logger.log(error: error)
            return []
        }
    }
}
