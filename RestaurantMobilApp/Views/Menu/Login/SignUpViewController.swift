//
//  SignUpViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 25.06.2024.
//

import UIKit
import SnapKit
import Then

class SignUpViewController: UIViewController {
    
    weak var coordinator: LoginCoordinatorProtocol?
    
    lazy private var info: UILabel = {
       let label = UILabel()
        label.text = "Please enter the required information to sign in to Good Food."
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy private var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy private var google: UIButton = {
       let button = UIButton()
        button.setTitle("    Sign up with Google", for: .normal)
        button.setImage(.googleButton, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        
        button.imageView?.snp.makeConstraints{
            $0.width.equalTo(15)
            $0.height.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-80)
        }
        button.titleLabel?.snp.makeConstraints{
            $0.centerY.equalToSuperview()
        }
        
        return button
    }()
    
    lazy private var leftLine = UIView().then{ $0.backgroundColor = .clearLightGray }
    
    lazy private var betweenLine: UILabel = {
       let label = UILabel()
        label.text = "or Sign Up with email"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    lazy private var rightLine = UIView().then{ $0.backgroundColor = .clearLightGray }
    
    lazy private var email = UILabel().then{ $0.text = "Email"; $0.font = .boldSystemFont(ofSize: 14); $0.textColor = .darkGray}
    
//    self.customLabel(text: "Email", font: .boldSystemFont(ofSize: 14), textColor: .darkGray)
    
    lazy private var emailView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy private var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    lazy private var nextButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .goodFood
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var already: UILabel = {
       let label = UILabel()
        label.text = "Already have an account?"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy private var signin: UIButton = {
       let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.goodFood, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /*
     yeni kayıt servis bağlantısı
     
     DataService().signUpNewUser(userPostDto: UserPostDto(
         userFullName: "Swift Deneme Kullanıcısı",
         userEmail: "swiftdeneme@gmail.com",
         userPhoto: "base64 olarak değişecek sonra",
         isActive: true,
         userPassword: "YfM`gUZTTQ_^faRPRcVZhOS")) { isUser, state, message in
             
             if state {
                 print("kaydetme işlemi başarılı!")
             } else {
                 print("kayıt işlemi başarısız -> \(message!)")
             }
             
         }
     */
    
}

extension SignUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cornerRadii = CGSize(width: 50, height: 50)
        let maskPath = UIBezierPath(
            roundedRect: contentView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: cornerRadii
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .tabbarLocationView
        self.navigationItem.title = "Sign Up"
        view.addSubview(contentView)
        contentView.addSubview(info)
        contentView.addSubview(google)
        contentView.addSubview(leftLine)
        contentView.addSubview(betweenLine)
        contentView.addSubview(rightLine)
        contentView.addSubview(email)
        contentView.addSubview(emailView)
        emailView.addSubview(emailTextField)
        contentView.addSubview(nextButton)
        contentView.addSubview(already)
        contentView.addSubview(signin)
        setupConstraints()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
        }
        info.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
            $0.top.equalToSuperview().offset(30)
        }
        google.snp.makeConstraints{
            $0.height.equalTo(55)
            $0.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-48)
            $0.top.equalTo(info.snp.bottom).offset(36)
        }
        betweenLine.snp.makeConstraints{
            $0.top.equalTo(google.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        leftLine.snp.makeConstraints{
            $0.centerY.equalTo(betweenLine.snp.centerY)
            $0.leading.equalTo(google.snp.leading)
            $0.height.equalTo(2)
            $0.trailing.equalTo(betweenLine.snp.leading).offset(-12)
        }
        rightLine.snp.makeConstraints{
            $0.centerY.equalTo(betweenLine.snp.centerY)
            $0.height.equalTo(2)
            $0.trailing.equalTo(google.snp.trailing)
            $0.leading.equalTo(betweenLine.snp.trailing).offset(12)
        }
        email.snp.makeConstraints{
            $0.top.equalTo(betweenLine.snp.bottom).offset(40)
            $0.height.equalTo(16)
            $0.leading.equalTo(google.snp.leading)
        }
        emailView.snp.makeConstraints{
            $0.top.equalTo(email.snp.bottom).offset(8)
            $0.leading.equalTo(google.snp.leading)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.top.trailing.equalToSuperview()
        }
        nextButton.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.leading.equalTo(google.snp.leading).offset(24)
            $0.trailing.equalTo(google.snp.trailing).offset(-24)
            $0.top.equalTo(emailView.snp.bottom).offset(36)
        }
        already.snp.makeConstraints{
            $0.leading.equalTo(google.snp.leading)
            $0.top.equalTo(nextButton.snp.bottom).offset(50)
        }
        signin.snp.makeConstraints{
            $0.leading.equalTo(already.snp.trailing).offset(4)
            $0.centerY.equalTo(already.snp.centerY)
        }
    }
    
}

extension SignUpViewController {
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        if button == google {
            
            print("google button tapped!")
            
        }
        
        if button == nextButton {
            
            guard let email = emailTextField.text else { return }
            
            if !email.isEmpty {
                print("email -> \(email)")
            } else {
                
                view.showErrorMessage(
                    viewModel: infoandOkeyActionViewComponent.ViewModel(
                        image: .warning,
                        info: "Please enter your email registered in the system.",
                        textAligment: .center,
                        textColor: .black,
                        font: .boldSystemFont(ofSize: 16),
                        buttonTitle: "Okey",
                        buttonTitleColor: .goodFood,
                        cornerRadius: 20,
                        backgroundColor: .white,
                        action: { state in
                            //MARK: extension tarafında ele alındı bu kısım
                        }))
                
            }
            
        }
        
        if button == signin {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}

