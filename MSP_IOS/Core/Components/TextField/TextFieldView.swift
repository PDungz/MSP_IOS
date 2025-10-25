//
//  TextFieldView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

// MARK: - TextField Right Icon Type
enum TextFieldRightIconType {
    case icon(IconType)
    case customView(AnyView)

    static func custom<V: View>(_ view: V) -> TextFieldRightIconType {
        .customView(AnyView(view))
    }
}

// MARK: - TextFieldView
struct TextFieldView: View {

    // MARK: - Properties
    @Binding private var text: String
    @State private var internalText: String = ""
    private var useInternalState: Bool

    private let placeholder: String
    private let animatedPlaceholders: [String]
    private let leftIcon: IconType?
    private let rightIcon: TextFieldRightIconType?
    private let showClearButton: Bool
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let isInteractive: Bool

    // Customizable UI properties
    private let textFont: Font
    private let iconFont: Font
    private let iconSize: CGFloat
    private let cornerRadius: CGFloat
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let shadowColor: Color
    private let shadowRadius: CGFloat
    private let shadowX: CGFloat
    private let shadowY: CGFloat
    private let spacing: CGFloat
    private let isAnimatedPlaceholder: Bool
    private let animationSpeed: Double
    private let animationPauseDuration: Double
    private let textColor: Color
    private let placeholderColor: Color
    private let iconColor: Color
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat

    private let onTextChanged: ((String) -> Void)?
    private let onRightIconTapped: (() -> Void)?
    private let onTap: (() -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Initializer với Binding (để parent view control)
    init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        animatedPlaceholders: [String]? = nil,
        leftIcon: IconType? = nil,
        rightIcon: TextFieldRightIconType? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        isInteractive: Bool = true,
        keyboardType: UIKeyboardType = .default,
        // Font & Size
        textFont: Font = .body,
        iconFont: Font = .title3,
        iconSize: CGFloat = 24,
        // Layout
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        spacing: CGFloat = 12,
        // Animation
        isAnimatedPlaceholder: Bool = false,
        animationSpeed: Double = 0.1,
        animationPauseDuration: Double = 1.5,
        // Colors
        textColor: Color = AppColors.textPrimary,
        placeholderColor: Color = AppColors.textSecondary,
        iconColor: Color = AppColors.textPrimary,
        backgroundColor: Color = AppColors.bgPrimary,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        // Shadow
        shadowColor: Color = AppColors.shadowMD,
        shadowRadius: CGFloat = 16,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 0,
        // Callbacks
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.useInternalState = false
        self.placeholder = placeholder
        self.animatedPlaceholders = animatedPlaceholders ?? [placeholder]
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.showClearButton = showClearButton
        self.isSecure = isSecure
        self.isInteractive = isInteractive
        self.keyboardType = keyboardType
        self.textFont = textFont
        self.iconFont = iconFont
        self.iconSize = iconSize
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.spacing = spacing
        self.isAnimatedPlaceholder = isAnimatedPlaceholder
        self.animationSpeed = animationSpeed
        self.animationPauseDuration = animationPauseDuration
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.onTextChanged = onTextChanged
        self.onRightIconTapped = onRightIconTapped
        self.onTap = onTap
    }

    // MARK: - Initializer không cần Binding (tự quản lý state cho Preview)
    init(
        placeholder: String = "Enter text...",
        animatedPlaceholders: [String]? = nil,
        leftIcon: IconType? = nil,
        rightIcon: TextFieldRightIconType? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        isInteractive: Bool = true,
        keyboardType: UIKeyboardType = .default,
        // Font & Size
        textFont: Font = .body,
        iconFont: Font = .title3,
        iconSize: CGFloat = 24,
        // Layout
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        spacing: CGFloat = 12,
        // Animation
        isAnimatedPlaceholder: Bool = false,
        animationSpeed: Double = 0.1,
        animationPauseDuration: Double = 1.5,
        // Colors
        textColor: Color = AppColors.textPrimary,
        placeholderColor: Color = AppColors.textSecondary,
        iconColor: Color = AppColors.textPrimary,
        backgroundColor: Color = AppColors.bgPrimary,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        // Shadow
        shadowColor: Color = AppColors.shadowMD,
        shadowRadius: CGFloat = 16,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 0,
        // Callbacks
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self._text = .constant("")
        self.useInternalState = true
        self.placeholder = placeholder
        self.animatedPlaceholders = animatedPlaceholders ?? [placeholder]
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.showClearButton = showClearButton
        self.isSecure = isSecure
        self.isInteractive = isInteractive
        self.keyboardType = keyboardType
        self.textFont = textFont
        self.iconFont = iconFont
        self.iconSize = iconSize
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.spacing = spacing
        self.isAnimatedPlaceholder = isAnimatedPlaceholder
        self.animationSpeed = animationSpeed
        self.animationPauseDuration = animationPauseDuration
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.onTextChanged = onTextChanged
        self.onRightIconTapped = onRightIconTapped
        self.onTap = onTap
    }

