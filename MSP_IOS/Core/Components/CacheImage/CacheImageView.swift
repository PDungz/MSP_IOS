//
//  CacheImageView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 29/10/25.
//

import SwiftUI

// MARK: - Image Source Enum
enum ImageSource {
    case systemName(String)
    case url(String)
    case assetName(String)
    case image(Image)
}

// MARK: - Image Options
struct ImageOptions {
    var width: CGFloat?
    var height: CGFloat?
    var cornerRadius: CGFloat
    var contentMode: ContentMode
    var placeholderColor: Color
    var placeholderSystemName: String
    var errorSystemName: String
    var showLoadingIndicator: Bool
    var clipShape: ImageClipShape
    var borderWidth: CGFloat
    var borderColor: Color

    enum ImageClipShape {
        case rectangle
        case circle
        case roundedRectangle(CGFloat)
        case capsule
    }

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = Dimension.Raduis.r8,
        contentMode: ContentMode = .fill,
        placeholderColor: Color = .gray300,
        placeholderSystemName: String = "photo",
        errorSystemName: String = "photo.badge.exclamationmark",
        showLoadingIndicator: Bool = true,
        clipShape: ImageClipShape = .rectangle,
        borderWidth: CGFloat = 0,
        borderColor: Color = .clear
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
        self.placeholderColor = placeholderColor
        self.placeholderSystemName = placeholderSystemName
        self.errorSystemName = errorSystemName
        self.showLoadingIndicator = showLoadingIndicator
        self.clipShape = clipShape
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }
}

// MARK: - Cache Image View
struct CacheImageView: View {
    let source: ImageSource
    let options: ImageOptions

    init(
        source: ImageSource,
        options: ImageOptions = ImageOptions()
    ) {
        self.source = source
        self.options = options
    }

    var body: some View {
        Group {
            switch source {
            case .systemName(let name):
                systemImageView(name: name)

            case .url(let urlString):
                urlImageView(urlString: urlString)

            case .assetName(let name):
                assetImageView(name: name)

            case .image(let image):
                configuredImageView(image: image)
            }
        }
        .frame(width: options.width, height: options.height)
        .applyClipShape(options.clipShape, cornerRadius: options.cornerRadius)
        .applyBorder(width: options.borderWidth, color: options.borderColor, clipShape: options.clipShape, cornerRadius: options.cornerRadius)
    }

