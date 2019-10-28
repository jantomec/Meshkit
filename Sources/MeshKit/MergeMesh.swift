//
//  MergeMesh.swift
//  MeshKit
//
//  Created by Jan Tomec on 25/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation
import NumKit

public func mergeMesh(mesh1: ElementMesh, mesh2: ElementMesh) -> ElementMesh {
    
    let coordinates1 = mesh1.coordinates
    let elements1 = mesh1.elements
    var coordinates2 = mesh2.coordinates
    var elements2 = mesh2.elements
    
    // Find common nodes
    let commonNodes1 = coordinates1.enumerated().filter { (crds1) -> Bool in
        coordinates2.contains(where: { (crds2) -> Bool in
            crds1.element == crds2
        })
    }
    let commonNodes2 = coordinates2.enumerated().filter { (crds2) -> Bool in
        coordinates1.contains(where: { (crds1) -> Bool in
            crds1 == crds2.element
        })
    }
    
    // Substitute nodes in mesh 2
    var substitutionDictionary: [Int:Int] = [:]
    commonNodes1.enumerated().forEach {
        node in
        let index1 = node.element.offset
        let index2 = commonNodes2[node.offset].offset
        substitutionDictionary[index2] = index1
    }
    var index = coordinates1.count
    for i in 0..<coordinates2.count {
        if !commonNodes2.map({$0.offset}).contains(i) {
            substitutionDictionary[i] = index
            index += 1
        }
    }
    
    for (i, element) in elements2.enumerated() {
        for (j, node) in element.nodes.enumerated() {
            elements2[i].nodes[j] = substitutionDictionary[node]!
        }
    }
    
    // Remove duplicate nodes
    commonNodes2.map({ $0.offset }).reversed().forEach {
        coordinates2.remove(at: $0)
    }
    
    // Join data
    let elements = elements1 + elements2
    let coordinates = coordinates1 + coordinates2
    
    return ElementMesh(coordinates: coordinates, elements: elements)
}



