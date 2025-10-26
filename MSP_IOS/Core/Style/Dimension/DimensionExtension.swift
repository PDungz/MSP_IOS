//
//  DimensionExtension.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

// MARK: - CGSize Extension
extension CGSize {
    // MARK: - Icon Sizes
    static let iconSize16: CGSize = CGSize(width: Dimension.IconSize.i16, height: Dimension.IconSize.i16)
    static let iconSize20: CGSize = CGSize(width: Dimension.IconSize.i20, height: Dimension.IconSize.i20)
    static let iconSize24: CGSize = CGSize(width: Dimension.IconSize.i24, height: Dimension.IconSize.i24)
    static let iconSize28: CGSize = CGSize(width: Dimension.IconSize.i28, height: Dimension.IconSize.i28)
    static let iconSize32: CGSize = CGSize(width: Dimension.IconSize.i32, height: Dimension.IconSize.i32)
    static let iconSize40: CGSize = CGSize(width: Dimension.IconSize.i40, height: Dimension.IconSize.i40)
    static let iconSize48: CGSize = CGSize(width: Dimension.IconSize.i48, height: Dimension.IconSize.i48)
    static let iconSizeDefault: CGSize = CGSize(width: Dimension.IconSize.default, height: Dimension.IconSize.default)

    // MARK: - Square Sizes
    static let squareSize16: CGSize = CGSize(width: 16, height: 16)
    static let squareSize24: CGSize = CGSize(width: 24, height: 24)
    static let squareSize32: CGSize = CGSize(width: 32, height: 32)
    static let squareSize40: CGSize = CGSize(width: 40, height: 40)
    static let squareSize48: CGSize = CGSize(width: 48, height: 48)
    static let squareSize56: CGSize = CGSize(width: 56, height: 56)
    static let squareSize64: CGSize = CGSize(width: 64, height: 64)

    // MARK: - Avatar Sizes
    static let avatarSmall: CGSize = CGSize(width: 32, height: 32)
    static let avatarMedium: CGSize = CGSize(width: 48, height: 48)
    static let avatarLarge: CGSize = CGSize(width: 64, height: 64)
    static let avatarExtraLarge: CGSize = CGSize(width: 80, height: 80)

    // MARK: - Button Sizes
    static let buttonSmall: CGSize = CGSize(width: 32, height: 32)
    static let buttonMedium: CGSize = CGSize(width: 44, height: 44)
    static let buttonLarge: CGSize = CGSize(width: 56, height: 56)

    // MARK: - Image Sizes
    static let imageThumbnail: CGSize = CGSize(width: 80, height: 80)
    static let imageSmall: CGSize = CGSize(width: 120, height: 120)
    static let imageMedium: CGSize = CGSize(width: 160, height: 160)
    static let imageLarge: CGSize = CGSize(width: 200, height: 200)

    // MARK: - Card Sizes
    static let cardSmall: CGSize = CGSize(width: 160, height: 200)
    static let cardMedium: CGSize = CGSize(width: 200, height: 250)
    static let cardLarge: CGSize = CGSize(width: 280, height: 320)
}

// MARK: - CGFloat Extension (cho Height/Width riêng)
extension CGFloat {
    // MARK: - Radius
    static let radiusDefault: CGFloat = Dimension.Raduis.default
    static let radius0: CGFloat = Dimension.Raduis.r0
    static let radius2: CGFloat = Dimension.Raduis.r2
    static let radius4: CGFloat = Dimension.Raduis.r4
    static let radius6: CGFloat = Dimension.Raduis.r6
    static let radius8: CGFloat = Dimension.Raduis.r8
    static let radius10: CGFloat = Dimension.Raduis.r10
    static let radius12: CGFloat = Dimension.Raduis.r12
    static let radius16: CGFloat = Dimension.Raduis.r16
    static let radius20: CGFloat = Dimension.Raduis.r20
    static let radius24: CGFloat = Dimension.Raduis.r24
    static let radius32: CGFloat = Dimension.Raduis.r32

    // MARK: - Padding
    static let paddingDefault: CGFloat = Dimension.Padding.default
    static let padding0: CGFloat = Dimension.Padding.p0
    static let padding2: CGFloat = Dimension.Padding.p2
    static let padding4: CGFloat = Dimension.Padding.p4
    static let padding6: CGFloat = Dimension.Padding.p6
    static let padding8: CGFloat = Dimension.Padding.p8
    static let padding10: CGFloat = Dimension.Padding.p10
    static let padding12: CGFloat = Dimension.Padding.p12
    static let padding14: CGFloat = Dimension.Padding.p14
    static let padding16: CGFloat = Dimension.Padding.p16
    static let padding20: CGFloat = Dimension.Padding.p20
    static let padding24: CGFloat = Dimension.Padding.p24
    static let padding32: CGFloat = Dimension.Padding.p32
    static let padding36: CGFloat = Dimension.Padding.p36
    static let padding40: CGFloat = Dimension.Padding.p40
    static let padding42: CGFloat = Dimension.Padding.p42
    static let padding48: CGFloat = Dimension.Padding.p48
    static let padding64: CGFloat = Dimension.Padding.p64

