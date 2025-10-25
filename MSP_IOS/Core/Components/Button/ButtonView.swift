//
//  ButtonView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 18/10/25.
//

import SwiftUI

// MARK: - ButtonView
struct ButtonView<Content: View>: View {
    // MARK: - Properties
    private let config: ButtonConfig
    private let content: () -> Content
    private let action: () -> Void

    // MARK: - Initializer
    init(
        config: ButtonConfig = ButtonConfig(),
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.config = config
        self.content = content
        self.action = action
    }

    // MARK: - Legacy Initializer (for backward compatibility)
    init(
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .small,
        fitContent: Bool = false,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.config = ButtonConfig(
            style: style,
            size: size,
            fitContent: fitContent,
            cornerRadius: cornerRadius,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset
        )
        self.content = content
        self.action = action
    }

    // MARK: - Body
    var body: some View {
        Button(action: {
            if config.isEnabled && !config.isLoading {
                action()
            }
        }) {
            Group {
                if config.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: config.effectiveForegroundColor))
                        .scaleEffect(0.8)
                } else {
                    content()
                }
            }
            .foregroundStyle(config.effectiveForegroundColor)
            .font(config.effectiveFontSize)
            .frame(maxWidth: (config.style == .text || config.fitContent) ? nil : .infinity)
            .frame(height: config.effectiveHeight)
            .padding(.horizontal, config.effectiveHorizontalPadding)
            .padding(.vertical, config.effectiveVerticalPadding)
            .background(config.effectiveBackgroundColor)
            .cornerRadius(config.effectiveCornerRadius)
            .overlay(
                Group {
                    if config.style == .outlineDashed {
                        RoundedRectangle(cornerRadius: config.effectiveCornerRadius)
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: config.effectiveBorderWidth,
                                    dash: [8, 4]
                                )
                            )
                            .foregroundStyle(config.effectiveBorderColor)
                    } else if config.style == .outline {
                        RoundedRectangle(cornerRadius: config.effectiveCornerRadius)
                            .stroke(
                                config.effectiveBorderColor,
                                lineWidth: config.effectiveBorderWidth
                            )
                    }
                }
            )
            .shadow(
                color: (config.withShadow && config.isEnabled) ? (config.shadowColor ?? .black.opacity(.opacity3)) : .clear,
                radius: config.shadowRadius ?? 8,
                x: 0,
                y: config.shadowOffset ?? 3
            )
        }
        .disabled(!config.isEnabled || config.isLoading)
        .opacity(config.isEnabled ? 1.0 : .opacity3)
        .animation(.easeInOut(duration: .durationFast), value: config.isLoading)
    }
}

// MARK: - Convenience Extensions
extension ButtonView {
    /// Button với text đơn giản
    init(
        title: String,
        config: ButtonConfig = ButtonConfig(),
        action: @escaping () -> Void
    ) where Content == Text {
        self.init(
            config: config,
            action: action
        ) {
            Text(title)
                .fontWeight(.bold)
        }
    }

    /// Button với text đơn giản (legacy - backward compatibility)
    init(
        title: String,
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .small,
        fitContent: Bool = false,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        action: @escaping () -> Void
    ) where Content == Text {
        let config = ButtonConfig(
            style: style,
            size: size,
            fitContent: fitContent,
            cornerRadius: cornerRadius,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset
        )
        self.init(
            title: title,
            config: config,
            action: action
        )
    }

    /// Button với text và icon (new API with config)
    init(
        title: String,
        icon: IconType,
        iconPosition: IconPositionType = .leading,
        config: ButtonConfig = ButtonConfig(),
        action: @escaping () -> Void
    ) where Content == AnyView {
        self.init(
            config: config,
            action: action
        ) {
            AnyView(
                HStack(spacing: .spacing8) {
                    if iconPosition == .leading {
                        ButtonView.iconView(icon, config: config)
                    }

                    Text(title)
                        .fontWeight(.bold)

                    if iconPosition == .trailing {
                        ButtonView.iconView(icon, config: config)
                    }
                }
            )
        }
    }

    /// Button với text và icon (legacy - backward compatibility)
    init(
        title: String,
        icon: IconType,
        iconPosition: IconPositionType = .leading,
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .small,
        fitContent: Bool = false,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        action: @escaping () -> Void
    ) where Content == AnyView {
        let config = ButtonConfig(
            style: style,
            size: size,
            fitContent: fitContent,
            cornerRadius: cornerRadius,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset
        )
        self.init(
            title: title,
            icon: icon,
            iconPosition: iconPosition,
            config: config,
            action: action
        )
    }

