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
        backgroundColor: Color = AppColors.grabGreen,
        foregroundColor: Color = .white,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 48,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color = AppColors.shadowMD,
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
        backgroundColor: Color = AppColors.grabGreen,
        foregroundColor: Color = .white,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 48,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color = AppColors.shadowMD,
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
        backgroundColor: Color = AppColors.grabGreen,
        foregroundColor: Color = .white,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        size: CGFloat = 48,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        withShadow: Bool = true,
        shadowColor: Color = AppColors.shadowMD,
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

#Preview("Basic Examples") {
    ScrollView {
        VStack(spacing: 24) {
            // Sizes
            Text("Sizes")
                .font(.headline)
            HStack(spacing: 16) {
                CircleButtonView(icon: .system("plus"), size: 32) { }
                CircleButtonView(icon: .system("heart.fill"), size: 48) { }
                CircleButtonView(icon: .system("star.fill"), size: 56) { }
            }

            Divider()

            // Colors
            Text("Colors")
                .font(.headline)
            HStack(spacing: 16) {
                CircleButtonView(icon: .system("cart.fill")) { }
                CircleButtonView(
                    icon: .system("heart.fill"),
                    backgroundColor: AppColors.grabCar
                ) { }
                CircleButtonView(
                    icon: .system("bolt.fill"),
                    backgroundColor: AppColors.grabPay
                ) { }
            }

            Divider()

            // States
            Text("States")
                .font(.headline)
            HStack(spacing: 16) {
                CircleButtonView(icon: .system("play.fill"), isEnabled: true) { }
                CircleButtonView(icon: .system("pause.fill"), isEnabled: false) { }
                CircleButtonView(icon: .system("arrow.clockwise"), isLoading: true) { }
            }

            Divider()

            // Borders
            Text("Borders")
                .font(.headline)
            HStack(spacing: 16) {
                CircleButtonView(
                    icon: .system("plus"),
                    backgroundColor: .white,
                    foregroundColor: AppColors.grabGreen,
                    borderColor: AppColors.grabGreen,
                    borderWidth: 2
                ) { }

                CircleButtonView(
                    icon: .system("xmark"),
                    backgroundColor: .clear,
                    foregroundColor: AppColors.grabBike,
                    borderColor: AppColors.borderDark,
                    borderWidth: 2,
                    withShadow: false
                ) { }
            }

            Divider()

            // Text content
            Text("Text Content")
                .font(.headline)
            HStack(spacing: 16) {
                CircleButtonView(text: "A", size: 48) { }
                CircleButtonView(
                    text: "5",
                    backgroundColor: AppColors.grabCar,
                    size: 48
                ) { }
            }

            Divider()

            // Custom content
            Text("Custom Content")
                .font(.headline)
            HStack(spacing: 16) {
                CircleButtonView(size: 56) { } content: {
                    VStack(spacing: 2) {
                        Image(systemName: "arrow.up").font(.caption)
                        Image(systemName: "arrow.down").font(.caption)
                    }
                }

                CircleButtonView(
                    backgroundColor: AppColors.grabCar,
                    size: 56
                ) { } content: {
                    ZStack {
                        Image(systemName: "bell.fill").font(.title3)
                        Text("3")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(Circle().fill(AppColors.error))
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview("Interactive Demo") {
    struct InteractiveDemo: View {
        @State private var isLiked = false
        @State private var count = 0

        var body: some View {
            VStack(spacing: 32) {
                // Like button
                VStack(spacing: 12) {
                    CircleButtonView(
                        icon: .system(isLiked ? "heart.fill" : "heart"),
                        backgroundColor: isLiked ? AppColors.grabFood : AppColors.grabGreen
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isLiked.toggle()
                        }
                    }
                    Text(isLiked ? "Liked!" : "Tap to like")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // Counter
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        CircleButtonView(
                            icon: .system("minus"),
                            backgroundColor: AppColors.grabCar,
                            isEnabled: count > 0
                        ) {
                            count = max(0, count - 1)
                        }

                        Text("\(count)")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 60)

                        CircleButtonView(
                            icon: .system("plus"),
                            backgroundColor: AppColors.grabGreen
                        ) {
                            count += 1
                        }
                    }
                    Text("Counter: \(count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }

    return InteractiveDemo()
}
