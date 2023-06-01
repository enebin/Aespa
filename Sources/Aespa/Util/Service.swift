//
//  Service.swift
//  
//
//  Created by 이영빈 on 2023/05/30.
//

import Foundation

protocol Service {
    associatedtype InputType
    associatedtype OutputType
    func process(_ input: InputType) async throws -> OutputType
}