    /// Helper icon view
    @ViewBuilder
    private static func iconView(
        _ iconType: IconType,
        config: ButtonConfig
    ) -> some View {
        switch iconType {
        case .system(let name):
            Image(systemName: name)

        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: config.size.iconSize, height: config.size.iconSize)

        case .url(let urlString):
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: config.size.iconSize, height: config.size.iconSize)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: config.size.iconSize, height: config.size.iconSize)
                        .clipShape(Circle())

                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: config.size.iconSize, height: config.size.iconSize)
                        .foregroundStyle(.red)

                @unknown default:
                    EmptyView()
                }
            }

        case .custom(let image):
            image
                .resizable()
                .scaledToFit()
                .frame(width: config.size.iconSize, height: config.size.iconSize)
        }
    }
}


// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: .spacing24) {

            // MARK: - 1. Legacy API (Cách cũ - vẫn hoạt động)
            Text("1️⃣ Legacy API - Cách cũ")
                .font(.headline)

            ButtonView(title: "Primary Button", style: .primary) {
                print("Primary")
            }

            ButtonView(title: "Secondary", style: .secondary, size: .large) {
                print("Secondary")
            }

            Divider()

            // MARK: - 2. NEW API với ButtonConfig
            Text("2️⃣ NEW API - ButtonConfig")
                .font(.headline)

            ButtonView(
                title: "Config Style",
                config: ButtonConfig(
                    style: .primary,
                    size: .medium,
                    cornerRadius: .radius12
                )
            ) {
                print("Config button")
            }

            ButtonView(
                title: "Inline Config",
                config: .init(style: .secondary, fitContent: true)
            ) {
                print("Inline")
            }

            Divider()

            // MARK: - 3. Custom Colors (MỚI - Không fix cứng)
            Text("3️⃣ Custom Colors - LINH HOẠT")
                .font(.headline)

            ButtonView(
                title: "Custom Background",
                config: ButtonConfig(
                    style: .primary,
                    backgroundColor: .purple,
                    foregroundColor: .yellow
                )
            ) {
                print("Purple")
            }

            ButtonView(
                title: "Custom Border",
                config: ButtonConfig(
                    style: .outline,
                    foregroundColor: .orange, borderColor: .orange,
                    borderWidth: 4
                )
            ) {
                print("Orange border")
            }

            Divider()

            // MARK: - 4. Custom Sizing (MỚI - Không fix cứng)
            Text("4️⃣ Custom Sizing - LINH HOẠT")
                .font(.headline)

            ButtonView(
                title: "Extra Large Custom",
                config: ButtonConfig(
                    style: .primary,
                    height: 70,
                    horizontalPadding: 40,
                    fontSize: .title2
                )
            ) {
                print("Big")
            }

            ButtonView(
                title: "Mini",
                config: ButtonConfig(
                    style: .secondary,
                    fitContent: true,
                    height: 28,
                    horizontalPadding: 10,
                    fontSize: .caption
                )
            ) {
                print("Small")
            }

            Divider()

            // MARK: - 5. Button với Icon - NEW
            Text("5️⃣ Button với Icon")
                .font(.headline)

            HStack {
                ButtonView(
                    title: "Back",
                    icon: .system("arrow.left"),
                    config: ButtonConfig(
                        style: .text,
                        fitContent: true,
                        withShadow: false,
                        foregroundColor: AppColors.grabGreen
                    )
                ) {
                    print("Back")
                }
                Spacer()
            }

            ButtonView(
                title: "Star Button",
                icon: .system("star.fill"),
                config: ButtonConfig(
                    style: .primary,
                    cornerRadius: .radius32,
                    backgroundColor: .orange
                )
            ) {
                print("Star")
            }

            Divider()

            // MARK: - 6. Kết hợp tất cả options
            Text("6️⃣ Full Customization")
                .font(.headline)

            ButtonView(
                title: "Fully Custom",
                config: ButtonConfig(
                    style: .outline,
                    fitContent: false,
                    cornerRadius: .radius24,
                    withShadow: true,
                    shadowColor: .blue.opacity(0.4),
                    shadowRadius: 10,
                    shadowOffset: 5,
                    backgroundColor: .cyan.opacity(0.1),
                    foregroundColor: .blue,
                    borderColor: .blue,
                    borderWidth: 3,
                    height: 60,
                    fontSize: .title3
                )
            ) {
                print("Full custom")
            }

            Divider()

            // MARK: - 7. States
            Text("7️⃣ Button States")
                .font(.headline)

            ButtonView(
                title: "Loading...",
                config: ButtonConfig(
                    style: .primary,
                    isLoading: true
                )
            ) {
                print("Loading")
            }

            ButtonView(
                title: "Disabled",
                config: ButtonConfig(
                    style: .secondary,
                    isEnabled: false
                )
            ) {
                print("Disabled")
            }

            Divider()

            // MARK: - 8. Custom Content
            Text("8️⃣ Custom Content")
                .font(.headline)

            ButtonView(
                config: ButtonConfig(
                    style: .primary,
                    cornerRadius: .radius20,
                    height: 80
                )
            ) {
                print("Premium")
            } content: {
                VStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                    Text("Premium")
                        .font(.headline)
                    Text("Nâng cấp ngay")
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal, .padding24)
        .padding(.vertical, .spacing24)
    }
}
