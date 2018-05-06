//
//  String+Extensions.swift
//  GitHubSearch
//
//  Created by Gene on 5/6/18.
//  Copyright © 2018 YevhenTsyhanenko. All rights reserved.
//

import Foundation

extension String {
    
    // Simple encryption for authorization token
    
    func encrypted(withShift shift: Int = 3) -> String {
        let scalars = self.unicodeScalars.flatMap {
            UnicodeScalar(Int($0.value) + shift)
        }
        
        return String(String.UnicodeScalarView(scalars))
    }
    
    func decrypted(withShift shift: Int = 3) -> String {
        let scalars = self.unicodeScalars.flatMap {
            UnicodeScalar(Int($0.value) - shift)
        }
        
        return String(String.UnicodeScalarView(scalars))
    }
}
