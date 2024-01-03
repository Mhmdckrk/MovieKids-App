//
//  Extensions.swift
//  MovieKids Project (Netflix Clone)
//
//  Created by Mahmud Cikrik on 14/12/2023.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
