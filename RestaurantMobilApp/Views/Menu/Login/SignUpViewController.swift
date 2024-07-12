//
//  SignUpViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 25.06.2024.
//

import UIKit
import SnapKit
import Then
import Lottie
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    weak var coordinator: LoginCoordinatorProtocol?
    private let network: DataServiceProtocol
    var verifyCode = ""
    var userEmail = ""
    var iterate = 0
    
    init(dataService: DataServiceProtocol) {
        self.network = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy private var animationView = LottieAnimationView()
    
    lazy private var indicator = customActivityIndicatorViewComponent()
    
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
        emailTextField.delegate = self
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
            $0.leading.equalTo(email.snp.leading)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.top.trailing.equalToSuperview()
        }
        nextButton.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.leading.equalTo(emailView.snp.leading).offset(24)
            $0.trailing.equalTo(emailView.snp.trailing).offset(-24)
            $0.top.equalTo(emailView.snp.bottom).offset(36)
        }
        already.snp.makeConstraints{
            $0.leading.equalTo(email.snp.leading)
            $0.top.equalTo(nextButton.snp.bottom).offset(50)
        }
        signin.snp.makeConstraints{
            $0.leading.equalTo(already.snp.trailing).offset(4)
            $0.centerY.equalTo(already.snp.centerY)
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
    
}

extension SignUpViewController {
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        if button == google {
            self.addIndicator()
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }

                let user = signInResult.user

                let emailAddress = user.profile?.email
                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                let profilePicUrl = user.profile?.imageURL(withDimension: 320)
                
                guard let fun = fullName,
                      let ea = emailAddress,
                      let gn = givenName,
                      let fn = familyName,
                      let pu = profilePicUrl
                else { return }
            
                print("fun -> \(fun)\nfn -> \(fn)\nea -> \(ea)\ngn -> \(gn)\nfn -> \(fn)\npu -> \(pu)")
                
                //fun, ea, pu lazım createUser da
                
