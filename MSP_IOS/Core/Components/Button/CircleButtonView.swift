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
    private let style: ButtonStyleType
    private let size: CircleButtonSizeType
    private let isEnabled: Bool
    private let isLoading: Bool
    private let withShadow: Bool
    private let shadowColor: Color?
    private let shadowRadius: CGFloat?
    private let shadowOffset: CGFloat?
    private let content: () -> Content
    private let action: () -> Void

    // MARK: - Initializer
    init(
        style: ButtonStyleType = .primary,
        size: CircleButtonSizeType = .medium,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.withShadow = withShadow
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
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
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor(isEnabled: isEnabled)))
                        .scaleEffect(0.8)
                } else {
                    content()
                }
            }
            .foregroundStyle(style.foregroundColor(isEnabled: isEnabled))
            .frame(width: size.dimension, height: size.dimension)
            .background(style.backgroundColor(isEnabled: isEnabled))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        style.borderColor(isEnabled: isEnabled),
                        lineWidth: (style == .outline || style == .outlineDashed) ? .borderWidth2 : 0
                    )
            )
            .shadow(
                color: (withShadow && isEnabled) ? (shadowColor ?? .black.opacity(.opacityShadow)) : .clear,
                radius: shadowRadius ?? 8,
                x: 0,
                y: shadowOffset ?? 3
            )
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : .opacityDisabled)
        .animation(.easeInOut(duration: .durationFast), value: isLoading)
    }
}

// MARK: - CircleButtonSizeType
enum CircleButtonSizeType {
    case small
    case medium
    case large
    case extraLarge

    var dimension: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 48
        case .extraLarge: return 56
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return .iconSize16
        case .medium: return .iconSize20
        case .large: return .iconSize24
        case .extraLarge: return .iconSize28
        }
    }

    var fontSize: Font {
        switch self {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title3
        case .extraLarge: return .title2
        }
    }
}

// MARK: - Convenience Extensions
extension CircleButtonView {
    /// Circle button với icon
    init(
        icon: IconType,
        style: ButtonStyleType = .primary,
        size: CircleButtonSizeType = .medium,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        action: @escaping () -> Void
    ) where Content == AnyView {
        self.init(
            style: style,
            size: size,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            action: action
        ) {
            AnyView(
                CircleButtonView.iconView(icon, size: size, style: style, isEnabled: isEnabled)
            )
        }
    }

    /// Circle button với text đơn giản
    init(
        text: String,
        style: ButtonStyleType = .primary,
        size: CircleButtonSizeType = .medium,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        action: @escaping () -> Void
    ) where Content == Text {
        self.init(
            style: style,
            size: size,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            action: action
        ) {
            Text(text)
                .font(size.fontSize)
                .fontWeight(.bold)
        }
    }

    /// Helper icon view
    @ViewBuilder
    private static func iconView(
        _ iconType: IconType,
        size: CircleButtonSizeType,
        style: ButtonStyleType,
        isEnabled: Bool
    ) -> some View {
        switch iconType {
        case .system(let name):
            Image(systemName: name)
                .font(.system(size: size.iconSize))
                .fontWeight(.medium)

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

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: .spacing24) {
            Text("Circle Button Sizes")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(icon: .system("plus"), size: .small) {
                    print("Small")
                }

                CircleButtonView(icon: .system("heart.fill"), size: .medium) {
                    print("Medium")
                }

                CircleButtonView(icon: .system("star.fill"), size: .large) {
                    print("Large")
                }

                CircleButtonView(icon: .system("crown.fill"), size: .extraLarge) {
                    print("Extra Large")
                }
            }

            Divider()

            Text("Circle Button Styles")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(icon: .system("plus"), style: .primary) {
                    print("Primary")
                }

                CircleButtonView(icon: .system("heart"), style: .secondary) {
                    print("Secondary")
                }

                CircleButtonView(icon: .system("trash"), style: .danger) {
                    print("Danger")
                }

                CircleButtonView(icon: .system("gear"), style: .outline) {
                    print("Outline")
                }
            }

            Divider()

            Text("Circle Button with Text")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(text: "A", style: .primary, size: .small) {
                    print("A")
                }

                CircleButtonView(text: "5", style: .secondary, size: .medium) {
                    print("5")
                }

                CircleButtonView(text: "99", style: .outline, size: .large) {
                    print("99")
                }
            }

            Divider()

            Text("Circle Button with Custom Content")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(style: .primary, size: .small) {
                    print("Custom 1")
                } content: {
                    VStack(spacing: 2) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("5")
                            .font(.system(size: 8))
                    }
                }

                CircleButtonView(style: .secondary, size: .medium) {
                    print("Custom 2")
                } content: {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 18))
                }

                CircleButtonView(style: .outline, size: .large) {
                    print("Custom 3")
                } content: {
                    Text("!")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }

            Divider()

            Text("Circle Button States")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(icon: .system("checkmark"), style: .primary) {
                    print("Enabled")
                }

                CircleButtonView(icon: .system("xmark"), style: .danger, isLoading: true) {
                    print("Loading")
                }

                CircleButtonView(icon: .system("lock"), style: .secondary, isEnabled: false) {
                    print("Disabled")
                }
            }

            Divider()

            Text("Circle Button with Custom Shadow")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(
                    icon: .system("heart.fill"),
                    style: .primary,
                    shadowColor: .red.opacity(.opacityMedium),
                    shadowRadius: 12,
                    shadowOffset: 5
                ) {
                    print("Custom shadow")
                }

                CircleButtonView(
                    icon: .system("star.fill"),
                    style: .secondary,
                    withShadow: false
                ) {
                    print("No shadow")
                }
            }

            Divider()

            Text("Floating Action Button (FAB)")
                .font(.headline)

            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 200)
                    .overlay(
                        Text("Content Area")
                            .foregroundColor(.gray)
                    )

                CircleButtonView(
                    icon: .system("plus"),
                    style: .primary,
                    size: .extraLarge,
                    shadowRadius: 12,
                    shadowOffset: 6
                ) {
                    print("FAB")
                }
                .padding(.padding24)
            }
            .cornerRadius(.radius16)

            Divider()

            Text("Icon Button Group")
                .font(.headline)

            HStack(spacing: .spacing12) {
                CircleButtonView(icon: .system("house.fill"), style: .primary, size: .medium) {
                    print("Home")
                }

                CircleButtonView(icon: .system("magnifyingglass"), style: .secondary, size: .medium) {
                    print("Search")
                }

                CircleButtonView(icon: .system("bell"), style: .secondary, size: .medium) {
                    print("Notifications")
                }

                CircleButtonView(icon: .system("person"), style: .secondary, size: .medium) {
                    print("Profile")
                }
            }

            Divider()

            Text("Social Media Buttons")
                .font(.headline)

            HStack(spacing: .spacing16) {
                CircleButtonView(
                    icon: .system("heart.fill"),
                    style: .danger,
                    size: .large
                ) {
                    print("Like")
                }

                CircleButtonView(
                    icon: .system("message.fill"),
                    style: .primary,
                    size: .large
                ) {
                    print("Comment")
                }

                CircleButtonView(
                    icon: .system("paperplane.fill"),
                    style: .secondary,
                    size: .large
                ) {
                    print("Share")
                }

                CircleButtonView(
                    icon: .system("bookmark.fill"),
                    style: .outline,
                    size: .large
                ) {
                    print("Bookmark")
                }
            }
        }
        .padding(.horizontal, .padding24)
        .padding(.vertical, .spacing24)
    }
}
