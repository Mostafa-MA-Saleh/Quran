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
            let surahNumberString = String(ayah.numberInSurah).arabicNumbers
            let ayahNumberUnicode = "\u{FD3F}\(surahNumberString)\u{FD3E}"
            let string = "<a href=\"\(ayah.numberInSurah)\">\(ayah.text)</a>&nbsp; \(ayahNumberUnicode)&nbsp;"
            surahHtmlString += string
        }
        let header =  "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
        surahHtmlString = surahHtmlString.dropLast(6).replacingOccurrences(of: header, with: "", range: surahHtmlString.range(of: header))
        return "\(surahHtmlString)\u{200F}"
    }
}
