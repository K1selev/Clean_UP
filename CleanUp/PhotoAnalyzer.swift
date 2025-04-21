//
//  PhotoAnalyzer.swift
//  CleanUp
//
//  Created by Сергей Киселев on 07.04.2025.
//

import UIKit
import Vision

class PhotoAnalyzer {
    static func groupSimilarPhotos(from assets: [PhotoAsset]) -> [[PhotoAsset]] {
        var groups: [[PhotoAsset]] = []
        var visited = Set<Int>()

        for (i, current) in assets.enumerated() where !visited.contains(i) {
            var group = [current]
            visited.insert(i)

            for (j, other) in assets.enumerated() where !visited.contains(j) {
                if let fp1 = current.featurePrintObservation, let fp2 = other.featurePrintObservation {
                    var distance: Float = 0
                    do {
                        try fp1.computeDistance(&distance, to: fp2)
                        if distance < 15.0 {
                            group.append(other)
                            visited.insert(j)
                        }
                    } catch {
                        continue
                    }
                }
            }

            if group.count > 1 {
                groups.append(group)
            }
        }

        return groups
    }

    static func computeFeaturePrint(for image: UIImage) -> VNFeaturePrintObservation? {
        guard let cgImage = image.cgImage else { return nil }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()

        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Error computing feature print: \(error)")
            return nil
        }
    }
}
