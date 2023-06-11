// MARK: - Mocks generated from file: ../Sources/Aespa/Aespa.swift at 2023-06-11 07:02:50 +0000

//
//  Aespa.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

/// Top-level class that serves as the main access point for video recording sessions.

import Cuckoo
@testable import Aespa






public class MockAespa: Aespa, Cuckoo.ClassMock {
    
    public typealias MocksType = Aespa
    
    public typealias Stubbing = __StubbingProxy_Aespa
    public typealias Verification = __VerificationProxy_Aespa

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Aespa?

    public func enableDefaultImplementation(_ stub: Aespa) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

    public struct __StubbingProxy_Aespa: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

    public struct __VerificationProxy_Aespa: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


public class AespaStub: Aespa {
    

    

    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/AespaError.swift at 2023-06-11 07:02:50 +0000

//
//  VideoRecorderError.swift
//  YellowIsTheNewBlack
//
//  Created by 이영빈 on 2022/06/07
import Cuckoo
@testable import Aespa

import Foundation

// MARK: - Mocks generated from file: ../Sources/Aespa/AespaOption.swift at 2023-06-11 07:02:50 +0000

//
//  AespaOption.swift
//  
//
//  Created by 이영빈 on 2023/05/26
import Cuckoo
@testable import Aespa

import AVFoundation
import Foundation

// MARK: - Mocks generated from file: ../Sources/Aespa/AespaSession.swift at 2023-06-11 07:02:50 +0000

//
//  AespaSession.swift
//  
//
//  Created by Young Bin on 2023/06/03.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import Combine
import Foundation
import UIKit






public class MockAespaSession: AespaSession, Cuckoo.ClassMock {
    
    public typealias MocksType = AespaSession
    
    public typealias Stubbing = __StubbingProxy_AespaSession
    public typealias Verification = __VerificationProxy_AespaSession

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AespaSession?

    public func enableDefaultImplementation(_ stub: AespaSession) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public override var captureSession: AVCaptureSession {
        get {
            return cuckoo_manager.getter("captureSession",
                superclassCall:
                    
                                    super.captureSession
                    ,
                defaultCall:  __defaultImplStub!.captureSession)
        }
        
    }
    
    
    
    
    
    public override var isMuted: Bool {
        get {
            return cuckoo_manager.getter("isMuted",
                superclassCall:
                    
                                    super.isMuted
                    ,
                defaultCall:  __defaultImplStub!.isMuted)
        }
        
    }
    
    
    
    
    
    public override var maxZoomFactor: CGFloat? {
        get {
            return cuckoo_manager.getter("maxZoomFactor",
                superclassCall:
                    
                                    super.maxZoomFactor
                    ,
                defaultCall:  __defaultImplStub!.maxZoomFactor)
        }
        
    }
    
    
    
    
    
    public override var currentZoomFactor: CGFloat? {
        get {
            return cuckoo_manager.getter("currentZoomFactor",
                superclassCall:
                    
                                    super.currentZoomFactor
                    ,
                defaultCall:  __defaultImplStub!.currentZoomFactor)
        }
        
    }
    
    
    
    
    
    public override var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> {
        get {
            return cuckoo_manager.getter("videoFilePublisher",
                superclassCall:
                    
                                    super.videoFilePublisher
                    ,
                defaultCall:  __defaultImplStub!.videoFilePublisher)
        }
        
    }
    
    
    
    
    
    public override var previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never> {
        get {
            return cuckoo_manager.getter("previewLayerPublisher",
                superclassCall:
                    
                                    super.previewLayerPublisher
                    ,
                defaultCall:  __defaultImplStub!.previewLayerPublisher)
        }
        
    }
    
    

    

    
    
    
    
    public override func startRecording()  {
        
    return cuckoo_manager.call(
    """
    startRecording()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.startRecording()
                ,
            defaultCall: __defaultImplStub!.startRecording())
        
    }
    
    
    
    
    
    public override func stopRecording()  {
        
    return cuckoo_manager.call(
    """
    stopRecording()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.stopRecording()
                ,
            defaultCall: __defaultImplStub!.stopRecording())
        
    }
    
    
    
    
    
    public override func mute() -> AespaSession {
        
    return cuckoo_manager.call(
    """
    mute() -> AespaSession
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.mute()
                ,
            defaultCall: __defaultImplStub!.mute())
        
    }
    
    
    
    
    
    public override func unmute() -> AespaSession {
        
    return cuckoo_manager.call(
    """
    unmute() -> AespaSession
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.unmute()
                ,
            defaultCall: __defaultImplStub!.unmute())
        
    }
    
    
    
    
    
    public override func setQuality(to preset: AVCaptureSession.Preset) -> AespaSession {
        
    return cuckoo_manager.call(
    """
    setQuality(to: AVCaptureSession.Preset) -> AespaSession
    """,
            parameters: (preset),
            escapingParameters: (preset),
            superclassCall:
                
                super.setQuality(to: preset)
                ,
            defaultCall: __defaultImplStub!.setQuality(to: preset))
        
    }
    
    
    
    
    
    public override func setPosition(to position: AVCaptureDevice.Position) -> AespaSession {
        
    return cuckoo_manager.call(
    """
    setPosition(to: AVCaptureDevice.Position) -> AespaSession
    """,
            parameters: (position),
            escapingParameters: (position),
            superclassCall:
                
                super.setPosition(to: position)
                ,
            defaultCall: __defaultImplStub!.setPosition(to: position))
        
    }
    
    
    
    
    
    public override func setOrientation(to orientation: AVCaptureVideoOrientation) -> AespaSession {
        
    return cuckoo_manager.call(
    """
    setOrientation(to: AVCaptureVideoOrientation) -> AespaSession
    """,
            parameters: (orientation),
            escapingParameters: (orientation),
            superclassCall:
                
                super.setOrientation(to: orientation)
                ,
            defaultCall: __defaultImplStub!.setOrientation(to: orientation))
        
    }
    
    
    
    
    
    public override func setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaSession {
        
    return cuckoo_manager.call(
    """
    setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaSession
    """,
            parameters: (mode),
            escapingParameters: (mode),
            superclassCall:
                
                super.setStabilization(mode: mode)
                ,
            defaultCall: __defaultImplStub!.setStabilization(mode: mode))
        
    }
    
    
    
    
    
    public override func setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaSession {
        
    return cuckoo_manager.call(
    """
    setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaSession
    """,
            parameters: (mode),
            escapingParameters: (mode),
            superclassCall:
                
                super.setAutofocusing(mode: mode)
                ,
            defaultCall: __defaultImplStub!.setAutofocusing(mode: mode))
        
    }
    
    
    
    
    
    public override func zoom(factor: CGFloat) -> AespaSession {
        
    return cuckoo_manager.call(
    """
    zoom(factor: CGFloat) -> AespaSession
    """,
            parameters: (factor),
            escapingParameters: (factor),
            superclassCall:
                
                super.zoom(factor: factor)
                ,
            defaultCall: __defaultImplStub!.zoom(factor: factor))
        
    }
    
    
    
    
    