    // MARK: - Margin
    static let marginDefault: CGFloat = Dimension.Margin.default
    static let margin0: CGFloat = Dimension.Margin.m0
    static let margin2: CGFloat = Dimension.Margin.m2
    static let margin4: CGFloat = Dimension.Margin.m4
    static let margin6: CGFloat = Dimension.Margin.m6
    static let margin8: CGFloat = Dimension.Margin.m8
    static let margin10: CGFloat = Dimension.Margin.m10
    static let margin12: CGFloat = Dimension.Margin.m12
    static let margin16: CGFloat = Dimension.Margin.m16
    static let margin20: CGFloat = Dimension.Margin.m20
    static let margin24: CGFloat = Dimension.Margin.m24
    static let margin32: CGFloat = Dimension.Margin.m32

    // MARK: - Spacing
    static let spacingDefault: CGFloat = Dimension.Spacing.default
    static let spacing0: CGFloat = Dimension.Spacing.s0
    static let spacing2: CGFloat = Dimension.Spacing.s2
    static let spacing4: CGFloat = Dimension.Spacing.s4
    static let spacing6: CGFloat = Dimension.Spacing.s6
    static let spacing8: CGFloat = Dimension.Spacing.s8
    static let spacing10: CGFloat = Dimension.Spacing.s10
    static let spacing12: CGFloat = Dimension.Spacing.s12
    static let spacing16: CGFloat = Dimension.Spacing.s16
    static let spacing20: CGFloat = Dimension.Spacing.s20
    static let spacing24: CGFloat = Dimension.Spacing.s24
    static let spacing32: CGFloat = Dimension.Spacing.s32
    static let spacing36: CGFloat = Dimension.Spacing.s36
    static let spacing40: CGFloat = Dimension.Spacing.s40
    static let spacing48: CGFloat = Dimension.Spacing.s48
    static let spacing52: CGFloat = Dimension.Spacing.s52
    static let spacing56: CGFloat = Dimension.Spacing.s56
    static let spacing64: CGFloat = Dimension.Spacing.s64


    // MARK: - Border Width
    static let borderWidthDefault: CGFloat = Dimension.BorderWidth.default
    static let borderWidth0: CGFloat = Dimension.BorderWidth.bw0
    static let borderWidth1: CGFloat = Dimension.BorderWidth.bw1
    static let borderWidth2: CGFloat = Dimension.BorderWidth.bw2
    static let borderWidth3: CGFloat = Dimension.BorderWidth.bw3
    static let borderWidth4: CGFloat = Dimension.BorderWidth.bw4

    // MARK: - Icon Sizes
    static let iconSizeDefault: CGFloat = Dimension.IconSize.default
    static let iconSize16: CGFloat = Dimension.IconSize.i16
    static let iconSize20: CGFloat = Dimension.IconSize.i20
    static let iconSize24: CGFloat = Dimension.IconSize.i24
    static let iconSize28: CGFloat = Dimension.IconSize.i28
    static let iconSize32: CGFloat = Dimension.IconSize.i32
    static let iconSize40: CGFloat = Dimension.IconSize.i40
    static let iconSize42: CGFloat = Dimension.IconSize.i42
    static let iconSize48: CGFloat = Dimension.IconSize.i48
    static let iconSize56: CGFloat = Dimension.IconSize.i56
    static let iconSize64: CGFloat = Dimension.IconSize.i64
}

// MARK: - Double Extension (cho Opacity)
extension Double {
    // MARK: - Opacity (0.0 - 1.0)
    static let opacity0: Double = Dimension.Opacity.opacity0         // 0.0
    static let opacity05: Double = Dimension.Opacity.opacity05       // 0.05
    static let opacity1: Double = Dimension.Opacity.opacity1         // 0.1
    static let opacity12: Double = Dimension.Opacity.opacity12       // 0.12
    static let opacity3: Double = Dimension.Opacity.opacity3         // 0.3
    static let opacity4: Double = Dimension.Opacity.opacity4         // 0.4
    static let opacity5: Double = Dimension.Opacity.opacity5         // 0.5
    static let opacity6: Double = Dimension.Opacity.opacity6         // 0.6
    static let opacity7: Double = Dimension.Opacity.opacity7         // 0.7
    static let opacity8: Double = Dimension.Opacity.opacity8         // 0.8
    static let opacity85: Double = Dimension.Opacity.opacity85       // 0.85
    static let opacity1Full: Double = Dimension.Opacity.opacity1Full // 1.0
}

// MARK: - TimeInterval Extension
extension TimeInterval {
    static let durationDefault: TimeInterval = Dimension.Duration.default
    static let durationFast: TimeInterval = Dimension.Duration.fast
    static let durationNormal: TimeInterval = Dimension.Duration.normal
    static let durationSlow: TimeInterval = Dimension.Duration.slow
}
