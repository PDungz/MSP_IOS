//
//  ButtonView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 18/10/25.
//

import SwiftUI

// MARK: - ButtonView
struct ButtonView: View {
    // MARK: - Properties
    private let title: String
    private let icon: IconType?
    private let iconPosition: IconPositionType
    private let style: ButtonStyleType
    private let size: ButtonSizeType
    private let isEnabled: Bool
    private let isLoading: Bool
    private let withShadow: Bool
    private let customShadowColor: Color?     // THÊM MỚI
    private let customShadowRadius: CGFloat?  // THÊM MỚI
    private let customShadowOffset: CGFloat?  // THÊM MỚI
    private let action: () -> Void

    // MARK: - Single Initializer
    init(
        title: String,
        icon: IconType? = nil,
        iconName: String? = nil,
        iconPosition: IconPositionType = .leading,
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .small,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,      // THÊM MỚI - Custom shadow color
        shadowRadius: CGFloat? = nil,   // THÊM MỚI - Custom shadow radius
        shadowOffset: CGFloat? = nil,   // THÊM MỚI - Custom shadow offset
        action: @escaping () -> Void
    ) {
        self.title = title
        if let icon = icon {
            self.icon = icon
        } else if let iconName = iconName {
            self.icon = .system(iconName)
        } else {
            self.icon = nil
        }
        self.iconPosition = iconPosition
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.withShadow = withShadow
        self.customShadowColor = shadowColor
        self.customShadowRadius = shadowRadius
        self.customShadowOffset = shadowOffset
        self.action = action
    }

    // MARK: - Body
    var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: .spacing8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor(isEnabled: isEnabled)))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon, iconPosition == .leading {
                        iconView(icon)
                    }

                    Text(title)
                        .font(size.fontSize)
                        .fontWeight(.bold)

                    if let icon = icon, iconPosition == .trailing {
                        iconView(icon)
                    }
                }
            }
            .foregroundStyle(style.foregroundColor(isEnabled: isEnabled))
            .frame(maxWidth: style == .text ? nil : .infinity)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(style.backgroundColor(isEnabled: isEnabled))
            .cornerRadius(.radius16)
            .overlay(
                Group {
                    if style == .outlineDashed {
                        RoundedRectangle(cornerRadius: .radius16)
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: 1.5,
                                    dash: [8, 4]
                                )
                            )
                            .foregroundStyle(style.borderColor(isEnabled: isEnabled))
                    } else if style == .outline {
                        RoundedRectangle(cornerRadius: .radius16)
                            .stroke(style.borderColor(isEnabled: isEnabled), lineWidth: 1.5)
                    }
                }
            )
            // Shadow với custom options
            .shadow(
                color: finalShadowColor,
                radius: finalShadowRadius,
                x: 0,
                y: finalShadowOffset
            )
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(.easeInOut(duration: .durationFast), value: isLoading)
    }

    // MARK: - Shadow Computed Properties
    private var finalShadowColor: Color {
        // Nếu không enable shadow hoặc disabled, return clear
        if !withShadow || !isEnabled {
            return .clear
        }

        // Nếu có custom shadow color, dùng nó
        if let customColor = customShadowColor {
            return customColor
        }

        // Default shadow color theo style
        return defaultShadowColor
    }

    private var defaultShadowColor: Color {
        switch style {
        case .primary:
            return AppColors.primaryGreen.opacity(.opacityShadow)
        case .secondary:
            return Color.black.opacity(0.08)
        case .danger:
            return Color.red.opacity(0.15)
        case .outline, .outlineDashed:
            return AppColors.primaryGreen.opacity(0.08)
        case .text:
            return .clear
        }
    }

    private var finalShadowRadius: CGFloat {
        // Nếu có custom radius, dùng nó
        if let customRadius = customShadowRadius {
            return customRadius
        }

        // Default radius theo size
        return defaultShadowRadius
    }

    private var defaultShadowRadius: CGFloat {
        switch size {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }

    private var finalShadowOffset: CGFloat {
        // Nếu có custom offset, dùng nó
        if let customOffset = customShadowOffset {
            return customOffset
        }

        // Default offset theo size
        return defaultShadowOffset
    }

    private var defaultShadowOffset: CGFloat {
        switch size {
        case .small: return 2
        case .medium: return 3
        case .large: return 4
        }
    }

    // MARK: - Icon View Builder
    @ViewBuilder
    private func iconView(_ iconType: IconType) -> some View {
        switch iconType {
        case .system(let name):
            Image(systemName: name)
                .font(size.fontSize)
                .foregroundStyle(style.foregroundColor(isEnabled: isEnabled))

        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: size.iconSize, height: size.iconSize)

        case .url(let urlString):
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size.iconSize, height: size.iconSize)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.iconSize, height: size.iconSize)
                        .clipShape(Circle())

                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.iconSize, height: size.iconSize)
                        .foregroundStyle(.red)

                @unknown default:
                    EmptyView()
                }
            }

        case .custom(let image):
            image
                .resizable()
                .scaledToFit()
                .frame(width: size.iconSize, height: size.iconSize)
        }
    }
}


#Preview {
    VStack(spacing: .spacing16) {
        ButtonView(
            title: "Primary Button",
            style: .primary,
            shadowColor: AppColors.primaryGreen.opacity(
                .opacityDefault
            )
        ) {
            print("Primary tapped")
        }

        ButtonView(title: "Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }

        ButtonView(title: "Outline Button", style: .outline) {
            print("Outline tapped")
        }

        ButtonView(title: "Outline Dashed Button", style: .outlineDashed) {
            print("Outline Dashed tapped")
        }

        ButtonView(title: "Text Button", style: .text) {
            print("Text tapped")
        }

        ButtonView(title: "Delete", style: .danger) {
            print("Danger tapped")
        }

        ButtonView(title: "Disabled Button", isEnabled: false) {
            print("Disabled tapped")
        }
    }
    .padding(.horizontal, .padding24)
}
