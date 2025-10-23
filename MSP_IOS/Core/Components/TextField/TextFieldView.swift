//
//  TextFieldView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

struct TextFieldView: View {

    // MARK: - Properties
    @Binding private var text: String
    @State private var internalText: String = ""
    private var useInternalState: Bool

    private let placeholder: String
    private let animatedPlaceholders: [String]  // Thêm mảng placeholders
    private let iconName: String?
    private let iconNameRight: String?
    private let showClearButton: Bool
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType

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

    private let onTextChanged: ((String) -> Void)?
    private let onRightIconTapped: (() -> Void)?

    @FocusState private var isFocused: Bool

    // Initializer với Binding (để parent view control)
    init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        animatedPlaceholders: [String]? = nil,  // Optional animated placeholders
        iconName: String? = nil,
        iconNameRight: String? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textFont: Font = .body,
        iconFont: Font = .title3,
        iconSize: CGFloat = 24,
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        shadowColor: Color = AppColors.shadowMedium,
        shadowRadius: CGFloat = 16,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 0,
        spacing: CGFloat = 12,
        isAnimatedPlaceholder: Bool = false,
        animationSpeed: Double = 0.1,
        animationPauseDuration: Double = 1.5,
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil
    ) {
        self._text = text
        self.useInternalState = false
        self.placeholder = placeholder
        self.animatedPlaceholders = animatedPlaceholders ?? [placeholder]
        self.iconName = iconName
        self.iconNameRight = iconNameRight
        self.showClearButton = showClearButton
        self.isSecure = isSecure
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
        self.onTextChanged = onTextChanged
        self.onRightIconTapped = onRightIconTapped
    }

    // Initializer không cần Binding (tự quản lý state cho Preview)
    init(
        placeholder: String = "Enter text...",
        animatedPlaceholders: [String]? = nil,
        iconName: String? = nil,
        iconNameRight: String? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textFont: Font = .body,
        iconFont: Font = .title3,
        iconSize: CGFloat = 24,
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16,
        shadowColor: Color = AppColors.shadowMedium,
        shadowRadius: CGFloat = 16,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 0,
        spacing: CGFloat = 12,
        isAnimatedPlaceholder: Bool = false,
        animationSpeed: Double = 0.1,
        animationPauseDuration: Double = 1.5,
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil
    ) {
        self._text = .constant("")
        self.useInternalState = true
        self.placeholder = placeholder
        self.animatedPlaceholders = animatedPlaceholders ?? [placeholder]
        self.iconName = iconName
        self.iconNameRight = iconNameRight
        self.showClearButton = showClearButton
        self.isSecure = isSecure
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
        self.onTextChanged = onTextChanged
        self.onRightIconTapped = onRightIconTapped
    }

    // Computed property để lấy text phù hợp
    private var currentText: Binding<String> {
        useInternalState ? $internalText : $text
    }

    var body: some View {
       HStack(spacing: spacing) {
           // Left Icon
           if let iconName = iconName {
               Image(systemName: iconName)
                   .foregroundStyle(AppColors.textPrimary)
                   .font(iconFont)
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
                   .foregroundStyle(AppColors.textSecondary.opacity(0.6))
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
               .foregroundStyle(AppColors.textPrimary)
               .font(textFont)
               .keyboardType(keyboardType)
               .focused($isFocused)
               .onChange(of: currentText.wrappedValue) { newValue in
                   onTextChanged?(newValue)
               }
           }

           // Right Icon (ưu tiên hơn Clear button)
           if let iconNameRight = iconNameRight {
               Button(action: {
                   onRightIconTapped?()
               }) {
                   Image(systemName: iconNameRight)
                       .foregroundStyle(AppColors.textPrimary)
                       .font(iconFont)
                       .frame(width: iconSize, height: iconSize)
                       .contentShape(Rectangle())
               }
               .buttonStyle(.plain)
           } else if showClearButton {
               // Clear button (chỉ hiển thị khi không có right icon)
               Button(action: {
                   currentText.wrappedValue = ""
                   isFocused = false
               }) {
                   Image(systemName: "xmark.circle.fill")
                       .foregroundStyle(AppColors.textSecondary)
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
            .fill(AppColors.bgPrimary)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
       )
    }
}

// MARK: - Previews

// Preview 1: Normal Placeholder
#Preview("Normal Placeholder") {
    VStack(spacing: 20) {
        TextFieldView(
            placeholder: "Email",
            iconName: "envelope",
            keyboardType: .emailAddress
        )

        TextFieldView(
            placeholder: "Password",
            iconName: "lock",
            isSecure: true
        )
    }
    .padding(.horizontal)
}

// Preview 2: Animated Placeholder
#Preview("Animated Placeholder") {
    VStack(spacing: 20) {
        TextFieldView(
            placeholder: "Email",
            animatedPlaceholders: ["Enter your email", "example@mail.com", "Your email address"],
            iconName: "envelope",
            keyboardType: .emailAddress,
            isAnimatedPlaceholder: true,
            animationSpeed: 0.08,
            animationPauseDuration: 1.5
        )

        TextFieldView(
            placeholder: "Username",
            animatedPlaceholders: ["Your username", "Choose a name", "Enter username"],
            iconName: "person",
            isAnimatedPlaceholder: true
        )

        TextFieldView(
            placeholder: "Search",
            animatedPlaceholders: ["Search anything", "Find what you need", "Start searching"],
            iconName: "magnifyingglass",
            isAnimatedPlaceholder: true,
            animationSpeed: 0.1,
            animationPauseDuration: 2.0
        )
    }
    .padding(.horizontal)
}
