//
//  MeshGenerators.swift
//  MeshKit
//
//  Created by Jan Tomec on 23/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation
import NumKit

/// This function creates ElementMesh object with sqaure shape and side of length 1.
///
/// Usage:
///
///     unitStructuredMesh(discretization: (x: 5, y: 3))
///
/// - Parameter discretization: Number of elements in x and y direction.
///
/// - Returns: ElementMesh.
public func unitStructuredMesh(discretization dscr: (x: Int, y: Int)) -> ElementMesh {
    
    let x: [Double] = linspace(from: 0, to: 1, n: dscr.x+1)
    let y: [Double] = linspace(from: 0, to: 1, n: dscr.y+1)
    
    var coordinates = [Coordinates]()
    for xi in x {
        for yj in y {
            coordinates.append(Coordinates(x: xi, y: yj, z: 0))
        }
    }
    
    var elements = [QuadElement]()
    for i in 0..<dscr.x {
        for j in 0..<dscr.y {
            elements.append(
                QuadElement(
                    [(dscr.y+1)*i+j, (dscr.y+1)*(i+1)+j,
                     (dscr.y+1)*(i+1)+j+1, (dscr.y+1)*i+j+1]
                )
            )
        }
    }
    
    return ElementMesh(coordinates: coordinates, elements: elements)
}

/// This function creates ElementMesh object with rectangular shape.
///
/// Usage:
///
///     structuredMesh(discretization: (x: 5, y: 3),
///                        size: (width: 3.0, height: 4.0))
///
/// - Parameter discretization: Number of elements in x and y direction.
/// - Parameter size: Geometry definition.
///
/// - Returns: ElementMesh.
public func structuredMesh(discretization dscr: (x: Int, y: Int),
                           size: (height: Double, width: Double)) -> ElementMesh {
    let unitMesh = unitStructuredMesh(discretization: dscr)
    let transformationMatrix = ScalingMatrix(vector: [size.width, size.height, 0])
    return unitMesh.transform(with: transformationMatrix)
}

/// This function creates ElementMesh object with shape of annulus.
///
/// - Warning:
/// Annulus can be between π/72 and 3π/2.
/// Outer radius must be larger than inner.
///
/// Usage:
///
///     annulusMesh(discretization: (r: 3, phi: 5),
///                        size: (r: 3.0, R: 5.0, phi: Double.pi/2))
///
/// - Parameter discretization: Number of elements in x and y direction.
/// - Parameter size: Geometry definition.
///
/// - Returns: ElementMesh.
public func annulusMesh(discretization dscr: (r: Int, phi: Int),
                        size: (R: Double, r: Double, phi: Double)) -> ElementMesh {
    
    assert(size.R > size.r, "Outer radius must be bigger than inner. R: \(size.R), r: \(size.r)")
    assert(Double.pi/72 < size.phi && size.phi < Double.pi*3/2, "phi must be between π/72 and 3π/2. phi: \(size.phi)")
    
    var mesh = structuredMesh(discretization: (dscr.phi, dscr.r),
                              size: (width: size.phi, height: size.R-size.r))
    mesh = mesh.transform(with: TranslationMatrix(vector: [0, size.r, 0]))
    
    mesh.coordinates = mesh.coordinates.map { Coordinates(x: $0.y*cos($0.x), y: $0.y*sin($0.x), z: $0.z) }
    
    return mesh
}
