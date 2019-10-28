//
//  ElementMesh.swift
//  MeshKit
//
//  Created by Jan Tomec on 23/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation
import NumKit

public struct ElementMesh {
    public var coordinates: [Coordinates]
    public var elements: [MeshElement]
    
    public init(coordinates: [Coordinates], elements: [MeshElement]) {
        self.coordinates = coordinates
        self.elements = elements
    }
    
    public func transform(with transformationMatrix: TransformationMatrix) -> ElementMesh {
        let crds = self.coordinates.map {
            $0.transform(with: transformationMatrix)
        }
        return ElementMesh(coordinates: crds, elements: self.elements)
    }
}

