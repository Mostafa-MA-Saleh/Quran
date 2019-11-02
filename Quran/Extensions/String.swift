//
//  String.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    var arabicNumbers: String {
        map { char -> String in
            let ayahNumberArabic = String(format: "%04X", Int("\(char)")! + 1632)
            let charCode = UInt32(ayahNumberArabic, radix: 16)!
            return "\(UnicodeScalar(charCode)!)"
        }.joined()
    }
}

extension String.Index {
    func add(_ int: Int, in string: String) -> String.Index {
        return string.index(self, offsetBy: int)
    }
}
