// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// All Crypto
  internal static let allCrypto = L10n.tr("Localizable", "allCrypto", fallback: "All Crypto")
  /// Localizable.strings
  ///   Crypto Info
  /// 
  ///   Created by Rahul Kumar on 18/09/23.
  internal static let marketOverview = L10n.tr("Localizable", "marketOverview", fallback: "Market Overview")
  /// 1 D
  internal static let oneD = L10n.tr("Localizable", "oneD", fallback: "1 D")
  /// 1 day
  internal static let oneDay = L10n.tr("Localizable", "oneDay", fallback: "1 day")
  /// 1 M
  internal static let oneM = L10n.tr("Localizable", "oneM", fallback: "1 M")
  /// 1 month
  internal static let oneMonth = L10n.tr("Localizable", "oneMonth", fallback: "1 month")
  /// 1 Y
  internal static let oneY = L10n.tr("Localizable", "oneY", fallback: "1 Y")
  /// 1 year
  internal static let oneYear = L10n.tr("Localizable", "oneYear", fallback: "1 year")
  /// Past %s%
  internal static func pastDuration(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "pastDuration", p1, fallback: "Past %s%")
  }
  /// 7 D
  internal static let sevenD = L10n.tr("Localizable", "sevenD", fallback: "7 D")
  /// 7 days
  internal static let sevenDays = L10n.tr("Localizable", "sevenDays", fallback: "7 days")
  /// Top Gainers
  internal static let topGainers = L10n.tr("Localizable", "topGainers", fallback: "Top Gainers")
  /// Top Losers
  internal static let topLosers = L10n.tr("Localizable", "topLosers", fallback: "Top Losers")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
