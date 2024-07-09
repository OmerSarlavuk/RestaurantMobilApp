//
//  PDFViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 28.06.2024.
//

import UIKit
import PDFKit
import SnapKit
import Then

class PDFViewController: UIViewController {
    
    weak var coordinator: FirstDetailViewCoordinatorProtocol?
    var dto: PDFFileDto?
    var pdfData: Data!
    
    lazy private var pdfView = PDFView().then{ $0.autoScales = true }
    
}

extension PDFViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDF()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "PDF File"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .download,
            style: .done,
            target: self,
            action: #selector(shareButtonTapped)
        )
        view.backgroundColor = .themePrimary
    }
    
    
    private func setupUI() {
        self.view.addSubview(pdfView)

        guard let data = pdfData else { return }
        
        if let document = PDFDocument(data: data) {
            pdfView.document = document
        }
    
        setupConstraints()
    }
    
    private func setupConstraints() {
        pdfView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupPDF() {
        
        let pdfCreator = PDFCreator()
        
        guard let dto = self.dto else { return }
        
        let pdfData = pdfCreator.createPDF(
            logo: UIImage.restaurantLogo,
            title: dto.mealName,
            mainImage: dto.mealImage,
            firstParagraph: dto.instructions,
            secondParagraph: dto.ingredients
        )
        
        self.pdfData = pdfData
        
    }
    
    @objc private func shareButtonTapped() {
        
        guard let dto = self.dto else { return }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(dto.mealName).pdf")
               do {
                   try pdfData.write(to: tempURL)
               } catch {
                   print("Could not save PDF file: \(error)")
                   return
               }
        
        let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
}

