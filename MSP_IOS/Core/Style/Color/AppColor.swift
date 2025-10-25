//
//  AppColor.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

struct AppColors {
    // MARK: - Primary Brand Colors (Grab Official)
    static let grabGreen: Color = Color(red: 0.0, green: 0.694, blue: 0.31)       // #00B14F - Official Grab Green
    static let grabGreenDark: Color = Color(red: 0.0, green: 0.58, blue: 0.26)    // #009442
    static let grabGreenLight: Color = Color(red: 0.0, green: 0.82, blue: 0.38)   // #00D161
    static let grabGreenPastel: Color = Color(red: 0.9, green: 0.98, blue: 0.93)  // #E5F9EE - Very light green

    // MARK: - Service Colors
    static let grabBike: Color = Color(red: 0.0, green: 0.694, blue: 0.31)        // #00B14F - Green (Xe máy)
    static let grabCar: Color = Color(red: 0.0, green: 0.694, blue: 0.31)         // #00B14F - Green (Ô tô)
    static let grabFood: Color = Color(red: 0.93, green: 0.2, blue: 0.16)         // #ED3323 - Red
    static let grabMart: Color = Color(red: 0.0, green: 0.459, blue: 0.851)       // #0075D9 - Blue
    static let grabExpress: Color = Color(red: 0.0, green: 0.459, blue: 0.851)    // #0075D9 - Blue
    static let grabPay: Color = Color(red: 0.0, green: 0.329, blue: 0.698)        // #0054B2 - Dark Blue

    // MARK: - Service Background Tints
    static let grabBikeBg: Color = Color(red: 0.9, green: 0.98, blue: 0.93)       // #E5F9EE
    static let grabCarBg: Color = Color(red: 0.9, green: 0.98, blue: 0.93)        // #E5F9EE
    static let grabFoodBg: Color = Color(red: 1.0, green: 0.95, blue: 0.95)       // #FFF2F2
    static let grabMartBg: Color = Color(red: 0.94, green: 0.97, blue: 1.0)       // #F0F7FF
    static let grabExpressBg: Color = Color(red: 0.94, green: 0.97, blue: 1.0)    // #F0F7FF
    static let grabPayBg: Color = Color(red: 0.93, green: 0.95, blue: 0.98)       // #EDF2FA

    // MARK: - Neutral Colors
    static let white: Color = Color(red: 1.0, green: 1.0, blue: 1.0)              // #FFFFFF
    static let black: Color = Color(red: 0.0, green: 0.0, blue: 0.0)              // #000000

    static let gray50: Color = Color(red: 0.988, green: 0.988, blue: 0.988)       // #FCFCFC
    static let gray100: Color = Color(red: 0.969, green: 0.969, blue: 0.969)      // #F7F7F7
    static let gray200: Color = Color(red: 0.945, green: 0.945, blue: 0.945)      // #F1F1F1
    static let gray300: Color = Color(red: 0.898, green: 0.898, blue: 0.898)      // #E5E5E5
    static let gray400: Color = Color(red: 0.784, green: 0.784, blue: 0.784)      // #C8C8C8
    static let gray500: Color = Color(red: 0.643, green: 0.643, blue: 0.643)      // #A4A4A4
    static let gray600: Color = Color(red: 0.525, green: 0.525, blue: 0.525)      // #868686
    static let gray700: Color = Color(red: 0.376, green: 0.376, blue: 0.376)      // #606060
    static let gray800: Color = Color(red: 0.259, green: 0.259, blue: 0.259)      // #424242
    static let gray900: Color = Color(red: 0.106, green: 0.106, blue: 0.106)      // #1B1B1B

    // MARK: - Status Colors
    static let success: Color = Color(red: 0.0, green: 0.694, blue: 0.31)         // #00B14F - Grab Green
    static let warning: Color = Color(red: 1.0, green: 0.6, blue: 0.0)            // #FF9900
    static let error: Color = Color(red: 0.93, green: 0.2, blue: 0.16)            // #ED3323
    static let info: Color = Color(red: 0.0, green: 0.459, blue: 0.851)           // #0075D9

