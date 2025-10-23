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
    private let style: ButtonStyleType
    private let size: ButtonSizeType
    private let fitContent: Bool
    private let isEnabled: Bool
    private let isLoading: Bool
    private let withShadow: Bool
    private let shadowColor: Color?
    private let shadowRadius: CGFloat?
    private let shadowOffset: CGFloat?
    private let cornerRadius: CGFloat?
    private let content: () -> Content
    private let action: () -> Void

    // MARK: - Initializer
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
        self.style = style
        self.size = size
        self.fitContent = fitContent
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.withShadow = withShadow
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.cornerRadius = cornerRadius
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
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor(isEnabled: isEnabled)))
                        .scaleEffect(0.8)
                } else {
                    content()
                }
            }
            .foregroundStyle(style.foregroundColor(isEnabled: isEnabled))
            .frame(maxWidth: (style == .text || fitContent) ? nil : .infinity)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(style.backgroundColor(isEnabled: isEnabled))
            .cornerRadius(cornerRadius ?? .radius16)  // ✅ Sử dụng từ DimensionExtension
            .overlay(
                Group {
                    if style == .outlineDashed {
                        RoundedRectangle(cornerRadius: cornerRadius ?? .radius16)  // ✅
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: .borderWidth2,  // ✅ Sử dụng từ DimensionExtension
                                    dash: [8, 4]
                                )
                            )
                            .foregroundStyle(style.borderColor(isEnabled: isEnabled))
                    } else if style == .outline {
                        RoundedRectangle(cornerRadius: cornerRadius ?? .radius16)  // ✅
                            .stroke(
                                style.borderColor(isEnabled: isEnabled),
                                lineWidth: .borderWidth2  // ✅ Sử dụng từ DimensionExtension
                            )
                    }
                }
            )
            .shadow(
                color: (withShadow && isEnabled) ? (shadowColor ?? .black.opacity(.opacity3)) : .clear,  // ✅ Sử dụng opacity
                radius: shadowRadius ?? 8,
                x: 0,
                y: shadowOffset ?? 3
            )
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : .opacity3)  // ✅ Sử dụng từ DimensionExtension
        .animation(.easeInOut(duration: .durationFast), value: isLoading)  // ✅ Sử dụng từ DimensionExtension
    }
}