    public override func startRecordingWithError() throws {
        
    return try cuckoo_manager.callThrows(
    """
    startRecordingWithError() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.startRecordingWithError()
                ,
            defaultCall: __defaultImplStub!.startRecordingWithError())
        
    }
    
    
    
    
    
    public override func stopRecordingWithError() throws {
        
    return try cuckoo_manager.callThrows(
    """
    stopRecordingWithError() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.stopRecordingWithError()
                ,
            defaultCall: __defaultImplStub!.stopRecordingWithError())
        
    }
    
    
    
    
    
    public override func muteWithError() throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    muteWithError() throws -> AespaSession
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.muteWithError()
                ,
            defaultCall: __defaultImplStub!.muteWithError())
        
    }
    
    
    
    
    
    public override func unmuteWithError() throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    unmuteWithError() throws -> AespaSession
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.unmuteWithError()
                ,
            defaultCall: __defaultImplStub!.unmuteWithError())
        
    }
    
    
    
    
    
    public override func setQualityWithError(to preset: AVCaptureSession.Preset) throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    setQualityWithError(to: AVCaptureSession.Preset) throws -> AespaSession
    """,
            parameters: (preset),
            escapingParameters: (preset),
            superclassCall:
                
                super.setQualityWithError(to: preset)
                ,
            defaultCall: __defaultImplStub!.setQualityWithError(to: preset))
        
    }
    
    
    
    
    
    public override func setPositionWithError(to position: AVCaptureDevice.Position) throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    setPositionWithError(to: AVCaptureDevice.Position) throws -> AespaSession
    """,
            parameters: (position),
            escapingParameters: (position),
            superclassCall:
                
                super.setPositionWithError(to: position)
                ,
            defaultCall: __defaultImplStub!.setPositionWithError(to: position))
        
    }
    
    
    
    
    
    public override func setOrientationWithError(to orientation: AVCaptureVideoOrientation) throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    setOrientationWithError(to: AVCaptureVideoOrientation) throws -> AespaSession
    """,
            parameters: (orientation),
            escapingParameters: (orientation),
            superclassCall:
                
                super.setOrientationWithError(to: orientation)
                ,
            defaultCall: __defaultImplStub!.setOrientationWithError(to: orientation))
        
    }
    
    
    
    
    
    public override func setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaSession
    """,
            parameters: (mode),
            escapingParameters: (mode),
            superclassCall:
                
                super.setStabilizationWithError(mode: mode)
                ,
            defaultCall: __defaultImplStub!.setStabilizationWithError(mode: mode))
        
    }
    
    
    
    
    
    public override func setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaSession
    """,
            parameters: (mode),
            escapingParameters: (mode),
            superclassCall:
                
                super.setAutofocusingWithError(mode: mode)
                ,
            defaultCall: __defaultImplStub!.setAutofocusingWithError(mode: mode))
        
    }
    
    
    
    
    
    public override func zoomWithError(factor: CGFloat) throws -> AespaSession {
        
    return try cuckoo_manager.callThrows(
    """
    zoomWithError(factor: CGFloat) throws -> AespaSession
    """,
            parameters: (factor),
            escapingParameters: (factor),
            superclassCall:
                
                super.zoomWithError(factor: factor)
                ,
            defaultCall: __defaultImplStub!.zoomWithError(factor: factor))
        
    }
    
    
    
    
    
    public override func custom<T: AespaSessionTuning>(_ tuner: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    custom(_: T) throws
    """,
            parameters: (tuner),
            escapingParameters: (tuner),
            superclassCall:
                
                super.custom(tuner)
                ,
            defaultCall: __defaultImplStub!.custom(tuner))
        
    }
    
    
    
    
    
    public override func fetchVideoFiles(limit: Int) -> [VideoFile] {
        
    return cuckoo_manager.call(
    """
    fetchVideoFiles(limit: Int) -> [VideoFile]
    """,
            parameters: (limit),
            escapingParameters: (limit),
            superclassCall:
                
                super.fetchVideoFiles(limit: limit)
                ,
            defaultCall: __defaultImplStub!.fetchVideoFiles(limit: limit))
        
    }
    
    
    
    
    
    public override func doctor() async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    doctor() async throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                await super.doctor()
                ,
            defaultCall: await __defaultImplStub!.doctor())
        
    }
    
    

    public struct __StubbingProxy_AespaSession: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var captureSession: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAespaSession, AVCaptureSession> {
            return .init(manager: cuckoo_manager, name: "captureSession")
        }
        
        
        
        
        var isMuted: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAespaSession, Bool> {
            return .init(manager: cuckoo_manager, name: "isMuted")
        }
        
        
        
        
        var maxZoomFactor: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAespaSession, CGFloat?> {
            return .init(manager: cuckoo_manager, name: "maxZoomFactor")
        }
        
        
        
        
        var currentZoomFactor: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAespaSession, CGFloat?> {
            return .init(manager: cuckoo_manager, name: "currentZoomFactor")
        }
        
        
        
        
        var videoFilePublisher: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAespaSession, AnyPublisher<Result<VideoFile, Error>, Never>> {
            return .init(manager: cuckoo_manager, name: "videoFilePublisher")
        }
        
        
        
        
        var previewLayerPublisher: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockAespaSession, AnyPublisher<AVCaptureVideoPreviewLayer, Never>> {
            return .init(manager: cuckoo_manager, name: "previewLayerPublisher")
        }
        
        
        
        
        
        func startRecording() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    startRecording()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func stopRecording() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    stopRecording()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func mute() -> Cuckoo.ClassStubFunction<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    mute() -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func unmute() -> Cuckoo.ClassStubFunction<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    unmute() -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setQuality<M1: Cuckoo.Matchable>(to preset: M1) -> Cuckoo.ClassStubFunction<(AVCaptureSession.Preset), AespaSession> where M1.MatchedType == AVCaptureSession.Preset {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureSession.Preset)>] = [wrap(matchable: preset) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setQuality(to: AVCaptureSession.Preset) -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setPosition<M1: Cuckoo.Matchable>(to position: M1) -> Cuckoo.ClassStubFunction<(AVCaptureDevice.Position), AespaSession> where M1.MatchedType == AVCaptureDevice.Position {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.Position)>] = [wrap(matchable: position) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setPosition(to: AVCaptureDevice.Position) -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setOrientation<M1: Cuckoo.Matchable>(to orientation: M1) -> Cuckoo.ClassStubFunction<(AVCaptureVideoOrientation), AespaSession> where M1.MatchedType == AVCaptureVideoOrientation {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoOrientation)>] = [wrap(matchable: orientation) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setOrientation(to: AVCaptureVideoOrientation) -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setStabilization<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.ClassStubFunction<(AVCaptureVideoStabilizationMode), AespaSession> where M1.MatchedType == AVCaptureVideoStabilizationMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoStabilizationMode)>] = [wrap(matchable: mode) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setAutofocusing<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.ClassStubFunction<(AVCaptureDevice.FocusMode), AespaSession> where M1.MatchedType == AVCaptureDevice.FocusMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.FocusMode)>] = [wrap(matchable: mode) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func zoom<M1: Cuckoo.Matchable>(factor: M1) -> Cuckoo.ClassStubFunction<(CGFloat), AespaSession> where M1.MatchedType == CGFloat {
            let matchers: [Cuckoo.ParameterMatcher<(CGFloat)>] = [wrap(matchable: factor) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    zoom(factor: CGFloat) -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startRecordingWithError() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    startRecordingWithError() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func stopRecordingWithError() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    stopRecordingWithError() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func muteWithError() -> Cuckoo.ClassStubThrowingFunction<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    muteWithError() throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func unmuteWithError() -> Cuckoo.ClassStubThrowingFunction<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    unmuteWithError() throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setQualityWithError<M1: Cuckoo.Matchable>(to preset: M1) -> Cuckoo.ClassStubThrowingFunction<(AVCaptureSession.Preset), AespaSession> where M1.MatchedType == AVCaptureSession.Preset {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureSession.Preset)>] = [wrap(matchable: preset) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setQualityWithError(to: AVCaptureSession.Preset) throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setPositionWithError<M1: Cuckoo.Matchable>(to position: M1) -> Cuckoo.ClassStubThrowingFunction<(AVCaptureDevice.Position), AespaSession> where M1.MatchedType == AVCaptureDevice.Position {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.Position)>] = [wrap(matchable: position) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setPositionWithError(to: AVCaptureDevice.Position) throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setOrientationWithError<M1: Cuckoo.Matchable>(to orientation: M1) -> Cuckoo.ClassStubThrowingFunction<(AVCaptureVideoOrientation), AespaSession> where M1.MatchedType == AVCaptureVideoOrientation {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoOrientation)>] = [wrap(matchable: orientation) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setOrientationWithError(to: AVCaptureVideoOrientation) throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setStabilizationWithError<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.ClassStubThrowingFunction<(AVCaptureVideoStabilizationMode), AespaSession> where M1.MatchedType == AVCaptureVideoStabilizationMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoStabilizationMode)>] = [wrap(matchable: mode) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setAutofocusingWithError<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.ClassStubThrowingFunction<(AVCaptureDevice.FocusMode), AespaSession> where M1.MatchedType == AVCaptureDevice.FocusMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.FocusMode)>] = [wrap(matchable: mode) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func zoomWithError<M1: Cuckoo.Matchable>(factor: M1) -> Cuckoo.ClassStubThrowingFunction<(CGFloat), AespaSession> where M1.MatchedType == CGFloat {
            let matchers: [Cuckoo.ParameterMatcher<(CGFloat)>] = [wrap(matchable: factor) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    zoomWithError(factor: CGFloat) throws -> AespaSession
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func custom<M1: Cuckoo.Matchable, T: AespaSessionTuning>(_ tuner: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    custom(_: T) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchVideoFiles<M1: Cuckoo.Matchable>(limit: M1) -> Cuckoo.ClassStubFunction<(Int), [VideoFile]> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: limit) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    fetchVideoFiles(limit: Int) -> [VideoFile]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func doctor() -> Cuckoo.ClassStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSession.self, method:
    """
    doctor() async throws
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_AespaSession: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var captureSession: Cuckoo.VerifyReadOnlyProperty<AVCaptureSession> {
            return .init(manager: cuckoo_manager, name: "captureSession", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var isMuted: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isMuted", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var maxZoomFactor: Cuckoo.VerifyReadOnlyProperty<CGFloat?> {
            return .init(manager: cuckoo_manager, name: "maxZoomFactor", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var currentZoomFactor: Cuckoo.VerifyReadOnlyProperty<CGFloat?> {
            return .init(manager: cuckoo_manager, name: "currentZoomFactor", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var videoFilePublisher: Cuckoo.VerifyReadOnlyProperty<AnyPublisher<Result<VideoFile, Error>, Never>> {
            return .init(manager: cuckoo_manager, name: "videoFilePublisher", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var previewLayerPublisher: Cuckoo.VerifyReadOnlyProperty<AnyPublisher<AVCaptureVideoPreviewLayer, Never>> {
            return .init(manager: cuckoo_manager, name: "previewLayerPublisher", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func startRecording() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startRecording()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func stopRecording() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    stopRecording()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func mute() -> Cuckoo.__DoNotUse<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    mute() -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func unmute() -> Cuckoo.__DoNotUse<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    unmute() -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setQuality<M1: Cuckoo.Matchable>(to preset: M1) -> Cuckoo.__DoNotUse<(AVCaptureSession.Preset), AespaSession> where M1.MatchedType == AVCaptureSession.Preset {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureSession.Preset)>] = [wrap(matchable: preset) { $0 }]
            return cuckoo_manager.verify(
    """
    setQuality(to: AVCaptureSession.Preset) -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setPosition<M1: Cuckoo.Matchable>(to position: M1) -> Cuckoo.__DoNotUse<(AVCaptureDevice.Position), AespaSession> where M1.MatchedType == AVCaptureDevice.Position {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.Position)>] = [wrap(matchable: position) { $0 }]
            return cuckoo_manager.verify(
    """
    setPosition(to: AVCaptureDevice.Position) -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setOrientation<M1: Cuckoo.Matchable>(to orientation: M1) -> Cuckoo.__DoNotUse<(AVCaptureVideoOrientation), AespaSession> where M1.MatchedType == AVCaptureVideoOrientation {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoOrientation)>] = [wrap(matchable: orientation) { $0 }]
            return cuckoo_manager.verify(
    """
    setOrientation(to: AVCaptureVideoOrientation) -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setStabilization<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.__DoNotUse<(AVCaptureVideoStabilizationMode), AespaSession> where M1.MatchedType == AVCaptureVideoStabilizationMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoStabilizationMode)>] = [wrap(matchable: mode) { $0 }]
            return cuckoo_manager.verify(
    """
    setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setAutofocusing<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.__DoNotUse<(AVCaptureDevice.FocusMode), AespaSession> where M1.MatchedType == AVCaptureDevice.FocusMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.FocusMode)>] = [wrap(matchable: mode) { $0 }]
            return cuckoo_manager.verify(
    """
    setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func zoom<M1: Cuckoo.Matchable>(factor: M1) -> Cuckoo.__DoNotUse<(CGFloat), AespaSession> where M1.MatchedType == CGFloat {
            let matchers: [Cuckoo.ParameterMatcher<(CGFloat)>] = [wrap(matchable: factor) { $0 }]
            return cuckoo_manager.verify(
    """
    zoom(factor: CGFloat) -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startRecordingWithError() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startRecordingWithError() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func stopRecordingWithError() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    stopRecordingWithError() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func muteWithError() -> Cuckoo.__DoNotUse<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    muteWithError() throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func unmuteWithError() -> Cuckoo.__DoNotUse<(), AespaSession> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    unmuteWithError() throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setQualityWithError<M1: Cuckoo.Matchable>(to preset: M1) -> Cuckoo.__DoNotUse<(AVCaptureSession.Preset), AespaSession> where M1.MatchedType == AVCaptureSession.Preset {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureSession.Preset)>] = [wrap(matchable: preset) { $0 }]
            return cuckoo_manager.verify(
    """
    setQualityWithError(to: AVCaptureSession.Preset) throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setPositionWithError<M1: Cuckoo.Matchable>(to position: M1) -> Cuckoo.__DoNotUse<(AVCaptureDevice.Position), AespaSession> where M1.MatchedType == AVCaptureDevice.Position {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.Position)>] = [wrap(matchable: position) { $0 }]
            return cuckoo_manager.verify(
    """
    setPositionWithError(to: AVCaptureDevice.Position) throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setOrientationWithError<M1: Cuckoo.Matchable>(to orientation: M1) -> Cuckoo.__DoNotUse<(AVCaptureVideoOrientation), AespaSession> where M1.MatchedType == AVCaptureVideoOrientation {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoOrientation)>] = [wrap(matchable: orientation) { $0 }]
            return cuckoo_manager.verify(
    """
    setOrientationWithError(to: AVCaptureVideoOrientation) throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setStabilizationWithError<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.__DoNotUse<(AVCaptureVideoStabilizationMode), AespaSession> where M1.MatchedType == AVCaptureVideoStabilizationMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureVideoStabilizationMode)>] = [wrap(matchable: mode) { $0 }]
            return cuckoo_manager.verify(
    """
    setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setAutofocusingWithError<M1: Cuckoo.Matchable>(mode: M1) -> Cuckoo.__DoNotUse<(AVCaptureDevice.FocusMode), AespaSession> where M1.MatchedType == AVCaptureDevice.FocusMode {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.FocusMode)>] = [wrap(matchable: mode) { $0 }]
            return cuckoo_manager.verify(
    """
    setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func zoomWithError<M1: Cuckoo.Matchable>(factor: M1) -> Cuckoo.__DoNotUse<(CGFloat), AespaSession> where M1.MatchedType == CGFloat {
            let matchers: [Cuckoo.ParameterMatcher<(CGFloat)>] = [wrap(matchable: factor) { $0 }]
            return cuckoo_manager.verify(
    """
    zoomWithError(factor: CGFloat) throws -> AespaSession
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func custom<M1: Cuckoo.Matchable, T: AespaSessionTuning>(_ tuner: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return cuckoo_manager.verify(
    """
    custom(_: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchVideoFiles<M1: Cuckoo.Matchable>(limit: M1) -> Cuckoo.__DoNotUse<(Int), [VideoFile]> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: limit) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchVideoFiles(limit: Int) -> [VideoFile]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func doctor() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    doctor() async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class AespaSessionStub: AespaSession {
    
    
    
    
    public override var captureSession: AVCaptureSession {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVCaptureSession).self)
        }
        
    }
    
    
    
    
    
    public override var isMuted: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public override var maxZoomFactor: CGFloat? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CGFloat?).self)
        }
        
    }
    
    
    
    
    
    public override var currentZoomFactor: CGFloat? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CGFloat?).self)
        }
        
    }
    
    
    
    
    
    public override var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<VideoFile, Error>, Never>).self)
        }
        
    }
    
    
    
    
    
    public override var previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyPublisher<AVCaptureVideoPreviewLayer, Never>).self)
        }
        
    }
    
    

    

    
    
    
    
    public override func startRecording()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func stopRecording()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func mute() -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func unmute() -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setQuality(to preset: AVCaptureSession.Preset) -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setPosition(to position: AVCaptureDevice.Position) -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setOrientation(to orientation: AVCaptureVideoOrientation) -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func zoom(factor: CGFloat) -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func startRecordingWithError() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func stopRecordingWithError() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func muteWithError() throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func unmuteWithError() throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setQualityWithError(to preset: AVCaptureSession.Preset) throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setPositionWithError(to position: AVCaptureDevice.Position) throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setOrientationWithError(to orientation: AVCaptureVideoOrientation) throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func zoomWithError(factor: CGFloat) throws -> AespaSession  {
        return DefaultValueRegistry.defaultValue(for: (AespaSession).self)
    }
    
    
    
    
    
    public override func custom<T: AespaSessionTuning>(_ tuner: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public override func fetchVideoFiles(limit: Int) -> [VideoFile]  {
        return DefaultValueRegistry.defaultValue(for: ([VideoFile]).self)
    }
    
    
    
    
    
    public override func doctor() async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Core/AespaCoreAlbumManager.swift at 2023-06-11 07:02:50 +0000

//
//  AespaCoreAlbumManager.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation
import Photos






 class MockAespaCoreAlbumManager: AespaCoreAlbumManager, Cuckoo.ClassMock {
    
     typealias MocksType = AespaCoreAlbumManager
    
     typealias Stubbing = __StubbingProxy_AespaCoreAlbumManager
     typealias Verification = __VerificationProxy_AespaCoreAlbumManager

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AespaCoreAlbumManager?

     func enableDefaultImplementation(_ stub: AespaCoreAlbumManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func run<T: AespaAssetProcessing>(processor: T) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    run(processor: T) async throws
    """,
            parameters: (processor),
            escapingParameters: (processor),
            superclassCall:
                
                await super.run(processor: processor)
                ,
            defaultCall: await __defaultImplStub!.run(processor: processor))
        
    }
    
    

     struct __StubbingProxy_AespaCoreAlbumManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func run<M1: Cuckoo.Matchable, T: AespaAssetProcessing>(processor: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: processor) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreAlbumManager.self, method:
    """
    run(processor: T) async throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaCoreAlbumManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func run<M1: Cuckoo.Matchable, T: AespaAssetProcessing>(processor: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: processor) { $0 }]
            return cuckoo_manager.verify(
    """
    run(processor: T) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaCoreAlbumManagerStub: AespaCoreAlbumManager {
    

    

    
    
    
    
     override func run<T: AespaAssetProcessing>(processor: T) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Core/AespaCoreRecorder.swift at 2023-06-11 07:02:50 +0000

//
//  AespaCoreRecorder.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation
import Combine
import Foundation






 class MockAespaCoreRecorder: AespaCoreRecorder, Cuckoo.ClassMock {
    
     typealias MocksType = AespaCoreRecorder
    
     typealias Stubbing = __StubbingProxy_AespaCoreRecorder
     typealias Verification = __VerificationProxy_AespaCoreRecorder

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AespaCoreRecorder?

     func enableDefaultImplementation(_ stub: AespaCoreRecorder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func run<T: AespaFileOutputProcessing>(processor: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    run(processor: T) throws
    """,
            parameters: (processor),
            escapingParameters: (processor),
            superclassCall:
                
                super.run(processor: processor)
                ,
            defaultCall: __defaultImplStub!.run(processor: processor))
        
    }
    
    

     struct __StubbingProxy_AespaCoreRecorder: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func run<M1: Cuckoo.Matchable, T: AespaFileOutputProcessing>(processor: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: processor) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreRecorder.self, method:
    """
    run(processor: T) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaCoreRecorder: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func run<M1: Cuckoo.Matchable, T: AespaFileOutputProcessing>(processor: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: processor) { $0 }]
            return cuckoo_manager.verify(
    """
    run(processor: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaCoreRecorderStub: AespaCoreRecorder {
    

    

    
    
    
    
     override func run<T: AespaFileOutputProcessing>(processor: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Core/AespaCoreSession+AespaCoreSessionRepresentable.swift at 2023-06-11 07:02:50 +0000

//
//  AespaCoreSession + AespaCoreSessionRepresentable.swift
//  
//
//  Created by Young Bin on 2023/06/08.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import Foundation






public class MockAespaCoreSessionRepresentable: AespaCoreSessionRepresentable, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AespaCoreSessionRepresentable
    
    public typealias Stubbing = __StubbingProxy_AespaCoreSessionRepresentable
    public typealias Verification = __VerificationProxy_AespaCoreSessionRepresentable

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AespaCoreSessionRepresentable?

    public func enableDefaultImplementation(_ stub: AespaCoreSessionRepresentable) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var session: AVCaptureSession {
        get {
            return cuckoo_manager.getter("session",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.session)
        }
        
    }
    
    
    
    
    
    public var isRunning: Bool {
        get {
            return cuckoo_manager.getter("isRunning",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.isRunning)
        }
        
    }
    
    
    
    
    
    public var audioDeviceInput: AVCaptureDeviceInput? {
        get {
            return cuckoo_manager.getter("audioDeviceInput",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.audioDeviceInput)
        }
        
    }
    
    
    
    
    
    public var videoDeviceInput: AVCaptureDeviceInput? {
        get {
            return cuckoo_manager.getter("videoDeviceInput",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.videoDeviceInput)
        }
        
    }
    
    
    
    
    
    public var movieFileOutput: AVCaptureMovieFileOutput? {
        get {
            return cuckoo_manager.getter("movieFileOutput",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.movieFileOutput)
        }
        
    }
    
    
    
    
    
    public var previewLayer: AVCaptureVideoPreviewLayer {
        get {
            return cuckoo_manager.getter("previewLayer",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.previewLayer)
        }
        
    }
    
    

    

    
    
    
    
    public func startRunning()  {
        
    return cuckoo_manager.call(
    """
    startRunning()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startRunning())
        
    }
    
    
    
    
    
    public func stopRunning()  {
        
    return cuckoo_manager.call(
    """
    stopRunning()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopRunning())
        
    }
    
    
    
    
    
    public func addMovieInput() throws {
        
    return try cuckoo_manager.callThrows(
    """
    addMovieInput() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.addMovieInput())
        
    }
    
    
    
    
    
    public func removeMovieInput()  {
        
    return cuckoo_manager.call(
    """
    removeMovieInput()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeMovieInput())
        
    }
    
    
    
    
    
    public func addAudioInput() throws {
        
    return try cuckoo_manager.callThrows(
    """
    addAudioInput() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.addAudioInput())
        
    }
    
    
    
    
    
    public func removeAudioInput()  {
        
    return cuckoo_manager.call(
    """
    removeAudioInput()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeAudioInput())
        
    }
    
    
    
    
    
    public func addMovieFileOutput() throws {
        
    return try cuckoo_manager.callThrows(
    """
    addMovieFileOutput() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.addMovieFileOutput())
        
    }
    
    
    
    
    
    public func setCameraPosition(to position: AVCaptureDevice.Position) throws {
        
    return try cuckoo_manager.callThrows(
    """
    setCameraPosition(to: AVCaptureDevice.Position) throws
    """,
            parameters: (position),
            escapingParameters: (position),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setCameraPosition(to: position))
        
    }
    
    
    
    
    
    public func setVideoQuality(to preset: AVCaptureSession.Preset)  {
        
    return cuckoo_manager.call(
    """
    setVideoQuality(to: AVCaptureSession.Preset)
    """,
            parameters: (preset),
            escapingParameters: (preset),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setVideoQuality(to: preset))
        
    }
    
    

    public struct __StubbingProxy_AespaCoreSessionRepresentable: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var session: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaCoreSessionRepresentable, AVCaptureSession> {
            return .init(manager: cuckoo_manager, name: "session")
        }
        
        
        
        
        var isRunning: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaCoreSessionRepresentable, Bool> {
            return .init(manager: cuckoo_manager, name: "isRunning")
        }
        
        
        
        
        var audioDeviceInput: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaCoreSessionRepresentable, AVCaptureDeviceInput?> {
            return .init(manager: cuckoo_manager, name: "audioDeviceInput")
        }
        
        
        
        
        var videoDeviceInput: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaCoreSessionRepresentable, AVCaptureDeviceInput?> {
            return .init(manager: cuckoo_manager, name: "videoDeviceInput")
        }
        
        
        
        
        var movieFileOutput: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaCoreSessionRepresentable, AVCaptureMovieFileOutput?> {
            return .init(manager: cuckoo_manager, name: "movieFileOutput")
        }
        
        
        
        
        var previewLayer: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaCoreSessionRepresentable, AVCaptureVideoPreviewLayer> {
            return .init(manager: cuckoo_manager, name: "previewLayer")
        }
        
        
        
        
        
        func startRunning() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    startRunning()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func stopRunning() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    stopRunning()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func addMovieInput() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    addMovieInput() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeMovieInput() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    removeMovieInput()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func addAudioInput() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    addAudioInput() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeAudioInput() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    removeAudioInput()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func addMovieFileOutput() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    addMovieFileOutput() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setCameraPosition<M1: Cuckoo.Matchable>(to position: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AVCaptureDevice.Position)> where M1.MatchedType == AVCaptureDevice.Position {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.Position)>] = [wrap(matchable: position) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    setCameraPosition(to: AVCaptureDevice.Position) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setVideoQuality<M1: Cuckoo.Matchable>(to preset: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AVCaptureSession.Preset)> where M1.MatchedType == AVCaptureSession.Preset {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureSession.Preset)>] = [wrap(matchable: preset) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSessionRepresentable.self, method:
    """
    setVideoQuality(to: AVCaptureSession.Preset)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_AespaCoreSessionRepresentable: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var session: Cuckoo.VerifyReadOnlyProperty<AVCaptureSession> {
            return .init(manager: cuckoo_manager, name: "session", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var isRunning: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isRunning", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var audioDeviceInput: Cuckoo.VerifyReadOnlyProperty<AVCaptureDeviceInput?> {
            return .init(manager: cuckoo_manager, name: "audioDeviceInput", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var videoDeviceInput: Cuckoo.VerifyReadOnlyProperty<AVCaptureDeviceInput?> {
            return .init(manager: cuckoo_manager, name: "videoDeviceInput", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var movieFileOutput: Cuckoo.VerifyReadOnlyProperty<AVCaptureMovieFileOutput?> {
            return .init(manager: cuckoo_manager, name: "movieFileOutput", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var previewLayer: Cuckoo.VerifyReadOnlyProperty<AVCaptureVideoPreviewLayer> {
            return .init(manager: cuckoo_manager, name: "previewLayer", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func startRunning() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startRunning()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func stopRunning() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    stopRunning()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func addMovieInput() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    addMovieInput() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeMovieInput() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    removeMovieInput()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func addAudioInput() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    addAudioInput() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeAudioInput() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    removeAudioInput()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func addMovieFileOutput() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    addMovieFileOutput() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setCameraPosition<M1: Cuckoo.Matchable>(to position: M1) -> Cuckoo.__DoNotUse<(AVCaptureDevice.Position), Void> where M1.MatchedType == AVCaptureDevice.Position {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice.Position)>] = [wrap(matchable: position) { $0 }]
            return cuckoo_manager.verify(
    """
    setCameraPosition(to: AVCaptureDevice.Position) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setVideoQuality<M1: Cuckoo.Matchable>(to preset: M1) -> Cuckoo.__DoNotUse<(AVCaptureSession.Preset), Void> where M1.MatchedType == AVCaptureSession.Preset {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureSession.Preset)>] = [wrap(matchable: preset) { $0 }]
            return cuckoo_manager.verify(
    """
    setVideoQuality(to: AVCaptureSession.Preset)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class AespaCoreSessionRepresentableStub: AespaCoreSessionRepresentable {
    
    
    
    
    public var session: AVCaptureSession {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVCaptureSession).self)
        }
        
    }
    
    
    
    
    
    public var isRunning: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var audioDeviceInput: AVCaptureDeviceInput? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVCaptureDeviceInput?).self)
        }
        
    }
    
    
    
    
    
    public var videoDeviceInput: AVCaptureDeviceInput? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVCaptureDeviceInput?).self)
        }
        
    }
    
    
    
    
    
    public var movieFileOutput: AVCaptureMovieFileOutput? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVCaptureMovieFileOutput?).self)
        }
        
    }
    
    
    
    
    
    public var previewLayer: AVCaptureVideoPreviewLayer {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVCaptureVideoPreviewLayer).self)
        }
        
    }
    
    

    

    
    
    
    
    public func startRunning()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func stopRunning()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func addMovieInput() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func removeMovieInput()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func addAudioInput() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func removeAudioInput()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func addMovieFileOutput() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func setCameraPosition(to position: AVCaptureDevice.Position) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func setVideoQuality(to preset: AVCaptureSession.Preset)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Core/AespaCoreSession.swift at 2023-06-11 07:02:50 +0000

