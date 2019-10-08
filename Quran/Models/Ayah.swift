//
//  Ayah.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import Foundation

struct Ayah: Codable {
    let number: Int
    let text: String
    let numberInSurah, juz, manzil, page: Int
    let ruku, hizbQuarter: Int
    let sajda: Bool
}
