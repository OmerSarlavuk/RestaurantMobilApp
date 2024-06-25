//
//  ForgetPasswordViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 25.06.2024.
//

import UIKit
import SnapKit
import Lottie
import Then

class ForgetPasswordViewController: UIViewController {
    
    weak var coordinator: LoginCoordinatorProtocol?
    var animationView: LottieAnimationView!
    var timer: Timer?
    var totalTimeInSeconds = 180
    
    lazy private var info: UILabel = {
       let label = UILabel()
        label.text = "Please enter your email address registered in the system."
        label.font = .systemFont(ofSize: 16)
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
        return tf
    }()
 
//    lazy private var time = UILabel().then{$0.text = "remaining time:"; $0.textColor = .goodFood; $0.font = .boldSystemFont(ofSize: 14)}
//    lazy private var sayac = UILabel().then{$0.text = "180" ; $0.textColor = .black; $0.font = .boldSystemFont(ofSize: 18)}
    
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
        setupConstraints()
        setupAnimationView()
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
    }
    
    private func setupAnimationView() {
        
        animationView = .init(name: "emailAnimation")
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
    
//    func startTimer() {
//           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//    }
//       @objc func updateTimer() {
//           guard totalTimeInSeconds > 0 else {
//               timer?.invalidate()
//               return
//           }
//           totalTimeInSeconds -= 1
//           sayac.text = "\(totalTimeInSeconds)"
//           
//           
//          
//       }
    
}