//
//  AespaCoreSessionManager.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation
import Combine
import Foundation
import UIKit






 class MockAespaCoreSession: AespaCoreSession, Cuckoo.ClassMock {
    
     typealias MocksType = AespaCoreSession
    
     typealias Stubbing = __StubbingProxy_AespaCoreSession
     typealias Verification = __VerificationProxy_AespaCoreSession

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AespaCoreSession?

     func enableDefaultImplementation(_ stub: AespaCoreSession) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var option: AespaOption {
        get {
            return cuckoo_manager.getter("option",
                superclassCall:
                    
                                    super.option
                    ,
                defaultCall:  __defaultImplStub!.option)
        }
        
        set {
            cuckoo_manager.setter("option",
                value: newValue,
                superclassCall:
                    
                    super.option = newValue
                    ,
                defaultCall: __defaultImplStub!.option = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func run<T: AespaSessionTuning>(_ tuner: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    run(_: T) throws
    """,
            parameters: (tuner),
            escapingParameters: (tuner),
            superclassCall:
                
                super.run(tuner)
                ,
            defaultCall: __defaultImplStub!.run(tuner))
        
    }
    
    
    
    
    
     override func run<T: AespaDeviceTuning>(_ tuner: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    run(_: T) throws
    """,
            parameters: (tuner),
            escapingParameters: (tuner),
            superclassCall:
                
                super.run(tuner)
                ,
            defaultCall: __defaultImplStub!.run(tuner))
        
    }
    
    
    
    
    
     override func run<T: AespaConnectionTuning>(_ tuner: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    run(_: T) throws
    """,
            parameters: (tuner),
            escapingParameters: (tuner),
            superclassCall:
                
                super.run(tuner)
                ,
            defaultCall: __defaultImplStub!.run(tuner))
        
    }
    
    
    
    
    
     override func run<T: AespaFileOutputProcessing>(_ processor: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    run(_: T) throws
    """,
            parameters: (processor),
            escapingParameters: (processor),
            superclassCall:
                
                super.run(processor)
                ,
            defaultCall: __defaultImplStub!.run(processor))
        
    }
    
    

     struct __StubbingProxy_AespaCoreSession: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var option: Cuckoo.ClassToBeStubbedProperty<MockAespaCoreSession, AespaOption> {
            return .init(manager: cuckoo_manager, name: "option")
        }
        
        
        
        
        
        func run<M1: Cuckoo.Matchable, T: AespaSessionTuning>(_ tuner: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSession.self, method:
    """
    run(_: T) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func run<M1: Cuckoo.Matchable, T: AespaDeviceTuning>(_ tuner: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSession.self, method:
    """
    run(_: T) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func run<M1: Cuckoo.Matchable, T: AespaConnectionTuning>(_ tuner: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSession.self, method:
    """
    run(_: T) throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func run<M1: Cuckoo.Matchable, T: AespaFileOutputProcessing>(_ processor: M1) -> Cuckoo.ClassStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: processor) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaCoreSession.self, method:
    """
    run(_: T) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaCoreSession: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var option: Cuckoo.VerifyProperty<AespaOption> {
            return .init(manager: cuckoo_manager, name: "option", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func run<M1: Cuckoo.Matchable, T: AespaSessionTuning>(_ tuner: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return cuckoo_manager.verify(
    """
    run(_: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func run<M1: Cuckoo.Matchable, T: AespaDeviceTuning>(_ tuner: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return cuckoo_manager.verify(
    """
    run(_: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func run<M1: Cuckoo.Matchable, T: AespaConnectionTuning>(_ tuner: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: tuner) { $0 }]
            return cuckoo_manager.verify(
    """
    run(_: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func run<M1: Cuckoo.Matchable, T: AespaFileOutputProcessing>(_ processor: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: processor) { $0 }]
            return cuckoo_manager.verify(
    """
    run(_: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaCoreSessionStub: AespaCoreSession {
    
    
    
    
     override var option: AespaOption {
        get {
            return DefaultValueRegistry.defaultValue(for: (AespaOption).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func run<T: AespaSessionTuning>(_ tuner: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func run<T: AespaDeviceTuning>(_ tuner: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func run<T: AespaConnectionTuning>(_ tuner: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     override func run<T: AespaFileOutputProcessing>(_ processor: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Processor/AespaProcessing.swift at 2023-06-11 07:02:50 +0000

//
//  AespaProcessing.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation
import Foundation
import Photos






 class MockAespaFileOutputProcessing: AespaFileOutputProcessing, Cuckoo.ProtocolMock {
    
     typealias MocksType = AespaFileOutputProcessing
    
     typealias Stubbing = __StubbingProxy_AespaFileOutputProcessing
     typealias Verification = __VerificationProxy_AespaFileOutputProcessing

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AespaFileOutputProcessing?

     func enableDefaultImplementation(_ stub: AespaFileOutputProcessing) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func process(_ output: AVCaptureFileOutput) throws {
        
    return try cuckoo_manager.callThrows(
    """
    process(_: AVCaptureFileOutput) throws
    """,
            parameters: (output),
            escapingParameters: (output),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.process(output))
        
    }
    
    

     struct __StubbingProxy_AespaFileOutputProcessing: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func process<M1: Cuckoo.Matchable>(_ output: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AVCaptureFileOutput)> where M1.MatchedType == AVCaptureFileOutput {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureFileOutput)>] = [wrap(matchable: output) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaFileOutputProcessing.self, method:
    """
    process(_: AVCaptureFileOutput) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaFileOutputProcessing: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func process<M1: Cuckoo.Matchable>(_ output: M1) -> Cuckoo.__DoNotUse<(AVCaptureFileOutput), Void> where M1.MatchedType == AVCaptureFileOutput {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureFileOutput)>] = [wrap(matchable: output) { $0 }]
            return cuckoo_manager.verify(
    """
    process(_: AVCaptureFileOutput) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaFileOutputProcessingStub: AespaFileOutputProcessing {
    

    

    
    
    
    
     func process(_ output: AVCaptureFileOutput) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}










 class MockAespaAssetProcessing: AespaAssetProcessing, Cuckoo.ProtocolMock {
    
     typealias MocksType = AespaAssetProcessing
    
     typealias Stubbing = __StubbingProxy_AespaAssetProcessing
     typealias Verification = __VerificationProxy_AespaAssetProcessing

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AespaAssetProcessing?

     func enableDefaultImplementation(_ stub: AespaAssetProcessing) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func process(_ photoLibrary: PHPhotoLibrary, _ assetCollection: PHAssetCollection) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    process(_: PHPhotoLibrary, _: PHAssetCollection) async throws
    """,
            parameters: (photoLibrary, assetCollection),
            escapingParameters: (photoLibrary, assetCollection),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.process(photoLibrary, assetCollection))
        
    }
    
    

     struct __StubbingProxy_AespaAssetProcessing: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func process<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ photoLibrary: M1, _ assetCollection: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(PHPhotoLibrary, PHAssetCollection)> where M1.MatchedType == PHPhotoLibrary, M2.MatchedType == PHAssetCollection {
            let matchers: [Cuckoo.ParameterMatcher<(PHPhotoLibrary, PHAssetCollection)>] = [wrap(matchable: photoLibrary) { $0.0 }, wrap(matchable: assetCollection) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaAssetProcessing.self, method:
    """
    process(_: PHPhotoLibrary, _: PHAssetCollection) async throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaAssetProcessing: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func process<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ photoLibrary: M1, _ assetCollection: M2) -> Cuckoo.__DoNotUse<(PHPhotoLibrary, PHAssetCollection), Void> where M1.MatchedType == PHPhotoLibrary, M2.MatchedType == PHAssetCollection {
            let matchers: [Cuckoo.ParameterMatcher<(PHPhotoLibrary, PHAssetCollection)>] = [wrap(matchable: photoLibrary) { $0.0 }, wrap(matchable: assetCollection) { $0.1 }]
            return cuckoo_manager.verify(
    """
    process(_: PHPhotoLibrary, _: PHAssetCollection) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaAssetProcessingStub: AespaAssetProcessing {
    

    

    
    
    
    
     func process(_ photoLibrary: PHPhotoLibrary, _ assetCollection: PHAssetCollection) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Processor/Asset/AssetAdditionProcessor.swift at 2023-06-11 07:02:50 +0000

//
//  AssetAddingProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import Foundation
import Photos

// MARK: - Mocks generated from file: ../Sources/Aespa/Processor/Record/FinishRecordProcessor.swift at 2023-06-11 07:02:50 +0000

//
//  FinishRecordingProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation
import Combine

// MARK: - Mocks generated from file: ../Sources/Aespa/Processor/Record/StartRecordProcessor.swift at 2023-06-11 07:02:50 +0000

//
//  RecordingStarter.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation
import Combine

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/AespaTuning.swift at 2023-06-11 07:02:50 +0000

//
//  AespaTuning.swift
//  
//
//  Created by Young Bin on 2023/06/02.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import Combine
import Foundation






public class MockAespaSessionTuning: AespaSessionTuning, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AespaSessionTuning
    
    public typealias Stubbing = __StubbingProxy_AespaSessionTuning
    public typealias Verification = __VerificationProxy_AespaSessionTuning

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AespaSessionTuning?

    public func enableDefaultImplementation(_ stub: AespaSessionTuning) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var needTransaction: Bool {
        get {
            return cuckoo_manager.getter("needTransaction",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.needTransaction)
        }
        
    }
    
    

    

    
    
    
    
    public func tune<T: AespaCoreSessionRepresentable>(_ session: T) throws {
        
    return try cuckoo_manager.callThrows(
    """
    tune(_: T) throws
    """,
            parameters: (session),
            escapingParameters: (session),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.tune(session))
        
    }
    
    

    public struct __StubbingProxy_AespaSessionTuning: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var needTransaction: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaSessionTuning, Bool> {
            return .init(manager: cuckoo_manager, name: "needTransaction")
        }
        
        
        
        
        
        func tune<M1: Cuckoo.Matchable, T: AespaCoreSessionRepresentable>(_ session: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(T)> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: session) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaSessionTuning.self, method:
    """
    tune(_: T) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_AespaSessionTuning: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var needTransaction: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "needTransaction", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func tune<M1: Cuckoo.Matchable, T: AespaCoreSessionRepresentable>(_ session: M1) -> Cuckoo.__DoNotUse<(T), Void> where M1.MatchedType == T {
            let matchers: [Cuckoo.ParameterMatcher<(T)>] = [wrap(matchable: session) { $0 }]
            return cuckoo_manager.verify(
    """
    tune(_: T) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class AespaSessionTuningStub: AespaSessionTuning {
    
    
    
    
    public var needTransaction: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    

    

    
    
    
    
    public func tune<T: AespaCoreSessionRepresentable>(_ session: T) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}










 class MockAespaConnectionTuning: AespaConnectionTuning, Cuckoo.ProtocolMock {
    
     typealias MocksType = AespaConnectionTuning
    
     typealias Stubbing = __StubbingProxy_AespaConnectionTuning
     typealias Verification = __VerificationProxy_AespaConnectionTuning

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AespaConnectionTuning?

     func enableDefaultImplementation(_ stub: AespaConnectionTuning) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func tune(_ connection: AVCaptureConnection) throws {
        
    return try cuckoo_manager.callThrows(
    """
    tune(_: AVCaptureConnection) throws
    """,
            parameters: (connection),
            escapingParameters: (connection),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.tune(connection))
        
    }
    
    

     struct __StubbingProxy_AespaConnectionTuning: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func tune<M1: Cuckoo.Matchable>(_ connection: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AVCaptureConnection)> where M1.MatchedType == AVCaptureConnection {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureConnection)>] = [wrap(matchable: connection) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaConnectionTuning.self, method:
    """
    tune(_: AVCaptureConnection) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaConnectionTuning: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func tune<M1: Cuckoo.Matchable>(_ connection: M1) -> Cuckoo.__DoNotUse<(AVCaptureConnection), Void> where M1.MatchedType == AVCaptureConnection {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureConnection)>] = [wrap(matchable: connection) { $0 }]
            return cuckoo_manager.verify(
    """
    tune(_: AVCaptureConnection) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaConnectionTuningStub: AespaConnectionTuning {
    

    

    
    
    
    
     func tune(_ connection: AVCaptureConnection) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}










 class MockAespaDeviceTuning: AespaDeviceTuning, Cuckoo.ProtocolMock {
    
     typealias MocksType = AespaDeviceTuning
    
     typealias Stubbing = __StubbingProxy_AespaDeviceTuning
     typealias Verification = __VerificationProxy_AespaDeviceTuning

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AespaDeviceTuning?

     func enableDefaultImplementation(_ stub: AespaDeviceTuning) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var needLock: Bool {
        get {
            return cuckoo_manager.getter("needLock",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.needLock)
        }
        
    }
    
    

    

    
    
    
    
     func tune(_ device: AVCaptureDevice) throws {
        
    return try cuckoo_manager.callThrows(
    """
    tune(_: AVCaptureDevice) throws
    """,
            parameters: (device),
            escapingParameters: (device),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.tune(device))
        
    }
    
    

     struct __StubbingProxy_AespaDeviceTuning: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var needLock: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAespaDeviceTuning, Bool> {
            return .init(manager: cuckoo_manager, name: "needLock")
        }
        
        
        
        
        
        func tune<M1: Cuckoo.Matchable>(_ device: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(AVCaptureDevice)> where M1.MatchedType == AVCaptureDevice {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice)>] = [wrap(matchable: device) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAespaDeviceTuning.self, method:
    """
    tune(_: AVCaptureDevice) throws
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AespaDeviceTuning: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var needLock: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "needLock", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func tune<M1: Cuckoo.Matchable>(_ device: M1) -> Cuckoo.__DoNotUse<(AVCaptureDevice), Void> where M1.MatchedType == AVCaptureDevice {
            let matchers: [Cuckoo.ParameterMatcher<(AVCaptureDevice)>] = [wrap(matchable: device) { $0 }]
            return cuckoo_manager.verify(
    """
    tune(_: AVCaptureDevice) throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AespaDeviceTuningStub: AespaDeviceTuning {
    
    
    
    
     var needLock: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    

    

    
    
    
    
     func tune(_ device: AVCaptureDevice) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Connection/VideoOrientationTuner.swift at 2023-06-11 07:02:50 +0000

//
//  VideoOrientationTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Connection/VideoStabilizationTuner.swift at 2023-06-11 07:02:50 +0000

//
//  VideoStabilizationTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Device/AutoFocusTuner.swift at 2023-06-11 07:02:50 +0000

//
//  AutoFocusTuner.swift
//  
//
//  Created by Young Bin on 2023/06/10.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import Foundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Device/ZoomTuner.swift at 2023-06-11 07:02:50 +0000

//
//  ZoomTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Session/AudioTuner.swift at 2023-06-11 07:02:50 +0000

//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Session/CameraPositionTuner.swift at 2023-06-11 07:02:50 +0000

//
//  CameraPositionTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Session/QualityTuner.swift at 2023-06-11 07:02:50 +0000

//
//  QualityTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Session/SessionLaunchTuner.swift at 2023-06-11 07:02:50 +0000

//
//  SessionLauncher.swift
//  
//
//  Created by 이영빈 on 2023/06/02
import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Tuner/Session/SessionTerminationTuner.swift at 2023-06-11 07:02:50 +0000

//
//  SessionTerminationTuner.swift
//  
//
//  Created by Young Bin on 2023/06/10.
//

import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Extension/AVFoundation+Extension.swift at 2023-06-11 07:02:50 +0000

//
//  AVFoundation + Extension.swift
//  
//
//  Created by Young Bin on 2023/05/28.
//

import Cuckoo
@testable import Aespa

import AVFoundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Extension/SwiftUI+Extension.swift at 2023-06-11 07:02:50 +0000

//
//  SwiftUI + Extension.swift
//  
//
//  Created by Young Bin on 2023/06/06.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import Combine
import SwiftUI

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Extension/UIKit+Extension.swift at 2023-06-11 07:02:50 +0000

//
//  UIKit + Extension.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import UIKit

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Log/Logger.swift at 2023-06-11 07:02:50 +0000

//
//  LoggingManager.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Cuckoo
@testable import Aespa

import Foundation






 class MockLogger: Logger, Cuckoo.ClassMock {
    
     typealias MocksType = Logger
    
     typealias Stubbing = __StubbingProxy_Logger
     typealias Verification = __VerificationProxy_Logger

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Logger?

     func enableDefaultImplementation(_ stub: Logger) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

     struct __StubbingProxy_Logger: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

     struct __VerificationProxy_Logger: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


 class LoggerStub: Logger {
    

    

    
}





// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Video/Album/AlbumImporter.swift at 2023-06-11 07:02:50 +0000

//
//  VideoAlbumProvider.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Cuckoo
@testable import Aespa

import Foundation
import Photos
import UIKit

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Video/Authorization/AuthorizationChecker.swift at 2023-06-11 07:02:50 +0000

//
//  AuthorizationManager.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import Foundation

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Video/File/VideoFileGenerator.swift at 2023-06-11 07:02:50 +0000

//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Cuckoo
@testable import Aespa

import AVFoundation
import UIKit

// MARK: - Mocks generated from file: ../Sources/Aespa/Util/Video/File/VideoFilePathProvider.swift at 2023-06-11 07:02:50 +0000

//
//  VideoFilePathProvidingService.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

import Cuckoo
@testable import Aespa

import UIKit
