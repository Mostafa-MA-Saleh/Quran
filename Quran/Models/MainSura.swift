//
//  MainSura.swift
//  Quran
//
//  Created by Admin on 10/9/19.
//

import Foundation
class MainSura: NSObject, Codable, NSCoding {
    var titleAr = ""
    var count = 0
    var index = ""
    var type = ""

    required init?(coder: NSCoder) {
        titleAr = coder.decodeObject(forKey: "titleAr") as! String
        count = coder.decodeInteger(forKey: "count")
        index = coder.decodeObject(forKey: "index") as! String
        type = coder.decodeObject(forKey: "type") as! String
    }

    func encode(with coder: NSCoder) {
        coder.encode(titleAr, forKey: "titleAr")
        coder.encode(count, forKey: "count")
        coder.encode(index, forKey: "index")
        coder.encode(type, forKey: "type")
    }

    func getType() -> String {
        return type == "Makkiyah" ? "سورة مكية" : "سورة مدنية"
    }
}
