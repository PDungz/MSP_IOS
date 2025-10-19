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
        guard isEnabled else { return Color.gray.opacity(.opacityOverlay) }

        switch self {
        case .primary:
            return AppColors.primaryGreen
        case .secondary:
            return AppColors.bgSecondary
        case .outline, .outlineDashed, .text:
            return Color.clear
        case .danger:
            return Color.red
        }
    }

    func foregroundColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return AppColors.textSecondary }

        switch self {
        case .primary, .danger:
            return .white
        case .secondary:
            return AppColors.textPrimary
        case .outline, .outlineDashed:
            return AppColors.primaryGreen
        case .text:
            return AppColors.primaryGreen
        }
    }

    func borderColor(isEnabled: Bool) -> Color {
        guard isEnabled else { return Color.gray.opacity(.opacityOverlay) }

        switch self {
        case .outline, .outlineDashed:
            return AppColors.primaryGreen
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
