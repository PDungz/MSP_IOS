//
//  ButtonEnum.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 18/10/25.
//

import SwiftUI

// MARK: - Icon Type Enum
enum IconType {
    case system(String)           // SF Symbols
    case asset(String)            // Images trong Assets
    case url(String)              // URL từ internet
    case custom(Image)            // Custom Image
}

// MARK: - Enums (Đưa ra ngoài struct)
enum ButtonStyleType {
    case primary
    case secondary
    case outline
    case outlineDashed
    case text
    case danger

    func backgroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return AppColors.buttonDisabled }

        switch self {
        case .primary:
            return AppColors.buttonPrimary
        case .secondary:
            return AppColors.buttonSecondary
        case .outline, .outlineDashed, .text:
            return Color.clear
        case .danger:
            return AppColors.error
        }
    }

    func foregroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return AppColors.textDisabled }

        switch self {
        case .primary:
            return AppColors.textInverse
        case .danger:
            return AppColors.textInverse
        case .secondary:
            return AppColors.textPrimary
        case .outline, .outlineDashed:
            return AppColors.grabGreen
        case .text:
            return AppColors.grabGreen
        }
    }

    func borderColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return AppColors.borderDefault }

        switch self {
        case .outline, .outlineDashed:
            return AppColors.borderFocus
        default:
            return Color.clear
        }
    }
}

enum ButtonSizeType {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return .spacing24
        case .medium: return .spacing40
        case .large: return .spacing56
        }
    }

    var fontSize: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .headline
        case .large: return .title3
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return .padding12
        case .medium: return .padding16
        case .large: return .padding20
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return .padding14
        case .medium: return .padding16
        case .large: return .padding20
        }
    }
}

enum IconPositionType {
    case leading
    case trailing
}

// MARK: - Button Configuration
struct ButtonConfig {
    // Style & Appearance
    var style: ButtonStyleType
    var size: ButtonSizeType

    // Layout
    var fitContent: Bool
    var cornerRadius: CGFloat?

    // State
    var isEnabled: Bool
    var isLoading: Bool

    // Shadow
    var withShadow: Bool
    var shadowColor: Color?
    var shadowRadius: CGFloat?
    var shadowOffset: CGFloat?

    // Custom Colors (override style defaults)
    var backgroundColor: Color?
    var foregroundColor: Color?
    var borderColor: Color?
    var borderWidth: CGFloat?

    // Custom Sizing (override size defaults)
    var height: CGFloat?
    var horizontalPadding: CGFloat?
    var verticalPadding: CGFloat?
    var fontSize: Font?

    // Default initializer
    init(
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .small,
        fitContent: Bool = false,
        cornerRadius: CGFloat? = nil,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        backgroundColor: Color? = nil,
        foregroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        height: CGFloat? = nil,
        horizontalPadding: CGFloat? = nil,
        verticalPadding: CGFloat? = nil,
        fontSize: Font? = nil
    ) {
        self.style = style
        self.size = size
        self.fitContent = fitContent
        self.cornerRadius = cornerRadius
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.withShadow = withShadow
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.fontSize = fontSize
    }

    // Computed properties with fallbacks
    var effectiveBackgroundColor: Color {
        backgroundColor ?? style.backgroundColor(isEnabled: isEnabled)
    }

    var effectiveForegroundColor: Color {
        foregroundColor ?? style.foregroundColor(isEnabled: isEnabled)
    }

    var effectiveBorderColor: Color {
        borderColor ?? style.borderColor(isEnabled: isEnabled)
    }

    var effectiveBorderWidth: CGFloat {
        borderWidth ?? .borderWidth2
    }

    var effectiveHeight: CGFloat {
        height ?? size.height
    }

    var effectiveHorizontalPadding: CGFloat {
        horizontalPadding ?? size.horizontalPadding
    }

    var effectiveVerticalPadding: CGFloat {
        verticalPadding ?? size.verticalPadding
    }

    var effectiveFontSize: Font {
        fontSize ?? size.fontSize
    }

    var effectiveCornerRadius: CGFloat {
        cornerRadius ?? .radius16
    }
}
