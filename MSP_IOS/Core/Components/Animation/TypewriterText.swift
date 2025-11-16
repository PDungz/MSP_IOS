//
//  TypewriterText.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import SwiftUI

struct TypewriterText: View {
    let texts: [String]
    let speed: Double
    let pauseDuration: Double
    let alignment: Alignment

    @State private var displayedText = ""
    @State private var currentTextIndex = 0
    @State private var charIndex = 0
    @State private var typewriterTimer: Timer?

    init(
        texts: [String],
        speed: Double = 0.1,
        pauseDuration: Double = 1.5,
        alignment: Alignment = .leading
    ) {
        self.texts = texts
        self.speed = speed
        self.pauseDuration = pauseDuration
        self.alignment = alignment
    }

    var body: some View {
        Text(displayedText.isEmpty ? " " : displayedText)
            .opacity(0.6)
            .frame(maxWidth: .infinity, alignment: alignment)
            .scaleEffect(1.0, anchor: alignmentAnchor)
            .onAppear {
                startAnimation()
            }
            .onDisappear {
                typewriterTimer?.invalidate()
            }
    }

    private var alignmentAnchor: UnitPoint {
        switch alignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            return .leading
        }
    }

    private func startAnimation() {
        typeCurrentText()
    }

    private func typeCurrentText() {
        guard currentTextIndex < texts.count else {
            // Hết mảng, quay lại đầu
            DispatchQueue.main.async {
                self.currentTextIndex = 0
                self.displayedText = ""
                self.charIndex = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.typeCurrentText()
            }
            return
        }

        let currentText = texts[currentTextIndex]

        // Reset displayed text và charIndex
        DispatchQueue.main.async {
            self.displayedText = ""
            self.charIndex = 0
        }

        // Sử dụng Timer trên main RunLoop
        typewriterTimer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            // Đảm bảo tất cả state updates đều trên main thread
            DispatchQueue.main.async {
                if self.charIndex < currentText.count {
                    let index = currentText.index(currentText.startIndex, offsetBy: self.charIndex)
                    self.displayedText.append(currentText[index])
                    self.charIndex += 1
                } else {
                    timer.invalidate()

                    // Viết xong, đợi rồi chuyển sang text tiếp theo
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.pauseDuration) {
                        self.currentTextIndex += 1
                        self.typeCurrentText()
                    }
                }
            }
        }

        // Đảm bảo Timer chạy trên main RunLoop
        if let timer = typewriterTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        // Leading
        VStack(alignment: .leading, spacing: 8) {
            Text("Type → Disappear → Type Next - Leading:")
                .font(.caption)
                .foregroundStyle(.secondary)

            TypewriterText(
                texts: ["Email Address", "Phone Number", "Username"],
                speed: 0.1,
                pauseDuration: 1.5,
                alignment: .leading
            )
            .font(.title3)
            .padding()
            .frame(height: 40)
            .background(Color.blue.opacity(0.1))
        }

        Divider()

        // Center
        VStack(spacing: 8) {
            Text("Type → Disappear → Type Next - Center:")
                .font(.caption)
                .foregroundStyle(.secondary)

            TypewriterText(
                texts: ["Welcome!", "Sign In", "Get Started"],
                speed: 0.08,
                pauseDuration: 1.2,
                alignment: .center
            )
            .font(.body)
            .padding()
            .frame(height: 40)
            .background(Color.green.opacity(0.1))
        }

        Divider()

        // Trailing
        VStack(alignment: .trailing, spacing: 8) {
            Text("Type → Disappear → Type Next - Trailing:")
                .font(.caption)
                .foregroundStyle(.secondary)

            TypewriterText(
                texts: ["Hello", "World", "Swift"],
                speed: 0.08,
                pauseDuration: 1.0,
                alignment: .trailing
            )
            .font(.headline)
            .padding()
            .frame(height: 40)
            .background(Color.orange.opacity(0.1))
        }

        Divider()

        // Fast
        VStack(spacing: 8) {
            Text("Fast Speed:")
                .font(.caption)
                .foregroundStyle(.secondary)

            TypewriterText(
                texts: ["Quick", "Fast", "Rapid"],
                speed: 0.05,
                pauseDuration: 0.8,
                alignment: .leading
            )
            .font(.body)
            .padding()
            .frame(height: 40)
            .background(Color.purple.opacity(0.1))
        }
    }
    .padding()
}
