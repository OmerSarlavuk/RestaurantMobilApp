//
//  AiViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit
import Then
import SwiftUI
import GoogleGenerativeAI
import Lottie


class AiViewController: UIViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    var messages: [String] = []
    var selectedImage: UIImage?
    var animationView: LottieAnimationView!
    
    lazy private var indicator = customActivityIndicatorViewComponent()
    
    lazy private var scrollView = UIScrollView().then{
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy private var scrollContentView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy private var logo: UIImageView = {
        let view = UIImageView()
        view.image = .goodFood
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy private var comp1 = LabelandGeneralViewComponent().then{
        $0.configure(viewModel: LabelandGeneralViewComponent.ViewModel(content: "By entering at least 3 ingredients, you can create a meal, dessert, drink, etc. recommended by GF Chat. You can get suggestion.", font: .systemFont(ofSize: 16), textColor: .darkGray, aligment: .center, borderWith: 0.4, radius: 15, borderColor: UIColor.lightGray.cgColor))
    }
    
    lazy private var comp2 = LabelandGeneralViewComponent().then{
        $0.configure(viewModel: LabelandGeneralViewComponent.ViewModel(content: "If you wish, you can upload a picture of any drink, meal or dessert type and see the ingredients to be used.", font: .systemFont(ofSize: 16), textColor: .darkGray, aligment: .center, borderWith: 0.4, radius: 15, borderColor: UIColor.lightGray.cgColor))
    }
    
    lazy private var aiImage = UIImageView().then{
        $0.image = .ai
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    lazy private var welcome = UILabel().then{
        $0.text = "Welcome, how can I help you?"
        $0.font = .systemFont(ofSize: 18)
        $0.textAlignment = .center
        $0.textColor = .darkGray
    }
  
    lazy private var contentLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    
    lazy private var searchView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.3
    }
    
    lazy private var searchTextField = UITextField().then{
        $0.placeholder = "Please enter at least 3 ingredients"
    }
    
    lazy private var imageButton = UIButton().then{
        $0.setImage(.image, for: .normal)
        $0.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
    }
    
    lazy private var sendButton = UIButton().then{
        $0.setImage(.send, for: .normal)
        $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesture)
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        self.navigationItem.title = "GF Chat"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(logo)
        scrollContentView.addSubview(comp1)
        scrollContentView.addSubview(comp2)
//        scrollContentView.addSubview(aiImage)
        scrollContentView.addSubview(welcome)
        scrollContentView.addSubview(contentLabel)
        view.addSubview(searchView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(imageButton)
        view.addSubview(sendButton)
        setupConstraints()
        setupAnimationView()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(searchView.snp.top)
        }
        scrollContentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        logo.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(65)
        }
        comp1.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(logo.snp.bottom).offset(24)
            $0.height.equalTo(130)
        }
        comp2.snp.makeConstraints{
            $0.leading.equalTo(comp1.snp.leading)
            $0.trailing.equalTo(comp1.snp.trailing)
            $0.top.equalTo(comp1.snp.bottom).offset(16)
            $0.height.equalTo(130)
        }
        welcome.snp.makeConstraints{
            $0.top.equalTo(comp2.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        contentLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(welcome.snp.bottom).offset(36)
        }
        sendButton.snp.makeConstraints{
            $0.centerY.equalTo(searchView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.equalTo(44)
        }
        searchView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(50)
        }
        searchTextField.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(imageButton.snp.leading).offset(-4)
            $0.leading.equalToSuperview().offset(10)
        }
        imageButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            searchView.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalTo(sendButton.snp.leading).offset(-16)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-(keyboardHeight + 16))
                $0.height.equalTo(50)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        searchView.snp.removeConstraints()
        searchView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    
    func getIdentifierHeight() -> CGFloat {
           let maxSize = CGSize(width: self.contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
           let height = contentLabel.sizeThatFits(maxSize).height
           return height
       }
    
    
    @objc private func imageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        
        self.addIndicator()
        
        if let image = self.selectedImage {
    
            messages.append("\n\n\n\n\n\n\n\n\n\nYou: \(searchText)")
           
            Task {
                do {
                    let result = try await model.generateContent(searchText, image)
                    guard let response = result.text else { return }
                    
                    DispatchQueue.main.async {
                        self.messages.append("Good Food: \(response)")
                        self.updateContentLabel()
                        self.indicator.removeFromSuperview()
                    }
                } catch {
                    debugPrint("Error generating AI content: \(error)")
                    DispatchQueue.main.async {
                        debugPrint("AI ERR!")
                    }
                }
            }
            
            self.selectedImage = nil
            
        } else {
            
            messages.append("You: \(searchText)")
            
            Task {
                do {
                    let result = try await model.generateContent(searchText)
                    guard let response = result.text else { return }
                    
                    DispatchQueue.main.async {
                        self.messages.append("Good Food: \(response)")
                        self.updateContentLabel()
                        self.indicator.removeFromSuperview()
                    }
                } catch {
                    debugPrint("Error generating AI content: \(error)")
                    DispatchQueue.main.async {
                        debugPrint("AI ERR!")
                    }
                }
            }
        }
        searchTextField.text = ""
    }
    
    private func updateContentLabel() {
        contentLabel.text = messages.joined(separator: "\n\n\n")
        contentLabel.sizeToFit()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentLabel.frame.maxY)
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func addIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
            $0.width.height.equalTo(50)
        }
        indicator.startAnimation()
    }
    
    private func setupAnimationView() {
        
        animationView = .init(name: "aiAnimationView")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints{
            $0.top.equalTo(comp2.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(65)
        }
        
        animationView.play()
        
    }
    
}

extension AiViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.selectedImage = pickedImage
        }
        picker.dismiss(animated: true, completion: {
            
           
            /*
             
             Burada seçilen image alınıp doğrudan gösterilebilir.
             
             */
            
            guard let img = self.selectedImage else { return }
            
            let view = UIImageView()
            view.backgroundColor = .clear
            view.layer.cornerRadius = 15
            view.layer.masksToBounds = true
            view.contentMode = .scaleAspectFill
            view.image = img
            
            self.scrollContentView.addSubview(view)
            
            self.view.layoutIfNeeded()
            let scrollContentViewTop = self.scrollContentView.frame.origin.y
            let contentLabelTop = self.contentLabel.frame.origin.y
            let heightDifference = contentLabelTop - scrollContentViewTop
            
            view.snp.makeConstraints{
                $0.width.height.equalTo(175)
                $0.leading.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset((self.getIdentifierHeight()) + (heightDifference))
                
            }

        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


