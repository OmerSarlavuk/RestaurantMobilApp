//
//  LoginViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 10.06.2024.
//

import UIKit
import SnapKit
import Then
import GoogleSignIn


class LoginViewController: UIViewController {

    
    weak var coordinator: MainCoordinatorProtocol?
    
    lazy private var indicator = customActivityIndicatorViewComponent()
    
    lazy private var scrollView = UIScrollView().then{
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    lazy private var contentView = UIView()
    
    lazy private var logo: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .clear
        view.image = .restaurantLogo
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 70
        return view
    }()
    
    lazy private var welcome  = self.customLabel(text: "Welcome!", font: .boldSystemFont(ofSize: 26), textColor: .goodFood)
    lazy private var email    = self.customLabel(text: "Email", font: .boldSystemFont(ofSize: 14), textColor: .darkGray)
    lazy private var password = self.customLabel(text: "Password", font: .boldSystemFont(ofSize: 14), textColor: .darkGray)
    
    
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
    
    lazy private var passwordView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy private var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.isSecureTextEntry = true
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    lazy private var forgetPass: UIButton = {
       let button = UIButton()
        button.setTitle("Forget Password?", for: .normal)
        button.setTitleColor(.goodFood, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var login: UIButton = {
       let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        button.backgroundColor = .goodFood
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy private var leftLine = UIView().then{
        $0.backgroundColor = .clearLightGray
    }
    
    lazy private var or = UILabel().then{
        $0.text = "OR"
        $0.textColor = .goodFood
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    lazy private var rightLine = UIView().then{
        $0.backgroundColor = .clearLightGray
    }
    
    lazy private var google: UIButton = {
       let button = UIButton()
        button.setTitle("Sign in with google", for: .normal)
        button.setTitleColor(.goodFood, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var dontAccount: UILabel = {
       let label = UILabel()
        label.text = "Don't have an account yet?"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy private var signUp: UIButton = {
       let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.goodFood, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func dimissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .themePrimary
        self.navigationItem.title = "Login"
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logo)
        contentView.addSubview(welcome)
        contentView.addSubview(email)
        contentView.addSubview(emailView)
        emailView.addSubview(emailTextField)
        contentView.addSubview(password)
        contentView.addSubview(passwordView)
        passwordView.addSubview(passwordTextField)
        contentView.addSubview(forgetPass)
        contentView.addSubview(login)
        contentView.addSubview(leftLine)
        contentView.addSubview(or)
        contentView.addSubview(rightLine)
        contentView.addSubview(google)
        contentView.addSubview(dontAccount)
        contentView.addSubview(signUp)
        setupConstraints()
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
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
            $0.height.equalTo(view.frame.height)
        }
        logo.snp.makeConstraints{
            $0.width.height.equalTo(140)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
        }
        welcome.snp.makeConstraints{
            $0.top.equalTo(logo.snp.bottom).offset(32)
            $0.height.equalTo(30)
            $0.leading.equalToSuperview().offset(32)
        }
        email.snp.makeConstraints{
            $0.top.equalTo(welcome.snp.bottom).offset(24)
            $0.height.equalTo(16)
            $0.leading.equalTo(welcome.snp.leading)
        }
        emailView.snp.makeConstraints{
            $0.top.equalTo(email.snp.bottom).offset(8)
            $0.leading.equalTo(welcome.snp.leading)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.top.trailing.equalToSuperview()
        }
        password.snp.makeConstraints{
            $0.top.equalTo(emailView.snp.bottom).offset(24)
            $0.height.equalTo(16)
            $0.leading.equalTo(welcome.snp.leading)
        }
        passwordView.snp.makeConstraints{
            $0.top.equalTo(password.snp.bottom).offset(8)
            $0.leading.equalTo(welcome.snp.leading)
            $0.trailing.equalToSuperview().offset(-32)
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.top.trailing.equalToSuperview()
        }
        forgetPass.snp.makeConstraints{
            $0.trailing.equalTo(passwordView.snp.trailing)
            $0.top.equalTo(passwordView.snp.bottom).offset(10)
            $0.height.equalTo(20)
        }
        login.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().offset(-54)
            $0.height.equalTo(50)
            $0.top.equalTo(forgetPass.snp.bottom).offset(28)
        }
        or.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(google.snp.top).offset(-14)
        }
        leftLine.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(36)
            $0.trailing.equalTo(or.snp.leading).offset(-24)
            $0.centerY.equalTo(or.snp.centerY)
            $0.height.equalTo(2)
        }
        rightLine.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-36)
            $0.leading.equalTo(or.snp.trailing).offset(24)
            $0.centerY.equalTo(or.snp.centerY)
            $0.height.equalTo(2)
        }
        google.snp.makeConstraints{
            $0.bottom.equalTo(dontAccount.snp.top).offset(-6)
            $0.leading.equalTo(dontAccount.snp.leading)
            $0.trailing.equalTo(signUp.snp.trailing)
        }
        dontAccount.snp.makeConstraints{
            $0.centerX.equalToSuperview().offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
        signUp.snp.makeConstraints{
            $0.leading.equalTo(dontAccount.snp.trailing).offset(4)
            $0.centerY.equalTo(dontAccount.snp.centerY)
        }
    }

    private func customLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
        
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        if button == google {
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }

                let user = signInResult.user

                let emailAddress = user.profile?.email
                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName

//                let profilePicUrl = user.profile?.imageURL(withDimension: 320) Varsa profil fotosu
                
                guard let fn = fullName,
                      let ea = emailAddress,
                      let gn = givenName,
                      let on = familyName
                else { return }
            
                //MARK: Burada bizim kontrollerimizden geçip servisten gelen kullanıcı verisi ile kıyaslanmalı ona göre geçtirilmeli
                
                self.addIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self = self else { return }
                    self.indicator.removeFromSuperview()
                    LocalDataBaseProcess().setDATA(value: "login", key: "isLogin")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
        if button == login {
            let algorithm = EncodedDataAlgorithms()
            let key = EncyrptKEY.default
            
            guard let userEmail = self.emailTextField.text,
                  let password = self.passwordTextField.text
            else { return }
        
            var decodeText = ""
            
            DataService().fetchUserbyUserEmail(userEmail: userEmail) { user, state, message  in
                
                if let userModel = user {
                    
                    decodeText = algorithm.decryptText(encryptedText: userModel.UserPassword, key: key)
                    
                    if password == decodeText {
                        
                        self.addIndicator()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                            guard let self = self else { return }
                            self.indicator.removeFromSuperview()
                            LocalDataBaseProcess().setDATA(value: "login", key: "isLogin")
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    } else {
                        
                        self.showErrorMessage(message: "Check your password and try entering it again.")
                        //Burada hata gösterimi yapılmalı kullanıcıya ilgi verilmeli. Buradaki olay şifreler eşleşmiyor.

                    }
                    
                    
                } else {
                    
                    self.showErrorMessage(message: "Please check your email and re-enter your email registered in the system.")
                    //Burada kullanıcı bulunamadığında bir uyarı gösterilmelidir.
                }
                
            }
            
        }
        
        if button == forgetPass {
            coordinator?.navigateForgetPassword()
        }
        
        if button == signUp {
            coordinator?.navigateSignUp()
        }
    
    }
    
    private func showErrorMessage(message: String) {
        
        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialLight))
        let alert = infoandOkeyActionViewComponent()
        
        view.addSubview(visualView)
        visualView.contentView.addSubview(alert)
        
        visualView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        alert.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-48)
            $0.height.equalTo(200)
        }
        
        alert.configure(viewModel: infoandOkeyActionViewComponent.ViewModel(
            image: .alertInformation,
            info: message,
            textAligment: .center,
            textColor: .black,
            font: .boldSystemFont(ofSize: 16),
            buttonTitle: "Okey",
            buttonTitleColor: .goodFood,
            cornerRadius: 20,
            backgroundColor: .white,
            action: { state in
                if state {
                    visualView.removeFromSuperview()
                }
            }
        ))

    }
    
}

