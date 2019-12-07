//
//  Page.swift
//  Pages
//
//  Created by Mostafa Saleh on 11/17/19.
//  Copyright © 2019 Mostafa Saleh. All rights reserved.
//

import Foundation

struct Page: Codable {
    var number: Int
    var ayahs: [Ayah]
   //var surahs: Int
    var edition: Edition
    
    init(from page: Page) {
        number = page.number
        ayahs = page.ayahs
        //surahs = page.surahs
        edition = page.edition
    }
    
    func filter(for surahNumber: Int) -> Page {
        var page = Page(from: self)
        page.ayahs = ayahs.filter { $0.surah.number == surahNumber }
        return page
    }
    
    func toHTML() -> String {
        var pageHtmlString = ""
        for ayah in ayahs {
            let surahNumberString = String(ayah.numberInSurah).arabicNumbers
            let ayahNumberUnicode = "\u{FD3F}\(surahNumberString)\u{FD3E}"
            let string = "<a href=\"\(ayah.numberInSurah)\">\(ayah.text)</a>&nbsp; \(ayahNumberUnicode)&nbsp;"
            pageHtmlString += string
        }
        let header =  "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
        pageHtmlString = pageHtmlString.dropLast(6).replacingOccurrences(of: header, with: "", range: pageHtmlString.range(of: header))
        return "\(pageHtmlString)\u{200F}"
    }
}

struct Ayah: Codable {
    var number: Int
    var text: String
    var surah: Surah
    var numberInSurah, juz, manzil, page: Int
    var ruku, hizbQuarter: Int
    //var sajda: Bool
}

struct Surah: Codable {
    var number: Int
    var name, englishName, englishNameTranslation, revelationType: String
    var numberOfAyahs: Int
}

struct Edition: Codable {
    var identifier, language, name, englishName: String
    var format, type: String
}