    // MARK: - Computed property để lấy text phù hợp
    private var currentText: Binding<String> {
        useInternalState ? $internalText : $text
    }

    // MARK: - Body
    var body: some View {
       HStack(spacing: spacing) {
           // Left Icon
           if let leftIcon = leftIcon {
               iconView(leftIcon, color: iconColor)
                   .frame(width: iconSize, height: iconSize)
           }

           // TextField/SecureField với ZStack
           ZStack(alignment: .leading) {
               // Animated Placeholder (chỉ hiển thị khi không có text và không focus)
               if isAnimatedPlaceholder && currentText.wrappedValue.isEmpty && !isFocused {
                   TypewriterText(
                       texts: animatedPlaceholders,
                       speed: animationSpeed,
                       pauseDuration: animationPauseDuration,
                       alignment: .leading
                   )
                   .font(textFont)
                   .foregroundStyle(placeholderColor.opacity(0.6))
                   .allowsHitTesting(false)
               }

               // TextField hoặc SecureField
               Group {
                   if isSecure {
                       SecureField(isAnimatedPlaceholder ? "" : placeholder, text: currentText)
                   } else {
                       TextField(isAnimatedPlaceholder ? "" : placeholder, text: currentText)
                   }
               }
               .foregroundStyle(textColor)
               .font(textFont)
               .keyboardType(keyboardType)
               .focused($isFocused)
               .disabled(!isInteractive) // Disable input khi isInteractive = false
               .onChange(of: currentText.wrappedValue) { newValue in
                   onTextChanged?(newValue)
               }
           }

           // Right Icon hoặc Custom View (ưu tiên hơn Clear button)
           if let rightIcon = rightIcon {
               rightIconContent(rightIcon)
           } else if showClearButton {
               // Clear button (chỉ hiển thị khi không có right icon)
               Button(action: {
                   currentText.wrappedValue = ""
                   isFocused = false
               }) {
                   Image(systemName: "xmark.circle.fill")
                       .foregroundStyle(AppColors.textTertiary)
                       .font(iconFont)
                       .frame(width: iconSize, height: iconSize)
                       .contentShape(Rectangle())
               }
               .buttonStyle(.plain)
               .opacity(currentText.wrappedValue.isEmpty ? 0.0 : 1.0)
           }
        }
       .padding(.horizontal, horizontalPadding)
       .padding(.vertical, verticalPadding)
       .background(
           RoundedRectangle(cornerRadius: cornerRadius)
               .fill(backgroundColor)
               .overlay(
                   RoundedRectangle(cornerRadius: cornerRadius)
                       .stroke(isFocused ? AppColors.borderFocus : borderColor, lineWidth: borderWidth > 0 ? borderWidth : (isFocused ? 2 : 0))
               )
               .shadow(
                   color: shadowColor,
                   radius: shadowRadius,
                   x: shadowX,
                   y: shadowY
               )
       )
       .onTapGesture {
           if let onTap = onTap {
               onTap()
           } else if isInteractive {
               // Default behavior: focus on TextField (chỉ khi interactive)
               isFocused = true
           }
       }
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func iconView(_ icon: IconType, color: Color) -> some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
                .foregroundStyle(color)
                .font(iconFont)

        case .asset(let name):
            Image(name)
                .renderingMode(.template) // ✅ Cho phép tô màu asset image
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)

