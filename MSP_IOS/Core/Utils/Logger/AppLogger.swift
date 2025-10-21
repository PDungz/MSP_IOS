//
//  AppLogger.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import Foundation

/// Logger with colored output for different log levels
class AppLogger {

    // MARK: - ANSI Colors
    private enum Color: String {
        case red = "\u{001B}[31m"      // Error
        case yellow = "\u{001B}[33m"   // Warning
        case green = "\u{001B}[32m"    // Success
        case cyan = "\u{001B}[36m"     // Info
        case reset = "\u{001B}[0m"

        var border: String {
            return "─" // Horizontal line character
        }
    }

    // MARK: - Configuration
    static var isEnabled: Bool = true

    #if DEBUG
    static var minLevel: LogLevel = .info
    #else
    static var minLevel: LogLevel = .error
    #endif

    enum LogLevel: Int {
        case info = 0
        case success = 1
        case warning = 2
        case error = 3

        var shouldLog: Bool {
            return self.rawValue >= AppLogger.minLevel.rawValue
        }
    }

    // MARK: - Private Helper
    private static func log(_ text: String, color: Color, prefix: String) {
        guard isEnabled else { return }

        let lines = text.split(separator: "\n")
        let coloredLines = lines.map { "\(color.rawValue)│ \($0)" }.joined(separator: "\n")

        let separator = String(repeating: "═", count: 80)
        let fullText = """
        \(color.rawValue)┌\(separator)
        \(color.rawValue)│ [\(prefix)]
        \(coloredLines)
        \(color.rawValue)└\(separator)\(Color.reset.rawValue)
        """

        print(fullText)
    }

    // MARK: - Public Methods

    /// Log error message (red)
    static func e(_ message: String) {
        guard LogLevel.error.shouldLog else { return }
        log(message, color: .red, prefix: "ERROR")
    }

    /// Log warning message (yellow)
    static func w(_ message: String) {
        guard LogLevel.warning.shouldLog else { return }
        log(message, color: .yellow, prefix: "WARNING")
    }

    /// Log success message (green)
    static func s(_ message: String) {
        guard LogLevel.success.shouldLog else { return }
        log(message, color: .green, prefix: "SUCCESS")
    }

    /// Log info message (cyan)
    static func i(_ message: String) {
        guard LogLevel.info.shouldLog else { return }
        log(message, color: .cyan, prefix: "INFO")
    }
}
