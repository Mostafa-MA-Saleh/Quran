//
//  Surah.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import Foundation

struct Surah: Codable {
    let number: Int
    let name, englishName, englishNameTranslation, revelationType: String
    let numberOfAyahs: Int
    var ayahs: [Ayah]

    func toHTML() -> String {
        var surahHtmlString = ""
        for ayah in ayahs {
            let ayahNumberArabic = String(format: "%04X", ayah.numberInSurah + 1632)
            let charCode = UInt32(ayahNumberArabic, radix: 16)!
            let ayahNumberUnicode = "\u{FD3F}\(UnicodeScalar(charCode)!)\u{FD3E}"
            surahHtmlString += "<a href=\"\(ayah.numberInSurah)\">\(ayah.text)</a>&nbsp; \(ayahNumberUnicode)&nbsp;"
        }
        return "\(surahHtmlString.dropLast(6))\u{200F}"
    }
}
