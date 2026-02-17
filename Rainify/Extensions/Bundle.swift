//
//  Untitled.swift
//  Rainify
//
//  Created by pedrosanz on 05/09/25.
//
import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T? {
            guard let url = self.url(forResource: file, withExtension: nil) else {
                print("❌ No se encontró \(file) en el bundle.")
                return nil
            }
            
            guard let data = try? Data(contentsOf: url) else {
                print("❌ No se pudo cargar \(file) del bundle.")
                return nil
            }
            
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            decoder.dateDecodingStrategy = .iso8601
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("❌ Error al decodificar \(file): \(error)")
                return nil
            }
        }
}
