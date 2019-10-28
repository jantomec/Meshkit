//
//  MKPlotOptions.swift
//  MeshKit
//
//  Created by Jan Tomec on 23/04/2019.
//  Copyright © 2019 Jan Tomec. All rights reserved.
//

import Foundation

/// MKPlotOptions are parameters for MeshKit visualize method.
public enum MKPlotOptions {
    /// nodeLabels: Bool -> Show node labels
    case nodeLabels
    /// elementLabels: Bool -> Show element labels
    case elementLabels
    /// nodeColor: UIColor -> Color of node dots and labels
    case nodeColor
    /// elementColor: UIColor -> Color of element labels
    case elementColor
}
