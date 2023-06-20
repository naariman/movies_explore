//
//  NSObject + Ext.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import Foundation

extension NSObject {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
