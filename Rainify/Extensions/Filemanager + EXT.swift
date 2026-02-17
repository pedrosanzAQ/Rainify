//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 09/01/26.
//

import Foundation

extension FileManager {
    func save<T: Codable>(_ value: T, to url: URL) throws {
        let data = try JSONEncoder().encode(value)
        try data.write(to: url, options: .atomic)
    }
    
    func load<T: Codable>(_ type: T.Type, from url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }

}
