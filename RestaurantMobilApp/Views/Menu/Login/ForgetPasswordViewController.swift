//
//  ForgetPasswordViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 25.06.2024.
//

import UIKit
import SnapKit
import Lottie
import Then

class ForgetPasswordViewController: UIViewController {
    
    weak var coordinator: LoginCoordinatorProtocol?
    private let network: DataServiceProtocol
    var animationView: LottieAnimationView!
    var iterate = 0
    var userEmail = ""
    var userId = "0"
    var code = ""
    
    init(dataService: DataServiceProtocol) {
        self.network = dataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy private var indicator = customActivityIndicatorViewComponent()
    
    lazy private var info: UILabel = {
       let label = UILabel()
        label.text = "Please enter your email address registered in the system."
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
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
        tf.delegate = self
        return tf
    }()
 
    lazy private var send: UIButton = {
        let button = UIButton()
         button.setTitle("Send", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
         button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
         button.backgroundColor = .goodFood
         button.layer.cornerRadius = 15
         return button
    }()
    
    lazy private var errorMessage: UILabel = {
       let label = UILabel()
        label.text = "Please enter in email format"
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    
}

extension ForgetPasswordViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .themePrimary
        self.navigationItem.title = "Forget Password"
        view.addSubview(info)
        view.addSubview(email)
        view.addSubview(emailView)
        emailView.addSubview(emailTextField)
        view.addSubview(send)
        setupConstraints()
        setupAnimationView(name: "emailAnimation", isFinish: false)
    }
    
    private func setupConstraints() {
        info.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-60)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(214)
        }
        email.snp.makeConstraints{
            $0.top.equalTo(info.snp.bottom).offset(48)
            $0.height.equalTo(16)
            $0.leading.equalToSuperview().offset(32)
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
        send.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.leading.equalTo(emailView.snp.leading).offset(32)
            $0.trailing.equalTo(emailView.snp.trailing).offset(-32)
            $0.top.equalTo(emailView.snp.bottom).offset(48)
        }
    }
    
    private func setupAnimationView(name: String, isFinish: Bool) {
        
        if isFinish {
            animationView.stop()
            animationView.removeFromSuperview()
        }
        
        animationView = .init(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        animationView.play()
        
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
    
    private func showErrorMessage(state: Bool) {
        
        if state{
            
            view.addSubview(errorMessage)
            errorMessage.snp.makeConstraints{
                $0.leading.equalTo(emailView.snp.leading).offset(4)
                $0.top.equalTo(emailView.snp.bottom).offset(6)
            }
            
        } else {
            
            errorMessage.removeFromSuperview()
            
        }
        
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        if button == send {
            
            self.addIndicator()
            guard let text_field_value = emailTextField.text else { return }
            
            if iterate == 0 {
                
                network.fetchVerifyEmail(userEmail: text_field_value) { verifyCode, state, networkMessage in DispatchQueue.main.async{
                        
                        if verifyCode != "" && state { //Buraya girerse zaten bu şekilde bir kullanıcı vardır emaile kod gelir.
                            self.userEmail = text_field_value
                            let partial = verifyCode.split(separator: "-")
                            self.code = "\(partial[0])"
                            self.userId = "\(partial[1])"
                            self.indicator.removeFromSuperview()
                            self.changeView(iterate: 1)
                            self.iterate += 1
                            return
                            
                        } else {
                            
                            self.indicator.removeFromSuperview()
                            self.showErrorMessage(message: "No user was found matching the entered email address.")
                            
                        }
                    }
                }
            }
            
            if iterate == 1 { //Burada email adresine gelen kod doğrulanacak
                
                if text_field_value == code { //Burada kod onaylanır ikiside aynı
                    print("tf -> \(text_field_value), network -> \(code)")
                    self.indicator.removeFromSuperview()
                    self.changeView(iterate: 2)
                    self.iterate += 1
                    return
                    
                } else {
                    
                    self.indicator.removeFromSuperview()
                    self.showErrorMessage(message: "Verify code not invalid.")
                    self.emailTextField.text = ""
                    
                }
            }
            
            if iterate == 2 { //Burada yeni şifre belirleyecek kullanıcı yeni şifre alacağız
                
                //MARK: Burada güncelleme işlemi yapacağız zaten kullanıcının mail bilgisi var password değişecek onu güncelleyeceğiz.
                guard let userId = Int(self.userId) else { return }
                let encyrpt = EncodedDataAlgorithms().encryptText(text: text_field_value, key: EncyrptKEY.default)
                
                network.updateUser(userPutDto: UserPutDto(
                    userId: userId,
                    userFullName: nil,
                    userEmail: nil,
                    userPhoto: nil,
                    isActive: nil,
                    userPassword: encyrpt)) { userData, state, networkMessage in DispatchQueue.main.async{
                        
                        //MARK: Burada userData' dan kullanıcıya ait veriler geliyor istenirse kullanılabilir.
                        
                        if state {
                            
                            self.indicator.removeFromSuperview()
                            self.changeView(iterate: 3)
                            self.iterate += 1
                            return
                            
                        } else {
                            
                            self.indicator.removeFromSuperview()
                            self.showErrorMessage(message: "Password not updated, please try again")
                            self.emailTextField.text = ""
                            
                        }
                    }
                }
            }
            
            if iterate == 3 {
                self.changeView(iterate: 4)
            }
            
        }
        
    }
    
    
    private func changeView(iterate: Int) {
        
        if iterate == 1 {
            UIView.animate(withDuration: 0.3) {
                self.setupAnimationView(name: "verificationAnimationView", isFinish: true)
                self.info.text = "Enter your verification code sent to your email account."
                self.email.text = "Verification Code"
                self.emailTextField.text = ""
                self.emailTextField.placeholder = "Enter verification Code"
                self.emailTextField.keyboardType = .numberPad
                self.emailTextField.isSecureTextEntry = true
                self.send.setTitle("Verify", for: .normal)
            }
        }
        
        if iterate == 2 {
            UIView.animate(withDuration: 0.3) {
                self.setupAnimationView(name: "securityAnimationView", isFinish: true)
                self.info.text = "Enter your new password."
                self.email.text = "Password"
                self.emailTextField.text = ""
                self.emailTextField.placeholder = "Enter new password"
                self.emailTextField.keyboardType = .alphabet
                self.send.setTitle("Create", for: .normal)
            }
        }
        
        if iterate == 3 {
            UIView.animate(withDuration: 0.3) {
                self.setupAnimationView(name: "successAnimationView", isFinish: true)
                self.animationView.snp.removeConstraints()
                self.animationView.snp.makeConstraints{
                    $0.centerX.equalToSuperview()
                    $0.centerY.equalToSuperview().offset(-60)
                    $0.width.height.equalTo(150)
                }
                self.info.snp.removeConstraints()
                self.info.snp.makeConstraints{
                    $0.leading.equalTo(self.animationView.snp.leading).offset(-16)
                    $0.trailing.equalTo(self.animationView.snp.trailing).offset(16)
                    $0.top.equalTo(self.animationView.snp.bottom).offset(12)
                }
                self.info.text = "Password has been updated successfully."
                self.email.removeFromSuperview()
                self.emailView.removeFromSuperview()
                self.send.setTitle("Go to Login", for: .normal)
                self.send.snp.removeConstraints()
                self.send.snp.makeConstraints{
                    $0.height.equalTo(50)
                    $0.width.equalTo(250)
                    $0.centerX.equalToSuperview()
                    $0.top.equalTo(self.info.snp.bottom).offset(48)
                }
            }
        }
        
        if iterate == 4 {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}

extension ForgetPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        
        if textField.keyboardType == .numberPad {
            if updatedText.count == 7 {
                return false
            }
        }
    
                
        if textField.keyboardType == .default && !updatedText.contains("@") && updatedText != "" {
            
            //Burada validation error gösterilecek
            
            showErrorMessage(state: true)
            return true
        }
        
        //Burada validation error silinecek
        
        showErrorMessage(state: false)
        return true
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

