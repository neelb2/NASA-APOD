//
//  APODColor.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import Foundation
import UIKit

class APODColor {
    static let sharedInstance = APODColor()
    var isDarkMode = false
    
    var titleColor: UIColor {
        return isDarkMode ? .white : .black
    }
    
    var backgroundColor: UIColor {
        return isDarkMode ? .black : .white
    }
    
    var barItemColor: UIColor {
        return .systemBlue
    }
    
    var unSelectedBarItemColor: UIColor {
        return isDarkMode ? .white : .gray
    }
    
    var cellBackgroundColor: UIColor {
        return isDarkMode ? .white : .darkText
    }
    
    var cellTitleColor: UIColor {
        return isDarkMode ? .black : .white
    }
    
    var pickerColor: UIColor {
        return isDarkMode ? .darkText : .lightGray
    }
}
