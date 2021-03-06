//
//  square.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import Foundation

extension AKOperation {

    /// Simple square oscillator, not-band limited, can be used for LFO or wave,
    /// but squareWave is probably better for audio.
    ///
    /// - Parameters:
    ///   - frequency: In cycles per second, or Hz. (Default: 440, Minimum: 0.0, Maximum: 20000.0)
    ///   - amplitude: Output Amplitude. (Default: 0.5, Minimum: 0.0, Maximum: 1.0)
    ///
    public static func square(
        _ frequency: AKParameter = 440,
        amplitude: AKParameter = 0.5,
        phase: AKParameter = 0
        ) -> AKOperation {
            return AKOperation("\"square\" 4096 \"0 -1 2047 -1 2048 1 4095 1\" gen_line (\(frequency) \(amplitude) \(phase) \"square\" osc)")
    }
}
