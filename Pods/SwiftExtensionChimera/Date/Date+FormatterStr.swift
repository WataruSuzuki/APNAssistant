//
//  Date+FormatterStr.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2018/11/15.
//  Copyright © 2018 WataruSuzuki. All rights reserved.
//

import Foundation

extension Date {
    
    public func formattedString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