        case .url(let urlString):
            AsyncImage(url: URL(string: urlString)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .renderingMode(.template) // ✅ Cho phép tô màu URL image
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(color)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                @unknown default:
                    EmptyView()
                }
            }

        case .custom(let image):
            image
                .renderingMode(.template) // ✅ Cho phép tô màu custom image
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)
        }
    }

    @ViewBuilder
    private func rightIconContent(_ type: TextFieldRightIconType) -> some View {
        switch type {
        case .icon(let iconType):
            Button(action: {
                onRightIconTapped?()
            }) {
                iconView(iconType, color: iconColor)
                    .frame(width: iconSize, height: iconSize)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

        case .customView(let view):
            Button(action: {
                onRightIconTapped?()
            }) {
                view
                    // Không giới hạn size cho custom view, để view tự quản lý
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Backward Compatibility Extensions
extension TextFieldView {
    /// Legacy initializer với String icon name (deprecated - use IconType instead)
    @available(*, deprecated, message: "Use IconType for leftIcon and TextFieldRightIconType for rightIcon instead")
    init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        animatedPlaceholders: [String]? = nil,
        iconName: String? = nil,
        iconNameRight: String? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        isInteractive: Bool = true,
        keyboardType: UIKeyboardType = .default,
        // Font & Size
        textFont: Font = .body,
        iconFont: Font = .title3,
        iconSize: CGFloat = 24,
        // Layout
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        spacing: CGFloat = 12,
        // Animation
        isAnimatedPlaceholder: Bool = false,
        animationSpeed: Double = 0.1,
        animationPauseDuration: Double = 1.5,
        // Shadow
        shadowColor: Color = AppColors.shadowMD,
        shadowRadius: CGFloat = 16,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 0,
        // Callbacks
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.init(
            text: text,
            placeholder: placeholder,
            animatedPlaceholders: animatedPlaceholders,
            leftIcon: iconName.map { .system($0) },
            rightIcon: iconNameRight.map { .icon(.system($0)) },
            showClearButton: showClearButton,
            isSecure: isSecure,
            isInteractive: isInteractive,
            keyboardType: keyboardType,
            textFont: textFont,
            iconFont: iconFont,
            iconSize: iconSize,
            cornerRadius: cornerRadius,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            spacing: spacing, isAnimatedPlaceholder: isAnimatedPlaceholder,
            animationSpeed: animationSpeed,
            animationPauseDuration: animationPauseDuration, shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowX: shadowX,
            shadowY: shadowY,
            onTextChanged: onTextChanged,
            onRightIconTapped: onRightIconTapped,
            onTap: onTap
        )
    }
}

// MARK: - Previews

#Preview("Basic TextField") {
    VStack(spacing: 20) {
        // Basic with IconType
        TextFieldView(
            placeholder: "Email",
            leftIcon: .system("envelope"),
            keyboardType: .emailAddress
        )

        // Password with right icon
        TextFieldView(
            placeholder: "Password",
            leftIcon: .system("lock"),
            rightIcon: .icon(.system("eye")),
            isSecure: true,
            onRightIconTapped:  {
                print("Toggle password visibility")
            })

        // With border
        TextFieldView(
            placeholder: "Username",
            leftIcon: .system("person"),
            borderColor: AppColors.borderDefault,
            borderWidth: 1
        )

        // Custom colors
        TextFieldView(
            placeholder: "Search",
            leftIcon: .system("magnifyingglass"),
            backgroundColor: AppColors.grabGreenPastel,
            borderColor: AppColors.grabGreen,
            borderWidth: 1
        )
    }
    .padding(.horizontal)
}

#Preview("Animated Placeholder") {
    VStack(spacing: 20) {
        TextFieldView(
            placeholder: "Email",
            animatedPlaceholders: ["Enter your email", "example@mail.com", "Your email address"],
            leftIcon: .system("envelope"),
            keyboardType: .emailAddress,
            isAnimatedPlaceholder: true,
            animationSpeed: 0.08,
            animationPauseDuration: 1.5
        )

        TextFieldView(
            placeholder: "Search",
            animatedPlaceholders: ["Search anything", "Find what you need", "Start searching"],
            leftIcon: .system("magnifyingglass"),
            isAnimatedPlaceholder: true,
            animationSpeed: 0.1,
            animationPauseDuration: 2.0
        )
    }
    .padding(.horizontal)
}

#Preview("Custom Right View") {
    VStack(spacing: 20) {
        // Custom view as right icon
        TextFieldView(
            placeholder: "Promo Code",
            leftIcon: .system("ticket"),
            rightIcon: .custom(
                Text("Apply")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.grabGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.grabGreenPastel)
                    .cornerRadius(8)
            ),
            showClearButton: false, onRightIconTapped:  {
                print("Apply promo code")
            })

        // Custom icon with different color
        TextFieldView(
            placeholder: "Amount",
            leftIcon: .system("dollarsign.circle"),
            rightIcon: .icon(.system("checkmark.circle.fill")),
            iconColor: AppColors.success, onRightIconTapped:  {
                print("Validate amount")
            })

        // With asset icon
        TextFieldView(
            placeholder: "Card Number",
            leftIcon: .system("creditcard"),
            rightIcon: .custom(
                Image(systemName: "camera.fill")
                    .foregroundColor(AppColors.grabGreen)
            ), onRightIconTapped:  {
                print("Scan card")
            })
    }
    .padding(.horizontal)
}

#Preview("Different States") {
    ScrollView {
        VStack(spacing: 20) {
            // Normal
            TextFieldView(
                placeholder: "Normal",
                leftIcon: .system("envelope")
            )

            // With border
            TextFieldView(
                placeholder: "With Border",
                leftIcon: .system("lock"),
                borderColor: AppColors.borderDefault,
                borderWidth: 1
            )

            // Error state
            TextFieldView(
                placeholder: "Error State",
                leftIcon: .system("exclamationmark.triangle"),
                iconColor: AppColors.error,
                borderColor: AppColors.error,
                borderWidth: 2
            )

            // Success state
            TextFieldView(
                placeholder: "Success State",
                leftIcon: .system("checkmark.circle"),
                rightIcon: .icon(.system("checkmark.circle.fill")),
                iconColor: AppColors.success,
                borderColor: AppColors.success,
                borderWidth: 2
            )

            // Disabled appearance
            TextFieldView(
                placeholder: "Disabled",
                leftIcon: .system("lock.fill"),
                textColor: AppColors.textDisabled,
                iconColor: AppColors.textDisabled,
                backgroundColor: AppColors.bgTertiary
            )
        }
        .padding(.horizontal)
    }
}
