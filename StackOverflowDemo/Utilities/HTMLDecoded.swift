//
//  HTMLDecoded.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 18/04/26.
//

import UIKit

@propertyWrapper
struct HTMLDecoded: Codable {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = Self.decode(wrappedValue)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        wrappedValue = Self.decode(raw)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }

    private static func decode(_ text: String) -> String {
        guard let data = text.data(using: .utf8) else {
            return ""
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return ""
        }

        return attributedString.string
    }
}
