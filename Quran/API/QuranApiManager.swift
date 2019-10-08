//
//  QuranAPIManager.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import Alamofire
import CodableAlamofire
import Foundation

class QuranApiManager {
    static let shared = QuranApiManager()

    private let BASE_URL = "https://api.alquran.cloud/v1/surah/"

    private init() {}

    func fetch(surahNumber: Int, completion: @escaping (Result<Surah>) -> Void) {
        Alamofire.request("\(BASE_URL)\(surahNumber)").responseDecodableObject(keyPath: "data") { (response: DataResponse<Surah>) in
            switch response.result {
            case let .success(surah): completion(.success(surah))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
