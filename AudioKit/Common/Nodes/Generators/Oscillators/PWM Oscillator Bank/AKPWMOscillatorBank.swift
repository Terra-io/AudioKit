//
//  AKPWMOscillatorBank.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright (c) 2016 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/// Reads from the table sequentially and repeatedly at given frequency. Linear
/// interpolation is applied for table look up from internal phase values.
///
/// - Parameters:
///   - detuningOffset: Frequency offset in Hz.
///   - detuningMultiplier: Frequency detuning multiplier
///
public class AKPWMOscillatorBank: AKPolyphonicNode {

    // MARK: - Properties

    internal var internalAU: AKPWMOscillatorBankAudioUnit?
    internal var token: AUParameterObserverToken?

    private var pulseWidthParameter: AUParameter?
    private var attackDurationParameter: AUParameter?
    private var releaseDurationParameter: AUParameter?
    private var detuningOffsetParameter: AUParameter?
    private var detuningMultiplierParameter: AUParameter?

    /// Ramp Time represents the speed at which parameters are allowed to change
    public var rampTime: Double = AKSettings.rampTime {
        willSet {
            if rampTime != newValue {
                internalAU?.rampTime = newValue
                internalAU?.setUpParameterRamp()
            }
        }
    }

    /// Duty cycle width (range 0-1).
    public var pulseWidth: Double = 0.5 {
        willSet {
            if pulseWidth != newValue {
                if internalAU!.isSetUp() {
                    pulseWidthParameter?.setValue(Float(newValue), originator: token!)
                } else {
                    internalAU?.pulseWidth = Float(newValue)
                }
            }
        }
    }

    /// Attack time in seconds
    public var attackDuration: Double = 0 {
        willSet {
            if attackDuration != newValue {
                if internalAU!.isSetUp() {
                    attackDurationParameter?.setValue(Float(newValue), originator: token!)
                } else {
                    internalAU?.attackDuration = Float(newValue)
                }
            }
        }
    }

    /// Release time in seconds
    public var releaseDuration: Double = 0 {
        willSet {
            if releaseDuration != newValue {
                if internalAU!.isSetUp() {
                    releaseDurationParameter?.setValue(Float(newValue), originator: token!)
                } else {
                    internalAU?.releaseDuration = Float(newValue)
                }
            }
        }
    }

    /// Frequency offset in Hz.
    public var detuningOffset: Double = 0 {
        willSet {
            if detuningOffset != newValue {
                if internalAU!.isSetUp() {
                    detuningOffsetParameter?.setValue(Float(newValue), originator: token!)
                } else {
                    internalAU?.detuningOffset = Float(newValue)
                }
            }
        }
    }

    /// Frequency detuning multiplier
    public var detuningMultiplier: Double = 1 {
        willSet {
            if detuningMultiplier != newValue {
                if internalAU!.isSetUp() {
                    detuningMultiplierParameter?.setValue(Float(newValue), originator: token!)
                } else {
                    internalAU?.detuningMultiplier = Float(newValue)
                }
            }
        }
    }

    // MARK: - Initialization

    /// Initialize this oscillator node
    ///
    /// - Parameters:
    ///   - waveform:  The waveform of oscillation
    ///   - frequency: Frequency in cycles per second
    ///   - amplitude: Output Amplitude.
    ///   - detuningOffset: Frequency offset in Hz.
    ///   - detuningMultiplier: Frequency detuning multiplier
    ///
    public init(
        pulseWidth: Double = 0.5,
        attackDuration: Double = 0.001,
        releaseDuration: Double = 0.001,
        detuningOffset: Double = 0,
        detuningMultiplier: Double = 1) {

        self.pulseWidth = pulseWidth
        self.attackDuration = attackDuration
        self.releaseDuration = releaseDuration
        self.detuningOffset = detuningOffset
        self.detuningMultiplier = detuningMultiplier

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Generator
        description.componentSubType      = 0x70776d62 /*'pwmb'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKPWMOscillatorBankAudioUnit.self,
            as: description,
            name: "Local AKPWMOscillatorBank",
            version: UInt32.max)

        super.init()
        AVAudioUnit.instantiate(with: description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitGenerator = avAudioUnit else { return }

            self.avAudioNode = avAudioUnitGenerator
            self.internalAU = avAudioUnitGenerator.auAudioUnit as? AKPWMOscillatorBankAudioUnit

            AudioKit.engine.attach(self.avAudioNode)
        }

        guard let tree = internalAU?.parameterTree else { return }

        pulseWidthParameter         = tree.value(forKey: "pulseWidth")         as? AUParameter
        attackDurationParameter     = tree.value(forKey: "attackDuration")     as? AUParameter
        releaseDurationParameter    = tree.value(forKey: "releaseDuration")    as? AUParameter
        detuningOffsetParameter     = tree.value(forKey: "detuningOffset")     as? AUParameter
        detuningMultiplierParameter = tree.value(forKey: "detuningMultiplier") as? AUParameter

        token = tree.token {
            address, value in

            DispatchQueue.main.async {
                if address == self.pulseWidthParameter!.address {
                    self.pulseWidth = Double(value)
                } else if address == self.attackDurationParameter!.address {
                    self.attackDuration = Double(value)
                } else if address == self.releaseDurationParameter!.address {
                    self.releaseDuration = Double(value)
                } else if address == self.detuningOffsetParameter!.address {
                    self.detuningOffset = Double(value)
                } else if address == self.detuningMultiplierParameter!.address {
                    self.detuningMultiplier = Double(value)
                }
            }
        }
        internalAU?.pulseWidth = Float(pulseWidth)
        internalAU?.attackDuration = Float(attackDuration)
        internalAU?.releaseDuration = Float(releaseDuration)
        internalAU?.detuningOffset = Float(detuningOffset)
        internalAU?.detuningMultiplier = Float(detuningMultiplier)
    }

    // MARK: - AKPolyphonic

    /// Function to start, play, or activate the node, all do the same thing
    public override func play(noteNumber: Int, velocity: MIDIVelocity) {
        self.internalAU!.startNote(Int32(noteNumber), velocity: Int32(velocity))
    }

    /// Function to stop or bypass the node, both are equivalent
    public override func stop(noteNumber: MIDINoteNumber) {
        self.internalAU!.stopNote(Int32(noteNumber))
    }
}
