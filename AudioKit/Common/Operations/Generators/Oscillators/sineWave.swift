//
//  sineWave.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import Foundation

extension AKOperation {

    /// Standard Sine Wave
    ///
    /// - Parameters:
    ///   - frequency: Frequency in cycles per second (Default: 440)
    ///   - amplitude: Amplitude of the output (Default: 1)
    ///
    public static func sineWave(
        _ frequency: AKParameter = 440,
        amplitude: AKParameter = 1
        ) -> AKOperation {
            return AKOperation("(\(frequency) \(amplitude) sine)")
    }
}
