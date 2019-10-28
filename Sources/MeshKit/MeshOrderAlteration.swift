//
//  MeshOrderAlteration.swift
//  MeshKit
//
//  Created by Jan Tomec on 26/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation

extension ElementMesh {
    public mutating func switchOrder() {
        for (j, ele) in self.elements.enumerated() {
            switch ele.order {
            case 1:
                for (i, node) in ele.nodes.enumerated() {
                    let node1 = node
                    let node2: Int
                    if i == ele.nodes.count-1 {
                        node2 = ele.nodes.first!
                    } else {
                        node2 = ele.nodes[i+1]
                    }
                    let crds1 = self.coordinates[node1]
                    let crds2 = self.coordinates[node2]
                    let newcrds = middle(crds1, crds2)
                    let newnode = self.coordinates.enumerated().first(where: { $0.element==newcrds })?.offset ?? self.coordinates.count
                    self.elements[j].nodes.append(newnode)
                    if newnode == self.coordinates.count {
                        self.coordinates.append(newcrds)
                    }
                }
            case 2:
                self.elements[j].nodes = ele.nodes.select(with: [0,1,2,3])
            default: continue
            }
        }
        // If order from 2 to 1 -> delete unreferenced nodes
        let referencedNodes: [Int] = Array(Set(((self.elements.map { $0.nodes }).flatMap { $0 }).sorted()))
        self.coordinates = self.coordinates.select(with: referencedNodes)
        var substititionDictionary: [Int: Int] = [:]
        for (i, node) in referencedNodes.enumerated() {
            substititionDictionary[node] = i
        }
        for j in 0..<self.elements.count {
            self.elements[j].nodes = self.elements[j].nodes.map { substititionDictionary[$0]! }
        }
    }
}

func middle(_ p1: Coordinates, _ p2: Coordinates) -> Coordinates {
    var arr = p1.array
    arr.add(p2.array)
    arr.multiply(0.5)
    return Coordinates(arr)
}
