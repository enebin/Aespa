//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/05/30.
//

import Foundation

protocol Manager {
    associatedtype InputType
    func perform(_ command: InputType) async throws
}
