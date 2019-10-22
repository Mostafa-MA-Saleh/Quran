//
//  Tafseer.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/22/19.
//

import Foundation

struct Tafseer: Codable {
    let tafseerID: Int
    let tafseerName, ayahURL: String
    let ayahNumber: Int
    let text: String

    enum CodingKeys: String, CodingKey {
        case tafseerID = "tafseer_id"
        case tafseerName = "tafseer_name"
        case ayahURL = "ayah_url"
        case ayahNumber = "ayah_number"
        case text
    }
}
