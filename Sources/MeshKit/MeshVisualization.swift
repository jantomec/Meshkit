//
//  MeshVisualization.swift
//  MeshKit
//
//  Created by Jan Tomec on 23/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation
import PlotKit

public extension ElementMesh {
    func visualize(canvas: inout UIImageView,
                   options opts: [PKPlotOptions : Any] = [:],
                   annotations annots: [MKPlotOptions : Any] = [:]) {
        let data = self.elements.map {
            (element) -> [[Double]] in
            
            let crds: [[Double]] = self.coordinates.select(with: element.nodes).map {
                $0.array.select(with: [true, true, false])
            }
            if element.order == 1 {
                return crds.select(with: [0, 1, 2, 3, 0])
            } else {
                return crds.select(with: [0, 4, 1, 5, 2, 6, 3, 7, 0])
            }
        }
        var newopts = opts
        newopts[.legend] = false
        newopts[.interpolationOrder] = 1
        newopts[.aspectRatio] = 1.0
        newopts[.color] = opts[.color] ?? UIColor.black
        newopts[.showAxes] = opts[.showAxes] ?? false
        plot(xy: data, to: &canvas, options: newopts)
        
        if annots[.nodeLabels] as? Bool == true {
            let x = data.map { row in row.map { element in return element[0] } }
            let y = data.map { row in row.map { element in return element[1] } }
            let (xmin, xmax) = getDataExtremes(data: x,
                                               limits: newopts[.xlim] as? (from: Double,
                                                                           to: Double))
            let (ymin, ymax) = getDataExtremes(data: y,
                                               limits: newopts[.ylim] as? (from: Double,
                                                to: Double))
            
            let annotOpts: [PKPlotOptions : Any] = [
                .color : annots[.nodeColor] ?? newopts[.color] ?? UIColor.black,
                .dots : true,
                .connected : false,
                .aspectRatio : 1.0,
                .xlim : (from: xmin, to: xmax),
                .ylim : (from: ymin, to: ymax),
                .showAxes : false,
                .legend : false,
                .annotations : self.coordinates.enumerated().compactMap({ String($0.offset) })
            ]
            let points = self.coordinates.map({[$0.x, $0.y]})
            plot(xy: points, to: &canvas, options: annotOpts)
        }
        
        if annots[.elementLabels] as? Bool == true {
            let x = data.map { row in row.map { element in return element[0] } }
            let y = data.map { row in row.map { element in return element[1] } }
            let (xmin, xmax) = getDataExtremes(data: x,
                                               limits: newopts[.xlim] as? (from: Double,
                                                to: Double))
            let (ymin, ymax) = getDataExtremes(data: y,
                                               limits: newopts[.ylim] as? (from: Double,
                                                to: Double))
            
            let annotOpts: [PKPlotOptions : Any] = [
                .color : annots[.elementColor] ?? newopts[.color] ?? UIColor.black,
                .dots : false,
                .connected : false,
                .aspectRatio : 1.0,
                .xlim : (from: xmin, to: xmax),
                .ylim : (from: ymin, to: ymax),
                .showAxes : false,
                .legend : false,
                .annotations : self.coordinates.enumerated().compactMap({ String($0.offset) })
            ]
            
            let elementGeometry = self.elements.map {
                element in
                self.coordinates.select(with: element.nodes).map {
                    $0.array.select(with: [true, true, false])
                }
            }
            let elementCenter = elementGeometry.map {
                element in
                [element.map({ $0[0] }).mean, element.map({ $0[1] }).mean]
            }
            plot(xy: elementCenter, to: &canvas, options: annotOpts)
        }
    }
}
