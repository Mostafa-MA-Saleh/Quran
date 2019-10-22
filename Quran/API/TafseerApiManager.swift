//
//  TafseerApiManager.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/22/19.
//

import Alamofire
import CodableAlamofire
import Foundation

class TafseerApiManager {
    static let shared = TafseerApiManager()

    private let BASE_URL = "http://api.quran-tafseer.com/tafseer/"

    private init() {}

    func fetch(for ayahNumber: Int, in surahNumber: Int, completion: @escaping (Result<(tabaryTafseer: Tafseer, ibnKatheerTafseer: Tafseer)>) -> Void) {
        let group = DispatchGroup()
        var tabaryTafseer: Tafseer!
        var ibnKatheerTafseer: Tafseer!
        var requestError: Error?
        group.enter()
        Alamofire.request("\(BASE_URL)8/\(surahNumber)/\(ayahNumber)").responseDecodableObject { (response: DataResponse<Tafseer>) in
            switch response.result {
            case let .success(tafseer): tabaryTafseer = tafseer
            case let .failure(error): requestError = error
            }
            group.leave()
        }
        group.enter()
        Alamofire.request("\(BASE_URL)4/\(surahNumber)/\(ayahNumber)").responseDecodableObject { (response: DataResponse<Tafseer>) in
            switch response.result {
            case let .success(tafseer): ibnKatheerTafseer = tafseer
            case let .failure(error): requestError = error
            }
            group.leave()
        }
        group.notify(queue: .main) {
            if let error = requestError {
                completion(.failure(error))
            } else {
                completion(.success((tabaryTafseer, ibnKatheerTafseer)))
            }
        }
    }
}
