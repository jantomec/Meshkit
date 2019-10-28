//
//  Coordinates.swift
//  MeshKit
//
//  Created by Jan Tomec on 25/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation
import NumKit

public struct Coordinates {
    public var x: Double
    public var y: Double
    public var z: Double
    public var array: [Double] {
        get {
            return [x, y, z]
        }
        set {
            self.x = newValue[0]
            self.y = newValue[1]
            self.z = newValue[2]
        }
    }
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ array: [Double]) {
        assert(array.count == 3, "There must be exactly 3 coordinates, found \(array.count)")
        self.x = array[0]
        self.y = array[1]
        self.z = array[2]
    }
    
    public func transform(with transformationMatrix: TransformationMatrix) -> Coordinates {
        let vector = self.array+[1]
        let result = dotProduct(transformationMatrix.value, vector)
        return Coordinates(result.dropLast())
    }
    
}

extension Coordinates: Comparable {
    public static func < (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}
