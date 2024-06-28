//
//  PDFCreator.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 28.06.2024.
//

import UIKit
import PDFKit

class PDFCreator {

    func createPDF(logo: UIImage, title: String, mainImage: UIImage, firstParagraph: String, secondParagraph: String) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Your App",
            kCGPDFContextAuthor: "Your Name",
            kCGPDFContextTitle: "PDF Document"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 595.2
        let pageHeight = 970.0
        let margin: CGFloat = 20.0

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { (context) in
            context.beginPage()

            let context = context.cgContext

            // Apply the vertical flip transform
            context.saveGState()
            context.translateBy(x: 0, y: pageHeight)
            context.scaleBy(x: 1.0, y: -1.0)

            // Logo
            let logoRect = CGRect(x: (pageWidth - 150) / 2, y: pageHeight - 170, width: 150, height: 150)
            context.draw(logo.cgImage!, in: logoRect)

            // Restore the context to remove the flip for text drawing
            context.restoreGState()
            
            // Title   ->   (pageWidth - 160) / 2
            let titleRect = CGRect(x: margin, y: pageHeight - 790, width: pageWidth - 2 * margin, height: 30)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: NSMutableParagraphStyle.default,
                .foregroundColor: UIColor.black
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
            attributedTitle.draw(in: titleRect)

            // Apply the vertical flip transform for the main image
            context.saveGState()
            context.translateBy(x: 0, y: titleRect.origin.y + 340)
            context.scaleBy(x: 1.0, y: -1.0)

            // Main Image   -  (pageWidth - 380) / 2
            let imageRect = CGRect(x: margin, y: 0, width: 400, height: 300)
            context.draw(mainImage.cgImage!, in: imageRect)

            // Restore the context for the text drawing
            context.restoreGState()

            // First Paragraph
            let firstParagraphRect = CGRect(x: margin, y: titleRect.origin.y + 380, width: pageWidth - 2 * margin, height: 165)
            let firstParagraphAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .paragraphStyle: NSMutableParagraphStyle.default,
                .foregroundColor: UIColor.black
            ]
            let attributedFirstParagraph = NSAttributedString(string: firstParagraph, attributes: firstParagraphAttributes)
            attributedFirstParagraph.draw(in: firstParagraphRect)

            // Second Paragraph
            let secondParagraphRect = CGRect(x: margin, y: firstParagraphRect.maxY + 10, width: pageWidth - 2 * margin, height: 165)
            let secondParagraphAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .paragraphStyle: NSMutableParagraphStyle.default,
                .foregroundColor: UIColor.black
            ]
            let attributedSecondParagraph = NSAttributedString(string: secondParagraph, attributes: secondParagraphAttributes)
            attributedSecondParagraph.draw(in: secondParagraphRect)
            
            // Drawing the components
            let stackViewY = secondParagraphRect.maxY + 16
            let componentWidth = (pageWidth - 2 * margin) / 4.0
            let componentHeight: CGFloat = 50.0

            let components = [
                ("CALORIES", "155 kcal"),
                ("CARBS", "16 g"),
                ("FAT", "9 g"),
                ("PROTEIN", "4 g")
            ]
            
            for (index, component) in components.enumerated() {
                let x = margin + CGFloat(index) * componentWidth
                let titleRect = CGRect(x: x, y: stackViewY, width: componentWidth, height: componentHeight / 2)
                let valueRect = CGRect(x: x, y: stackViewY + componentHeight / 2, width: componentWidth, height: componentHeight / 2)

                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.iconandIdentifierViewComponentColor1
                ]
                let valueAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.darkGray
                ]

                let titleAttributedString = NSAttributedString(string: component.0, attributes: titleAttributes)
                titleAttributedString.draw(in: titleRect)

                let valueAttributedString = NSAttributedString(string: component.1, attributes: valueAttributes)
                valueAttributedString.draw(in: valueRect)
            }
        }

        return data
    }
}


