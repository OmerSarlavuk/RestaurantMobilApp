//
//  EncodedDataAlgorithms.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 25.06.2024.
//

import UIKit

//MARK: Data Encode and Decode Algorithms

/*
 In Vigenere encryption, encryption occurs only through the letters of the alphabet. Its shortcoming is that it ignores the characters. Here, encryption is performed for chars (characters, letters, symbols) with decimal range [33-126] in the ASCII table. This means that data is encrypted no matter how. Here, the range [33-126] is placed as rows and columns. Then, it decreases and changes, one under the other, until the last one reaches the beginning. Data is written overlapping with a predetermined key, and each overlapping character is multiplied into the resulting vigenere matrix. The new corresponding character is now an encrypted character.
 
 //MARK: vigenere matris only alphabet -> https://miro.medium.com/v2/resize:fit:1400/format:webp/1*VYeVYpg4FsVuNrU_ziRdMw.png
 
 */

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

