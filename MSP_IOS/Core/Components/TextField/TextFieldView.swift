//
//  TextFieldView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

struct TextFiedView: View {

    // MARK: - Properties
    @Binding private var text: String
    @State private var internalText: String = ""
    private var useInternalState: Bool

    private let placeholder: String
    private let iconName: String?
    private let iconNameRight: String?
    private let showClearButton: Bool
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let cornerRadius: CGFloat
    private let showOpacity: Double
    private let onTextChanged: ((String) -> Void)?
    private let onRightIconTapped: (() -> Void)?


    @FocusState private var isFocused: Bool

    // Initializer với Binding (để parent view control)
    init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        iconName: String? = nil,
        iconNameRight: String? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        cornerRadius: CGFloat = .radius16,
        showOpacity: Double = Dimension.Opacity.shadow,
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil
    ) {
        self._text = text
        self.useInternalState = false
        self.placeholder = placeholder
        self.iconName = iconName
        self.iconNameRight = iconNameRight
        self.showClearButton = showClearButton
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.cornerRadius = cornerRadius
        self.showOpacity = showOpacity
        self.onTextChanged = onTextChanged
        self.onRightIconTapped = onRightIconTapped
    }

    // Initializer không cần Binding (tự quản lý state cho Preview)
    init(
        placeholder: String = "Enter text...",
        iconName: String? = nil,
        iconNameRight: String? = nil,
        showClearButton: Bool = true,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        cornerRadius: CGFloat = .radius16,
        showOpacity: Double = Dimension.Opacity.shadow,
        onTextChanged: ((String) -> Void)? = nil,
        onRightIconTapped: (() -> Void)? = nil
    ) {
        self._text = .constant("")
        self.useInternalState = true
        self.placeholder = placeholder
        self.iconName = iconName
        self.iconNameRight = iconNameRight
        self.showClearButton = showClearButton
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.cornerRadius = cornerRadius
        self.showOpacity = showOpacity
        self.onTextChanged = onTextChanged
        self.onRightIconTapped = onRightIconTapped
    }

    // Computed property để lấy text phù hợp
    private var currentText: Binding<String> {
        useInternalState ? $internalText : $text
    }

    var body: some View {
       HStack {
           if iconName != nil {
               Image(systemName: iconName!)
                   .foregroundStyle(AppColors.textPrimary)
                   .font(.title3)
           }

           Group {
               if isSecure {
                   SecureField(placeholder, text: currentText)
               } else {
                   TextField(placeholder, text: currentText)
               }
           }
           .foregroundStyle(AppColors.textPrimary)
           .keyboardType(keyboardType)
           .focused($isFocused)
           .onChange(of: currentText.wrappedValue) { newValue in
               onTextChanged?(newValue)
           }

           // Clear button
           if showClearButton {
               Button(action: {
                   currentText.wrappedValue = ""
                   isFocused = false
               }) {
                   Image(systemName: "xmark.circle.fill")
                       .foregroundStyle(AppColors.textPrimary)
                       .font(.title3)
                       .frame(width: .iconSize24, height: .iconSize24)
               }
               .opacity(
                currentText.wrappedValue.isEmpty ? .opacityInvisible : .opacityDefault
               )
           }

           if let iconNameRight = iconNameRight {
               Button(action: {
                   onRightIconTapped?()
               }) {
                   Image(systemName: iconNameRight)
                       .foregroundStyle(AppColors.textPrimary)
                       .font(.title3)
                       .frame(width: .iconSize24, height: .iconSize24)
               }
           }
        }
       .padding(.horizontal, .padding16)
       .padding(.vertical, .padding16)
       .background(
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(AppColors.bgPrimary)
            .shadow(
                color: AppColors.shadowMedium,
                radius: cornerRadius,
                x: 0,
                y: 0
            )
       )
    }
}

// Preview không cần Binding - tự quản lý state
#Preview {
    TextFiedView(
        placeholder: "Email",
//        iconName: "envelope",
        keyboardType: .emailAddress
    )
    .padding(.horizontal)
}

#Preview {
    TextFiedView(
        placeholder: "Email",
        iconName: "envelope",
        keyboardType: .emailAddress
    )
    .padding(.horizontal)
    .preferredColorScheme(.dark)
}