    // MARK: - System Image View
    @ViewBuilder
    private func systemImageView(name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: options.contentMode)
            .frame(width: options.width, height: options.height)
    }

    // MARK: - URL Image View with Caching
    @ViewBuilder
    private func urlImageView(urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                if options.showLoadingIndicator {
                    ZStack {
                        placeholderView()
                        ProgressView()
                            .tint(.grabGreen)
                    }
                } else {
                    placeholderView()
                }

            case .success(let image):
                configuredImageView(image: image)

            case .failure:
                errorView()

            @unknown default:
                placeholderView()
            }
        }
    }

    // MARK: - Asset Image View
    @ViewBuilder
    private func assetImageView(name: String) -> some View {
        if let uiImage = UIImage(named: name) {
            configuredImageView(image: Image(uiImage: uiImage))
        } else {
            errorView()
        }
    }

    // MARK: - Configured Image View
    @ViewBuilder
    private func configuredImageView(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: options.contentMode)
            .frame(width: options.width, height: options.height)
    }

    // MARK: - Placeholder View
    @ViewBuilder
    private func placeholderView() -> some View {
        ZStack {
            options.placeholderColor

            Image(systemName: options.placeholderSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(AppColors.gray500)
                .padding(Dimension.Padding.p16)
        }
        .frame(width: options.width, height: options.height)
    }

    // MARK: - Error View
    @ViewBuilder
    private func errorView() -> some View {
        ZStack {
            options.placeholderColor

            Image(systemName: options.errorSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(AppColors.error)
                .padding(Dimension.Padding.p16)
        }
        .frame(width: options.width, height: options.height)
    }
}

// MARK: - Convenience Initializers
extension CacheImageView {
    // System Icon
    init(
        systemName: String,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        contentMode: ContentMode = .fit,
        tintColor: Color = .textPrimary
    ) {
        self.source = .systemName(systemName)
        self.options = ImageOptions(
            width: width,
            height: height,
            contentMode: contentMode
        )
    }

    // URL Image
    init(
        url: String,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = Dimension.Raduis.r8,
        contentMode: ContentMode = .fill,
        placeholderColor: Color = .gray300,
        showLoadingIndicator: Bool = true
    ) {
        self.source = .url(url)
        self.options = ImageOptions(
            width: width,
            height: height,
            cornerRadius: cornerRadius,
            contentMode: contentMode,
            placeholderColor: placeholderColor,
            showLoadingIndicator: showLoadingIndicator
        )
    }

    // Asset Image
    init(
        assetName: String,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = Dimension.Raduis.r8,
        contentMode: ContentMode = .fill
    ) {
        self.source = .assetName(assetName)
        self.options = ImageOptions(
            width: width,
            height: height,
            cornerRadius: cornerRadius,
            contentMode: contentMode
        )
    }

    // Circle Avatar
    init(
        avatarUrl: String,
        size: CGFloat = 48,
        placeholderColor: Color = .grabGreenPastel
    ) {
        self.source = .url(avatarUrl)
        self.options = ImageOptions(
            width: size,
            height: size,
            contentMode: .fill,
            placeholderColor: placeholderColor,
            placeholderSystemName: "person.circle.fill",
            clipShape: .circle
        )
    }

    // Service Icon with Background
    init(
        serviceIcon: String,
        backgroundColor: Color,
        size: CGFloat = 56,
        cornerRadius: CGFloat = Dimension.Raduis.r12
    ) {
        self.source = .systemName(serviceIcon)
        self.options = ImageOptions(
            width: size,
            height: size,
            cornerRadius: cornerRadius,
            contentMode: .fit,
            placeholderColor: backgroundColor,
            clipShape: .roundedRectangle(cornerRadius)
        )
    }
}

// MARK: - View Extensions for Clip Shape
extension View {
    @ViewBuilder
    func applyClipShape(_ clipShape: ImageOptions.ImageClipShape, cornerRadius: CGFloat) -> some View {
        switch clipShape {
        case .rectangle:
            self.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .circle:
            self.clipShape(Circle())
        case .roundedRectangle(let radius):
            self.clipShape(RoundedRectangle(cornerRadius: radius))
        case .capsule:
            self.clipShape(Capsule())
        }
    }

    @ViewBuilder
    func applyBorder(width: CGFloat, color: Color, clipShape: ImageOptions.ImageClipShape, cornerRadius: CGFloat) -> some View {
        if width > 0 {
            switch clipShape {
            case .rectangle:
                self.overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color, lineWidth: width)
                )
            case .circle:
                self.overlay(
                    Circle()
                        .stroke(color, lineWidth: width)
                )
            case .roundedRectangle(let radius):
                self.overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(color, lineWidth: width)
                )
            case .capsule:
                self.overlay(
                    Capsule()
                        .stroke(color, lineWidth: width)
                )
            }
        } else {
            self
        }
    }
}

// MARK: - Preview
#Preview("URL Image") {
    VStack(spacing: Dimension.Spacing.s16) {
        // URL Image - Rectangle
        CacheImageView(
            url: "https://picsum.photos/400/300",
            width: 200,
            height: 150,
            cornerRadius: Dimension.Raduis.r12
        )

        // Circle Avatar
        CacheImageView(
            avatarUrl: "https://picsum.photos/200",
            size: 64
        )

        // Asset Image
        CacheImageView(
            assetName: "sample_image",
            width: 150,
            height: 150,
            cornerRadius: Dimension.Raduis.r8
        )
    }
    .padding()
}

#Preview("System Icons") {
    VStack(spacing: Dimension.Spacing.s16) {
        // System Icon in Square
        CacheImageView(
            serviceIcon: "car.fill",
            backgroundColor: .grabCarBg,
            size: 56
        )

        // System Icon in Circle
        CacheImageView(
            source: .systemName("bicycle"),
            options: ImageOptions(
                width: 56,
                height: 56,
                contentMode: .fit,
                placeholderColor: .grabBikeBg,
                clipShape: .circle
            )
        )

        // Simple System Icon
        CacheImageView(
            systemName: "star.fill",
            width: 32,
            height: 32
        )
    }
    .padding()
}

#Preview("Custom Options") {
    VStack(spacing: Dimension.Spacing.s16) {
        // Custom border
        CacheImageView(
            url: "https://picsum.photos/300",
            width: 120,
            height: 120,
            cornerRadius: Dimension.Raduis.r16
        )

        // Capsule shape
        CacheImageView(
            source: .url("https://picsum.photos/400/200"),
            options: ImageOptions(
                width: 200,
                height: 100,
                contentMode: .fill,
                clipShape: .capsule,
                borderWidth: Dimension.BorderWidth.bw2,
                borderColor: .grabGreen
            )
        )

        // Custom placeholder
        CacheImageView(
            source: .url("invalid-url"),
            options: ImageOptions(
                width: 150,
                height: 150,
                cornerRadius: Dimension.Raduis.r12,
                placeholderColor: .grabFoodBg,
                errorSystemName: "exclamationmark.triangle.fill"
            )
        )
    }
    .padding()
}
