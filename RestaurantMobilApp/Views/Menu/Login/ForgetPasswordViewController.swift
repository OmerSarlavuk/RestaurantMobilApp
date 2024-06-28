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
    var animationView: LottieAnimationView!
    var iterate = 0
    
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
        view.backgroundColor = .white
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
            
            iterate += 1
            
            guard let email = emailTextField.text else { return }
                
            //Burada email kontrolü yapılacak servis vs ile daha sonra eğer sistemde kayıtlı ise bu şekilde bir kullanıcı varsa ikinci adım olan doğrulama yerine geçilecek. Olayın işlenişi için biz şimdi burada bu şekilde bir kulllanıcı varmış ve geçilmiş gibi yapaağız.
            
            if iterate == 1 {
                
                addIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
                    self.indicator.removeFromSuperview()
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
                
            }
        
            if iterate == 2 {
                
                //Burada verify butonuna tıklanma gerçekleştiği durum ele alınacak.
                
                addIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
                    self.indicator.removeFromSuperview()
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
                
                
            }
            
            if iterate == 3 {
                print("password -> \(email)")
                
                addIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
                    self.indicator.removeFromSuperview()
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
                
            }
            
            if iterate == 4 {
                self.navigationController?.popViewController(animated: true)
            }
            
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
    
}


