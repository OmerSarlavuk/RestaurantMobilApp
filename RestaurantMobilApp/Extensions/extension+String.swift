//
//  extension+String.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 4.06.2024.
//

import Foundation


extension String {
    
    
    enum StringContentinLocalizable: String {
        
        case noData          = "noData"
        case versionNumber   = "versionNumber"
        case menuReservation = "menuReservation"
        case menuPhotos      = "menuPhotos"
        case menuFavorites   = "menuFavorites"
        case menuAbout       = "menuAbout"
        case menuLocation    = "menuLocation"
        
        
        var localised: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
        
    }
    
}

