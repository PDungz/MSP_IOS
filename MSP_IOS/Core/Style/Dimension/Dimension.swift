//
//  File.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import Foundation

struct Dimension {
    // MARK: - Radius
    struct Raduis {
        static let `default`: CGFloat = 8
        static let r0: CGFloat = 0
        static let r2: CGFloat = 2
        static let r4: CGFloat = 4
        static let r6: CGFloat = 6
        static let r8: CGFloat = 8
        static let r10: CGFloat = 10
        static let r12: CGFloat = 12
        static let r16: CGFloat = 16
        static let r20: CGFloat = 20
        static let r24: CGFloat = 24
        static let r32: CGFloat = 32
    }

    // MARK: - Padding
    struct Padding {
        static let `default`: CGFloat = 12
        static let p0: CGFloat = 0
        static let p2: CGFloat = 2
        static let p4: CGFloat = 4
        static let p6: CGFloat = 6
        static let p8: CGFloat = 8
        static let p10: CGFloat = 10
        static let p12: CGFloat = 12
        static let p14: CGFloat = 14
        static let p16: CGFloat = 16
        static let p20: CGFloat = 20
        static let p24: CGFloat = 24
        static let p32: CGFloat = 32
        static let p36: CGFloat = 36
        static let p40: CGFloat = 40
        static let p42: CGFloat = 42
        static let p48: CGFloat = 48
        static let p64: CGFloat = 64
    }

    // MARK: - Margin
    struct Margin {
        static let `default`: CGFloat = 12
        static let m0: CGFloat = 0
        static let m2: CGFloat = 2
        static let m4: CGFloat = 4
        static let m6: CGFloat = 6
        static let m8: CGFloat = 8
        static let m10: CGFloat = 10
        static let m12: CGFloat = 12
        static let m16: CGFloat = 16
        static let m20: CGFloat = 20
        static let m24: CGFloat = 24
        static let m32: CGFloat = 32
    }

    // MARK: - Spacing
    struct Spacing {
        static let `default`: CGFloat = 12
        static let s0: CGFloat = 0
        static let s2: CGFloat = 2
        static let s4: CGFloat = 4
        static let s6: CGFloat = 6
        static let s8: CGFloat = 8
        static let s10: CGFloat = 10
        static let s12: CGFloat = 12
        static let s16: CGFloat = 16
        static let s20: CGFloat = 20
        static let s24: CGFloat = 24
        static let s32: CGFloat = 32
        static let s36: CGFloat = 36
        static let s40: CGFloat = 40
        static let s42: CGFloat = 42
        static let s48: CGFloat = 48
        static let s52: CGFloat = 52
        static let s56: CGFloat = 56
        static let s64: CGFloat = 64
    }

    // MARK: - Border Width
    struct BorderWidth {
        static let `default`: CGFloat = 1
        static let bw0: CGFloat = 0
        static let bw1: CGFloat = 1
        static let bw2: CGFloat = 2
        static let bw3: CGFloat = 3
        static let bw4: CGFloat = 4
    }

    // MARK: - Icon Size
    struct IconSize {
        static let `default`: CGFloat = 24
        static let i16: CGFloat = 16
        static let i20: CGFloat = 20
        static let i24: CGFloat = 24
        static let i28: CGFloat = 28
        static let i32: CGFloat = 32
        static let i40: CGFloat = 40
        static let i42: CGFloat = 42
        static let i48: CGFloat = 48
        static let i56: CGFloat = 56
        static let i64: CGFloat = 64
    }

    // MARK: - Shadow
    struct Shadow {
        static let offsetX: CGFloat = 0
        static let offsetY: CGFloat = 2
        static let radius: CGFloat = 4
        static let opacity: Double = 0.1
    }

    // MARK: - Opacity
    struct Opacity {
        static let opacity0: Double = 0.0        // Invisible
        static let opacity05: Double = 0.05      // Subtle
        static let opacity1: Double = 0.1        // Light
        static let opacity12: Double = 0.12      // Shadow
        static let opacity3: Double = 0.3        // Overlay
        static let opacity4: Double = 0.4        // Disabled
        static let opacity5: Double = 0.5        // Medium
        static let opacity6: Double = 0.6        // Pressed
        static let opacity7: Double = 0.7        // Semibold
        static let opacity8: Double = 0.8        // Hover
        static let opacity85: Double = 0.85      // Bold
        static let opacity1Full: Double = 1.0    // Opaque
    }

    // MARK: - Animation Duration
    struct Duration {
        static let `default`: TimeInterval = 0.3
        static let fast: TimeInterval = 0.2
        static let normal: TimeInterval = 0.3
        static let slow: TimeInterval = 0.5
    }
}
