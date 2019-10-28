//
//  MeshElement.swift
//  MeshKit
//
//  Created by Jan Tomec on 26/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation
import NumKit

public protocol MeshElement {
    var nodes: [Int] { get set }
    var order: Int { get }
}

public struct QuadElement: MeshElement {
    public var nodes: [Int]
    public init(_ nodes: [Int]) {
        assert(nodes.count == 4 || nodes.count == 8,
               "Node count for QuadElement must be either 4 or 8, not \(nodes.count).")
        self.nodes = nodes
    }
    
    public var order: Int {
        get {
            if nodes.count == 4 {
                return 1
            } else {
                return 2
            }
        }
    }
}