// MARK: - Convenience Extensions
extension ButtonView {
    /// Button với text đơn giản
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
        self.init(
            style: style,
            size: size,
            fitContent: fitContent,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            cornerRadius: cornerRadius,
            action: action
        ) {
            Text(title)
                .font(size.fontSize)
                .fontWeight(.bold)
        }
    }

    /// Button với text và icon
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
        self.init(
            style: style,
            size: size,
            fitContent: fitContent,
            isEnabled: isEnabled,
            isLoading: isLoading,
            withShadow: withShadow,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            cornerRadius: cornerRadius,
            action: action
        ) {
            AnyView(
                HStack(spacing: .spacing8) {  // ✅ Sử dụng từ DimensionExtension
                    if iconPosition == .leading {
                        ButtonView.iconView(icon, size: size, style: style, isEnabled: isEnabled)
                    }

                    Text(title)
                        .font(size.fontSize)
                        .fontWeight(.bold)

                    if iconPosition == .trailing {
                        ButtonView.iconView(icon, size: size, style: style, isEnabled: isEnabled)
                    }
                }
            )
        }
    }

    /// Helper icon view
    @ViewBuilder
    private static func iconView(
        _ iconType: IconType,
        size: ButtonSizeType,
        style: ButtonStyleType,
        isEnabled: Bool
    ) -> some View {
        switch iconType {
        case .system(let name):
            Image(systemName: name)
                .font(size.fontSize)

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
        VStack(spacing: .spacing24) {  // ✅ Sử dụng spacing từ DimensionExtension
            Text("Default Corner Radius (.radius16)")
                .font(.headline)

            ButtonView(title: "Primary Button", style: .primary) {
                print("Primary")
            }

            ButtonView(title: "Secondary", style: .secondary) {
                print("Secondary")
            }

            Divider()

            Text("Custom Corner Radius")
                .font(.headline)

            ButtonView(
                title: "Small Radius (.radius8)",
                style: .primary,
                cornerRadius: .radius8  // ✅
            ) {
                print("Small radius")
            }

            ButtonView(
                title: "Large Radius (.radius24)",
                style: .outline,
                cornerRadius: .radius24  // ✅
            ) {
                print("Large radius")
            }

            ButtonView(
                title: "Extra Large (.radius32)",
                style: .secondary,
                cornerRadius: .radius32  // ✅
            ) {
                print("Extra large")
            }

            ButtonView(
                title: "Square (.radius0)",
                style: .danger,
                cornerRadius: .radius0  // ✅
            ) {
                print("Square")
            }

            Divider()

            Text("Corner Radius + Custom Shadow")
                .font(.headline)

            ButtonView(
                title: "Rounded + Shadow",
                style: .primary,
                shadowColor: .blue.opacity(.opacity3),  // ✅
                shadowRadius: 12,
                shadowOffset: 5,
                cornerRadius: .radius20  // ✅
            ) {
                print("Custom all")
            }

            Divider()

            Text("Fit Content + Corner Radius")
                .font(.headline)

            HStack(spacing: .spacing12) {  // ✅
                ButtonView(
                    title: "Small",
                    style: .primary,
                    fitContent: true,
                    cornerRadius: .radius8  // ✅
                ) {
                    print("Small")
                }

                ButtonView(
                    title: "Large",
                    style: .outline,
                    fitContent: true,
                    cornerRadius: .radius24  // ✅
                ) {
                    print("Large")
                }

                ButtonView(
                    title: "Round",
                    style: .secondary,
                    fitContent: true,
                    cornerRadius: .radius32  // ✅
                ) {
                    print("Round")
                }
            }

            Divider()

            Text("With Icons + Corner Radius")
                .font(.headline)

            ButtonView(
                title: "Add Item",
                icon: .system("plus"),
                style: .primary,
                cornerRadius: .radius12  // ✅
            ) {
                print("Add")
            }

            ButtonView(
                title: "Delete",
                icon: .system("trash"),
                iconPosition: .trailing,
                style: .danger,
                cornerRadius: .radius20  // ✅
            ) {
                print("Delete")
            }

            Divider()

            Text("Custom Content + Corner Radius")
                .font(.headline)

            ButtonView(
                style: .primary,
                cornerRadius: .radius20  // ✅
            ) {
                print("Custom 1")
            } content: {
                HStack(spacing: .spacing8) {  // ✅
                    Image(systemName: "star.fill")
                    VStack(alignment: .leading, spacing: .spacing2) {  // ✅
                        Text("Premium")
                            .font(.headline)
                        Text("Upgrade now")
                            .font(.caption)
                    }
                }
            }

            ButtonView(
                style: .outline,
                fitContent: true,
                cornerRadius: .radius32  // ✅
            ) {
                print("Custom 2")
            } content: {
                HStack(spacing: .spacing12) {  // ✅
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                    Text("Like")
                    Image(systemName: "arrow.up")
                }
            }

            Divider()

            Text("Outline Styles + Corner Radius")
                .font(.headline)

            ButtonView(
                title: "Outline",
                style: .outline,
                cornerRadius: .radius12  // ✅
            ) {
                print("Outline")
            }

            ButtonView(
                title: "Outline Dashed",
                style: .outlineDashed,
                cornerRadius: .radius20  // ✅
            ) {
                print("Outline Dashed")
            }

            Divider()

            Text("States")
                .font(.headline)

            ButtonView(
                title: "Loading",
                isLoading: true,
                cornerRadius: .radius20  // ✅
            ) {
                print("Loading")
            }

            ButtonView(
                title: "Disabled",
                isEnabled: false,
                cornerRadius: .radius20  // ✅
            ) {
                print("Disabled")
            }
        }
        .padding(.horizontal, .padding24)  // ✅ Sử dụng padding từ DimensionExtension
        .padding(.vertical, .spacing24)  // ✅
    }
}