    // MARK: - Text Colors
    static let textPrimary: Color = Color(red: 0.106, green: 0.106, blue: 0.106)  // #1B1B1B
    static let textSecondary: Color = Color(red: 0.376, green: 0.376, blue: 0.376) // #606060
    static let textTertiary: Color = Color(red: 0.643, green: 0.643, blue: 0.643) // #A4A4A4
    static let textDisabled: Color = Color(red: 0.784, green: 0.784, blue: 0.784) // #C8C8C8
    static let textInverse: Color = Color(red: 1.0, green: 1.0, blue: 1.0)        // #FFFFFF
    static let textLink: Color = Color(red: 0.0, green: 0.459, blue: 0.851)       // #0075D9
    static let textSuccess: Color = Color(red: 0.0, green: 0.694, blue: 0.31)     // #00B14F
    static let textError: Color = Color(red: 0.93, green: 0.2, blue: 0.16)        // #ED3323

    // MARK: - Background Colors
    static let bgPrimary: Color = Color(red: 1.0, green: 1.0, blue: 1.0)          // #FFFFFF
    static let bgSecondary: Color = Color(red: 0.969, green: 0.969, blue: 0.969)  // #F7F7F7
    static let bgTertiary: Color = Color(red: 0.945, green: 0.945, blue: 0.945)   // #F1F1F1
    static let bgInverse: Color = Color(red: 0.106, green: 0.106, blue: 0.106)    // #1B1B1B
    static let bgOverlay: Color = Color(.black).opacity(0.5)                       // Overlay cho modal/popup

    // MARK: - Border Colors
    static let borderLight: Color = Color(red: 0.945, green: 0.945, blue: 0.945)  // #F1F1F1
    static let borderDefault: Color = Color(red: 0.898, green: 0.898, blue: 0.898) // #E5E5E5
    static let borderMedium: Color = Color(red: 0.784, green: 0.784, blue: 0.784) // #C8C8C8
    static let borderDark: Color = Color(red: 0.643, green: 0.643, blue: 0.643)   // #A4A4A4
    static let borderFocus: Color = Color(red: 0.0, green: 0.694, blue: 0.31)     // #00B14F - Grab Green

    // MARK: - Shadow Colors
    static let shadowXS: Color = Color(.black).opacity(0.04)
    static let shadowSM: Color = Color(.black).opacity(0.08)
    static let shadowMD: Color = Color(.black).opacity(0.12)
    static let shadowLG: Color = Color(.black).opacity(0.16)
    static let shadowXL: Color = Color(.black).opacity(0.20)

    // MARK: - Interactive Colors
    static let buttonPrimary: Color = Color(red: 0.0, green: 0.694, blue: 0.31)   // #00B14F
    static let buttonPrimaryHover: Color = Color(red: 0.0, green: 0.58, blue: 0.26) // #009442
    static let buttonPrimaryPressed: Color = Color(red: 0.0, green: 0.478, blue: 0.216) // #007A37
    static let buttonSecondary: Color = Color(red: 1.0, green: 1.0, blue: 1.0)    // #FFFFFF
    static let buttonDisabled: Color = Color(red: 0.898, green: 0.898, blue: 0.898) // #E5E5E5

    // MARK: - Rating Colors
    static let rating5Star: Color = Color(red: 0.0, green: 0.694, blue: 0.31)     // #00B14F - Excellent
    static let rating4Star: Color = Color(red: 0.553, green: 0.776, blue: 0.286)  // #8DC649 - Good
    static let rating3Star: Color = Color(red: 1.0, green: 0.765, blue: 0.0)      // #FFC300 - Average
    static let rating2Star: Color = Color(red: 1.0, green: 0.6, blue: 0.0)        // #FF9900 - Below Average
    static let rating1Star: Color = Color(red: 0.93, green: 0.2, blue: 0.16)      // #ED3323 - Poor
}

