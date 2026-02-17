//
//  String.swift
//  Rainify
//
//  Created by pedrosanz on 02/06/25.
//
import Foundation

extension String {
    
    // Convert String to File Name ("Full Moon" -> "full_moon")
    var moonImageName: String {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
    }
    
    // Devuelve solo la hora en formato "HH:mm" si el string tiene formato "yyyy-MM-dd HH:mm"
    var hourFormat: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // JSON en UTC
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: self) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        displayFormatter.timeZone = TimeZone(secondsFromGMT: 0) // NO convertir a local
        displayFormatter.dateFormat = "ha"
        displayFormatter.amSymbol = " a.m."
        displayFormatter.pmSymbol = " p.m."
        
        return displayFormatter.string(from: date).lowercased()
    }
    
    var extractHourMinute: String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd HH:mm"
        input.locale = Locale(identifier: "en_US_POSIX")
        
        let output = DateFormatter()
        output.dateFormat = "HH:mm"
        
        if let date = input.date(from: self) {
            return output.string(from: date)
        }
        
        return "--:--"
    }

    
    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: self) else { return "--" }

        formatter.locale = Locale(identifier: "es_MX") // o "es_ES"
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).capitalized
    }

}

//extension String {
//    private static let inputDateFormatter: DateFormatter = {
//        let f = DateFormatter()
//        f.locale = Locale(identifier: "en_US_POSIX")
//        f.dateFormat = "yyyy-MM-dd"
//        return f
//    }()
//    
//    private static let weekdayFormatter: DateFormatter = {
//        let f = DateFormatter()
//        f.locale = Locale(identifier: "es_MX")
//        f.dateFormat = "EEE"
//        return f
//    }()
//    
//    var weekdayName: String {
//        guard let date = Self.inputDateFormatter.date(from: self) else { return "--" }
//        return Self.weekdayFormatter.string(from: date).capitalized
//    }
//    
//    var moonImageName: String {
//        self
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//            .lowercased()
//            .replacingOccurrences(of: " ", with: "_")
//    }
//}