                self.network.signUpNewUser(userPostDto: UserPostDto(
                    userFullName: fun,
                    userEmail: ea,
                    userPhoto: "\(pu)",
                    isActive: true,
                    userPassword: nil)) { newUser, state, networkMessage in DispatchQueue.main.async{
                        
                        self.indicator.removeFromSuperview()
                        
                        if state { //Burada başarılı bir şekilde kayıt gerçekleşmiştir.
                            
                            
                            
                        } else { // Kayıt işlemi başarısız
                            
                            self.view.showErrorMessage(viewModel: infoandOkeyActionViewComponent.ViewModel(
                                image: .warning,
                                info: "Record process is not success, please try again.",
                                textAligment: .center,
                                textColor: .black,
                                font: .boldSystemFont(ofSize: 16),
                                buttonTitle: "Okey",
                                buttonTitleColor: .goodFood,
                                cornerRadius: 20,
                                backgroundColor: .white, action: { state in
                                    
                                }))
                            
                        }
                        
                    }
                        
                }
            
            }
            
        }
        
        if button == nextButton {
            
            addIndicator()
            
            guard let email = emailTextField.text else { return }
            
            if self.iterate == 0 {
                
                if !email.isEmpty {
                    
                    //MARK: Burada ele alınan email servise gönderilecek, doğrulama kodu dönecek daha sonra şifre belirlenip yeni kayıt gerçekleşecek. 3 adımlı bir işlem olacak.
                    
                    network.fetchVerifyEmail(userEmail: email) { verifyCode, state, networkMessage in DispatchQueue.main.async{
                            
                        self.indicator.removeFromSuperview()
                        
                            if state {
                                
                                self.userEmail = email
                                
                                self.verifyCode = verifyCode
                                
                                self.firstIterate()
                                
                                self.iterate += 1
                                return
                            } else {
                                
                                self.view.showErrorMessage(viewModel: infoandOkeyActionViewComponent.ViewModel(
                                    image: .alertInformation,
                                    info: "Please enter a valid email address",
                                    textAligment: .center,
                                    textColor: .black,
                                    font: .boldSystemFont(ofSize: 16),
                                    buttonTitle: "Okey",
                                    buttonTitleColor: .goodFood,
                                    cornerRadius: 20,
                                    backgroundColor: .white,
                                    action: { check in
                                        
                                    }))
                            }
                            
                        }
                        
                    }
                    
                } else {
                    self.indicator.removeFromSuperview()
                    
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
            
            if self.iterate == 1 {
                
                //MARK: Burada gelen doğrulama kodu onaylanacak doğru ise 3.adım olan şifre belirleme gelecek.
                
                if email == self.verifyCode {
                    self.indicator.removeFromSuperview()
                    
                    secondIterate()
                    
                    self.iterate += 1
                    return
                } else {
                    self.indicator.removeFromSuperview()
                    self.view.showErrorMessage(viewModel: infoandOkeyActionViewComponent.ViewModel(
                        image: .warning,
                        info: "Verify code is not valid",
                        textAligment: .center,
                        textColor: .black,
                        font: .boldSystemFont(ofSize: 16),
                        buttonTitle: "Okey",
                        buttonTitleColor: .goodFood,
                        cornerRadius: 20,
                        backgroundColor: .white,
                        action: { check in
                            
                        }))
                }
            }
            
            if iterate == 2 {
                
                //MARK: burada var olan userEmail ile textFieldde var olan text ile yeni kayıt servisine post işlemi gerçekleştireceğiz!
                
                network.signUpNewUser(userPostDto: UserPostDto(
                    userFullName: self.userEmail,
                    userEmail: self.userEmail,
                    userPhoto: nil,
                    isActive: true,
                    userPassword: EncodedDataAlgorithms().encryptText(text: email, key: EncyrptKEY.default))) { newUser, state, networkMessage in DispatchQueue.main.async{
                        
                        self.indicator.removeFromSuperview()
                        
                        if state {
                            
                            self.iterate += 1
                            //MARK: Burada bu şekilde bir şey yaptımda ilerleyen aşamalarda belik direk login oldurup ana sayfaya yönlendirme işlemi yapılabilir. Coordinatorına ekleyerek.
                            self.successRecord()
                            
                            return
                            
                        } else {
                            
                            self.view.showErrorMessage(viewModel: infoandOkeyActionViewComponent.ViewModel(
                                image: .warning,
                                info: "Your registration could not be created",
                                textAligment: .center,
                                textColor: .black,
                                font: .boldSystemFont(ofSize: 16),
                                buttonTitle: "Okey",
                                buttonTitleColor: .goodFood,
                                cornerRadius: 20,
                                backgroundColor: .white, action: { check in
                                    
                                }))
                        }
                            
                        }
                        
                    }
                
            }
            
            if iterate == 3 {
                self.indicator.removeFromSuperview()
                navigationController?.popViewController(animated: true)
            }
            
        }
        
        if button == signin {
            navigationController?.popViewController(animated: true)
        }
        
    }

    
    private func firstIterate() {
        
        info.removeFromSuperview()
        google.removeFromSuperview()
        leftLine.removeFromSuperview()
        betweenLine.removeFromSuperview()
        rightLine.removeFromSuperview()
        
        email.text = "Verify Code"
        emailTextField.placeholder = "Enter to verify code"
        emailTextField.text = ""
        emailTextField.keyboardType = .numberPad
        emailTextField.isSecureTextEntry = true
        
        animationView = .init(name: "verificationAnimationView")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        animationView.play()
        
        email.snp.removeConstraints()
        email.snp.makeConstraints{
            $0.top.equalTo(animationView.snp.bottom).offset(40)
            $0.height.equalTo(16)
            $0.leading.equalToSuperview().offset(24)
        }
        
        
    }
    
    private func secondIterate() {
        
        animationView = .init(name: "securityAnimationView")
        
        email.text = "New Password"
        emailTextField.keyboardType = .default
        emailTextField.text = ""
        emailTextField.placeholder = "Enter to new password"
        
        nextButton.setTitle("Create", for: .normal)
        
    }
    
    private func successRecord() {
        
        contentView.subviews.forEach{
            $0.removeFromSuperview()
        }
        
        animationView = .init(name: "successAnimationView")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(250)
        }
        
        animationView.play()
        
        nextButton.setTitle("Go to Login", for: .normal)
        
        contentView.addSubview(nextButton)
        
        nextButton.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.leading.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-48)
            $0.top.equalTo(animationView.snp.bottom).offset(40)
        }
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        
        if textField.keyboardType == .numberPad {
            if updatedText.count == 7 {
                return false
            }
        }
    
        //Burada validation error silinecek
        return true
    }
    
}

