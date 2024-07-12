//
//  Fonts.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
import UIKit

class Fonts {
    
    static let main = AppFont(name: "HoeflerText")
    
    static let movieSmallTitle = Fonts.main.font(style: .black, size: 13)
    static let movieMediumTitle = Fonts.main.font(style: .black, size: 17)
    static let movieBigTitle = Fonts.main.font(style: .black, size: 20)
    
    static let dateLabel =  Fonts.main.font(style: .regular, size: 13)
    
    static let genres = Fonts.main.font(style: .italic, size: 13)
    static let spokenLanguage = Fonts.main.font(style: .italic, size: 13)
    
    static let popularMoviesHeader = Fonts.main.font(style: .black, size: 20)
    
    static let overviewLabel = Fonts.main.font(style: .regular, size: 16)
    
    static let hintsLabel = Fonts.main.font(style: .italic, size: 13)
}

class AppFont {
    let name: String!
    
    init(name: String) {
        self.name = name
    }
    
    func font(style: AppFontStyle, size: CGFloat)-> UIFont {
        if let font = UIFont(name: "\(name ?? "")-\(style.rawValue)", size: size) {
            return font
        }else{
            return UIFont.systemFont(ofSize: size)
        }
    }
}
enum AppFontNames{
    case ReadexPro
}

enum AppFontStyle: String {
    case regular = "Regular"
    case black = "black"
    case blackItalic = "blackItalic"
    case italic = "italic"
}
