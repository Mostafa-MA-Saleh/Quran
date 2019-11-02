//
//  MainSura.swift
//  Quran
//
//  Created by Admin on 10/9/19.
//

import Foundation
struct MainSura: Codable {
    var titleAr = ""
    var count = 0
    var index = ""
    var type = ""

    func getType() -> String {
        return type == "Makkiyah" ? "سورة مكية" : "سورة مدنية"
    }
}
