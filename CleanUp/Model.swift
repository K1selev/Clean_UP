//
//  Model.swift
//  CleanUp
//
//  Created by Сергей Киселев on 07.04.2025.
//

import UIKit
import Photos
import Vision

struct PhotoAsset {
    let asset: PHAsset
    var image: UIImage
    var featurePrintObservation: VNFeaturePrintObservation?
    var isSelected: Bool = false
}
