//
//  extension+String.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 4.06.2024.
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
        case login           = "Login"
        
        
        var localised: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
        
    }
    
}


