//
//  String+DateFormat.swift
//  SwiftExtensionChimera
//
//  Created by WataruSuzuki on 2018/11/15.
//  Copyright © 2018 WataruSuzuki. All rights reserved.
//

import Foundation

extension String {
    
    public func dateFromString(string: String) -> Date {
        return dateFromString(timeStyle: .full)
    }
    
    public func dateFromString(timeStyle: DateFormatter.Style) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        formatter.timeStyle = timeStyle
        return formatter.date(from: self)!
    }
}
