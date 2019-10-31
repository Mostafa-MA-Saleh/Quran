//
//  NonPreviewTextView.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/31/19.
//

import UIKit

class NonPreviewTextView: UITextView {
    override public var selectedTextRange: UITextRange? {
        get {
            return nil
        }
        set { }
    }
}
