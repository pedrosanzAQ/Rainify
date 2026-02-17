//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 29/09/25.
//

import Foundation

extension Condition {
    var iconURL: URL? {
        let urlString = icon.hasPrefix("http") ? icon : "https:\(icon)"
        return URL(string: urlString)
    }
}