// MARK: - Extension for easy access
extension Color {
    // Primary Brand
    static let grabGreen: Color = AppColors.grabGreen
    static let grabGreenDark: Color = AppColors.grabGreenDark
    static let grabGreenLight: Color = AppColors.grabGreenLight
    static let grabGreenPastel: Color = AppColors.grabGreenPastel

    // Services
    static let grabBike: Color = AppColors.grabBike
    static let grabCar: Color = AppColors.grabCar
    static let grabFood: Color = AppColors.grabFood
    static let grabMart: Color = AppColors.grabMart
    static let grabExpress: Color = AppColors.grabExpress
    static let grabPay: Color = AppColors.grabPay

    // Service Backgrounds
    static let grabBikeBg: Color = AppColors.grabBikeBg
    static let grabCarBg: Color = AppColors.grabCarBg
    static let grabFoodBg: Color = AppColors.grabFoodBg
    static let grabMartBg: Color = AppColors.grabMartBg
    static let grabExpressBg: Color = AppColors.grabExpressBg
    static let grabPayBg: Color = AppColors.grabPayBg

    // Neutral
    static let gray50: Color = AppColors.gray50
    static let gray100: Color = AppColors.gray100
    static let gray200: Color = AppColors.gray200
    static let gray300: Color = AppColors.gray300
    static let gray400: Color = AppColors.gray400
    static let gray500: Color = AppColors.gray500
    static let gray600: Color = AppColors.gray600
    static let gray700: Color = AppColors.gray700
    static let gray800: Color = AppColors.gray800
    static let gray900: Color = AppColors.gray900

    // Text
    static let textPrimary: Color = AppColors.textPrimary
    static let textSecondary: Color = AppColors.textSecondary
    static let textTertiary: Color = AppColors.textTertiary
    static let textDisabled: Color = AppColors.textDisabled
    static let textInverse: Color = AppColors.textInverse
    static let textLink: Color = AppColors.textLink
    static let textSuccess: Color = AppColors.textSuccess
    static let textError: Color = AppColors.textError

    // Background
    static let bgPrimary: Color = AppColors.bgPrimary
    static let bgSecondary: Color = AppColors.bgSecondary
    static let bgTertiary: Color = AppColors.bgTertiary
    static let bgInverse: Color = AppColors.bgInverse
    static let bgOverlay: Color = AppColors.bgOverlay

    // Status
    static let success: Color = AppColors.success
    static let warning: Color = AppColors.warning
    static let error: Color = AppColors.error
    static let info: Color = AppColors.info

    // Borders
    static let borderLight: Color = AppColors.borderLight
    static let borderDefault: Color = AppColors.borderDefault
    static let borderMedium: Color = AppColors.borderMedium
    static let borderDark: Color = AppColors.borderDark
    static let borderFocus: Color = AppColors.borderFocus

    // Shadows
    static let shadowXS: Color = AppColors.shadowXS
    static let shadowSM: Color = AppColors.shadowSM
    static let shadowMD: Color = AppColors.shadowMD
    static let shadowLG: Color = AppColors.shadowLG
    static let shadowXL: Color = AppColors.shadowXL

    // Interactive
    static let buttonPrimary: Color = AppColors.buttonPrimary
    static let buttonPrimaryHover: Color = AppColors.buttonPrimaryHover
    static let buttonPrimaryPressed: Color = AppColors.buttonPrimaryPressed
    static let buttonSecondary: Color = AppColors.buttonSecondary
    static let buttonDisabled: Color = AppColors.buttonDisabled

    // Rating
    static let rating5Star: Color = AppColors.rating5Star
    static let rating4Star: Color = AppColors.rating4Star
    static let rating3Star: Color = AppColors.rating3Star
    static let rating2Star: Color = AppColors.rating2Star
    static let rating1Star: Color = AppColors.rating1Star
}
