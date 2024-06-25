//
//  EncodedDataAlgorithms.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 25.06.2024.
//

import UIKit


class EncodedDataAlgorithms {
    
    let startAscii: UInt8 = 33
    let endAscii: UInt8 = 126

    func createVigenereTable()  -> [[Character?]]{
        
        let totalCharacters = Int(endAscii - startAscii + 1)
        var vigenereTable: [[Character?]] = Array(repeating: Array(repeating: nil, count: totalCharacters + 1), count: totalCharacters + 1)
        
        for i in 1...totalCharacters {
            let asciiValue = startAscii + UInt8(i - 1)
            vigenereTable[0][i] = Character(UnicodeScalar(asciiValue))
            vigenereTable[i][0] = Character(UnicodeScalar(asciiValue))
        }
        
        for i in 1...totalCharacters {
            for j in 1...totalCharacters {
                let asciiValue = startAscii + UInt8((i + j - 2) % totalCharacters)
                vigenereTable[i][j] = Character(UnicodeScalar(asciiValue))
            }
        }
        
        return vigenereTable
    }
    
    func encryptText(text: String, key: String) -> String {
        var encryptedText = ""
        let keyLength = key.count
        
        for (index, char) in text.enumerated() {
            let keyChar = key[key.index(key.startIndex, offsetBy: index % keyLength)]
            let encryptedChar = findIndex(rowText: char, colText: keyChar)
            encryptedText += encryptedChar
        }
        
        return encryptedText
    }
    
    func findIndex(rowText: Character, colText: Character) -> String {
        
        let vigenereTable = createVigenereTable()
        let totalCharacters = Int(endAscii - startAscii + 1)
        var row = 0
        var col = 0
        for i in 1...totalCharacters {
            if vigenereTable[0][i] == rowText {
                row = i
                break
            }
        }
        for i in 1...totalCharacters {
            if vigenereTable[i][0] == colText {
                col = i
                break
            }
        }
        
        let char = vigenereTable[col][row]
        var a: String = ""
        if let ch = char {
            a = "\(ch)"
        }
        return a
    }
    
    func decryptText(encryptedText: String, key: String) -> String {
           var decryptedText = ""
           let keyLength = key.count
           let vigenereTable = createVigenereTable()
           let totalCharacters = Int(endAscii - startAscii + 1)
           
           for (index, char) in encryptedText.enumerated() {
               let keyChar = key[key.index(key.startIndex, offsetBy: index % keyLength)]
               
               var row = 0
               var col = 0
               
               for i in 1...totalCharacters {
                   if vigenereTable[i][0] == keyChar {
                       row = i
                       break
                   }
               }
               
               for i in 1...totalCharacters {
                   if vigenereTable[row][i] == char {
                       col = i
                       break
                   }
               }
               
               let decryptedChar = vigenereTable[0][col]
               if let ch = decryptedChar {
                   decryptedText += "\(ch)"
               }
           }
           
           return decryptedText
       }
    
}

