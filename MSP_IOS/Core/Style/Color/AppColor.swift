//
//  AppColor.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

struct AppColors {
    // MARK: - Primary Colors (Grab Brand Colors)
    static let primaryGreen: Color = Color(red: 0.0, green: 0.8, blue: 0.4)      // #00CC66
    static let primaryGreenDark: Color = Color(red: 0.0, green: 0.67, blue: 0.33) // #00AB54
    static let primaryGreenLight: Color = Color(red: 0.2, green: 0.9, blue: 0.5)  // #33E680

    // MARK: - Secondary Colors
    static let secondaryBlue: Color = Color(red: 0.1, green: 0.6, blue: 1.0)      // #1A99FF
    static let secondaryBlueDark: Color = Color(red: 0.08, green: 0.48, blue: 0.82) // #147AD1
    static let secondaryBlueLight: Color = Color(red: 0.4, green: 0.75, blue: 1.0) // #66BFFF

    // MARK: - Neutral Colors
    static let white: Color = Color(red: 1.0, green: 1.0, blue: 1.0)              // #FFFFFF
    static let black: Color = Color(red: 0.0, green: 0.0, blue: 0.0)              // #000000

    static let gray100: Color = Color(red: 0.98, green: 0.98, blue: 0.98)         // #FAFAFA
    static let gray200: Color = Color(red: 0.95, green: 0.95, blue: 0.95)         // #F2F2F2
    static let gray300: Color = Color(red: 0.92, green: 0.92, blue: 0.92)         // #EBEBEB
    static let gray400: Color = Color(red: 0.87, green: 0.87, blue: 0.87)         // #DEDEDE
    static let gray500: Color = Color(red: 0.8, green: 0.8, blue: 0.8)            // #CCCCCC
    static let gray600: Color = Color(red: 0.67, green: 0.67, blue: 0.67)         // #ABABAB
    static let gray700: Color = Color(red: 0.53, green: 0.53, blue: 0.53)         // #878787
    static let gray800: Color = Color(red: 0.4, green: 0.4, blue: 0.4)            // #666666
    static let gray900: Color = Color(red: 0.2, green: 0.2, blue: 0.2)            // #333333

    // MARK: - Status Colors
    static let successGreen: Color = Color(red: 0.0, green: 0.8, blue: 0.4)       // #00CC66
    static let warningOrange: Color = Color(red: 1.0, green: 0.6, blue: 0.0)      // #FF9900
    static let dangerRed: Color = Color(red: 1.0, green: 0.27, blue: 0.27)        // #FF4545
    static let infoBlue: Color = Color(red: 0.1, green: 0.6, blue: 1.0)           // #1A99FF

    // MARK: - Text Colors
    static let textPrimary: Color = Color(red: 0.0, green: 0.0, blue: 0.0)        // #000000
    static let textSecondary: Color = Color(red: 0.53, green: 0.53, blue: 0.53)   // #878787
    static let textTertiary: Color = Color(red: 0.8, green: 0.8, blue: 0.8)       // #CCCCCC
    static let textInverse: Color = Color(red: 1.0, green: 1.0, blue: 1.0)        // #FFFFFF

    // MARK: - Background Colors
    static let bgPrimary: Color = Color(red: 1.0, green: 1.0, blue: 1.0)          // #FFFFFF
    static let bgSecondary: Color = Color(red: 0.98, green: 0.98, blue: 0.98)     // #FAFAFA
    static let bgTertiary: Color = Color(red: 0.95, green: 0.95, blue: 0.95)      // #F2F2F2
    static let bgInverse: Color = Color(red: 0.0, green: 0.0, blue: 0.0)          // #000000

    // MARK: - Border Colors
    static let borderLight: Color = Color(red: 0.95, green: 0.95, blue: 0.95)     // #F2F2F2
    static let borderDefault: Color = Color(red: 0.92, green: 0.92, blue: 0.92)   // #EBEBEB
    static let borderDark: Color = Color(red: 0.87, green: 0.87, blue: 0.87)      // #DEDEDE

    // MARK: - Shadow Colors
    static let shadowLight: Color = Color(.black).opacity(0.08)
    static let shadowMedium: Color = Color(.black).opacity(0.12)
    static let shadowDark: Color = Color(.black).opacity(0.16)

    // MARK: - Special Colors for Grab App
    static let grabGreen: Color = Color(red: 0.0, green: 0.8, blue: 0.4)          // Main brand
    static let rideBackground: Color = Color(red: 0.98, green: 1.0, blue: 0.98)    // Light green tint
    static let foodBackground: Color = Color(red: 1.0, green: 0.98, blue: 0.95)    // Light orange tint
    static let expressBackground: Color = Color(red: 0.95, green: 0.98, blue: 1.0) // Light blue tint
}

// MARK: - Extension for easy access
extension Color {
    // Primary
    static let grabGreen: Color = AppColors.primaryGreen
    static let grabGreenDark: Color = AppColors.primaryGreenDark
    static let grabGreenLight: Color = AppColors.primaryGreenLight

    // Secondary
    static let grabBlue: Color = AppColors.secondaryBlue
    static let grabBlueDark: Color = AppColors.secondaryBlueDark
    static let grabBlueLight: Color = AppColors.secondaryBlueLight

    // Neutral
    static let textPrimary: Color = AppColors.textPrimary
    static let textSecondary: Color = AppColors.textSecondary
    static let textTertiary: Color = AppColors.textTertiary

    // Background
    static let bgPrimary: Color = AppColors.bgPrimary
    static let bgSecondary: Color = AppColors.bgSecondary
    static let bgTertiary: Color = AppColors.bgTertiary

    // Status
    static let success: Color = AppColors.successGreen
    static let warning: Color = AppColors.warningOrange
    static let danger: Color = AppColors.dangerRed
    static let info: Color = AppColors.infoBlue

    // Borders
    static let borderLight: Color = AppColors.borderLight
    static let borderDefault: Color = AppColors.borderDefault
    static let borderDark: Color = AppColors.borderDark
}
