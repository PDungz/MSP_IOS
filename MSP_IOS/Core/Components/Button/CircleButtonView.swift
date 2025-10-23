//
//  CircleButtonView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//
import SwiftUI

// MARK: - CircleButtonView
struct CircleButtonView<Content: View>: View {
    // MARK: - Properties
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    private let size: CGFloat
    private let isEnabled: Bool
    private let isLoading: Bool
    private let withShadow: Bool
    private let shadowColor: Color
    private let shadowRadius: CGFloat
    private let shadowX: CGFloat
    private let shadowY: CGFloat
    private let disabledOpacity: Double
    private let content: () -> Content
    private let action: () -> Void

    // MARK: - Initializer
    init(
        backgroundColor: Color = AppColors.primaryGreen,
        foregroundColor: Color = .white,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 48,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color = .black.opacity(0.2),
        shadowRadius: CGFloat = 8,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 3,
        disabledOpacity: Double = 0.5,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.withShadow = withShadow
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.disabledOpacity = disabledOpacity
        self.content = content
        self.action = action
    }

    // MARK: - Body
    var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                action()
            }
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    content()
                        .foregroundStyle(foregroundColor)
                }
            }
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color: (withShadow && isEnabled) ? shadowColor : .clear,
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : disabledOpacity)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Convenience Extensions

extension CircleButtonView {
    /// Circle button với IconType
    init(
        icon: IconType,
        iconSize: CGFloat = 20,
        iconWeight: Font.Weight = .medium,
        backgroundColor: Color = AppColors.primaryGreen,
        foregroundColor: Color = .white,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 48,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color = .black.opacity(0.2),
        shadowRadius: CGFloat = 8,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 3,
        disabledOpacity: Double = 0.5,
        action: @escaping () -> Void
    ) where Content == AnyView {
        self.init(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            size: size,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowX: shadowX,
            shadowY: shadowY,
            disabledOpacity: disabledOpacity,
            action: action
        ) {
            AnyView(
                CircleButtonView.iconView(
                    icon,
                    size: iconSize,
                    weight: iconWeight
                )
            )
        }
    }

    /// Circle button với text
    init(
        text: String,
        font: Font = .body,
        fontWeight: Font.Weight = .bold,
        backgroundColor: Color = AppColors.primaryGreen,
        foregroundColor: Color = .white,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 48,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color = .black.opacity(0.2),
        shadowRadius: CGFloat = 8,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 3,
        disabledOpacity: Double = 0.5,
        action: @escaping () -> Void
    ) where Content == Text {
        self.init(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            size: size,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowX: shadowX,
            shadowY: shadowY,
            disabledOpacity: disabledOpacity,
            action: action
        ) {
            Text(text)
                .font(font)
                .fontWeight(fontWeight)
        }
    }

    /// Helper icon view
    @ViewBuilder
    private static func iconView(
        _ iconType: IconType,
        size: CGFloat,
        weight: Font.Weight
    ) -> some View {
        switch iconType {
        case .system(let name):
            Image(systemName: name)
                .font(.system(size: size, weight: weight))

        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)

        case .url(let urlString):
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .clipShape(Circle())

                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .foregroundStyle(.red)

                @unknown default:
                    EmptyView()
                }
            }

        case .custom(let image):
            image
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            Text("Basic Sizes")
                .font(.headline)

            HStack(spacing: 16) {
                CircleButtonView(
                    icon: .system("plus"),
                    size: 32
                ) {
                    print("Small")
                }

                CircleButtonView(
                    icon: .system("heart.fill"),
                    size: 48
                ) {
                    print("Medium")
                }

                CircleButtonView(
                    icon: .system("star.fill"),
                    size: 56
                ) {
                    print("Large")
                }

                CircleButtonView(
                    icon: .system("crown.fill"),
                    size: 64
                ) {
                    print("Extra Large")
                }
            }

            Divider()
        }
    }
}

