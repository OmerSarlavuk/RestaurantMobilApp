//
//  BasketSubscriptionViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 27.06.2024.
//

import UIKit
import SnapKit
import Lottie
import Then

class BasketSubscriptionViewController: UIViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    var animationView: LottieAnimationView!
    
    lazy private var identifier: UILabel = {
        let label = UILabel()
        label.text = "Choose your subscription"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 44)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var optionsFirst = paymentOptionsViewComponent()
    lazy private var optionsSecond = paymentOptionsViewComponent()
    
    lazy private var why = UILabel().then{ $0.text = "Why Good Food?"; $0.textColor = .iconandIdentifierViewComponentColor1}
    
    lazy private var good = UILabel().then{$0.text = "✓\n✓\n✓\n✓"; $0.textColor = .iconandIdentifierViewComponentColor1; $0.numberOfLines = 0}
    
    let lines = [
        "artificial intelligence integrated",
        "fast and reliable",
        "user friendly",
        "comfortable and usable"
    ]
    
    let separator = "\n"
    
    lazy private var items: UILabel = {
            
        let combinedString = lines.joined(separator: separator)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // Burada satır aralığını ayarlayabilirsiniz

        let attributedString = NSAttributedString(
            string: combinedString,
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
    
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.attributedText = attributedString
        return label
    }()
    
}

extension BasketSubscriptionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .black
        self.navigationItem.title = "Subscription"
    }
    
    private func setupUI() {
        view.addSubview(identifier)
        view.addSubview(optionsFirst)
        view.addSubview(optionsSecond)
        view.addSubview(why)
        view.addSubview(good)
        view.addSubview(items)
        setupConstraints()
        setupAnimationView()
        configure()
    }
    
    private func setupConstraints() {
        identifier.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(145)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
        }
        optionsFirst.snp.makeConstraints{
            $0.leading.equalTo(identifier.snp.leading).offset(-24)
            $0.trailing.equalTo(identifier.snp.trailing).offset(24)
            $0.top.equalTo(identifier.snp.bottom).offset(24)
            $0.height.equalTo(75)
        }
        optionsSecond.snp.makeConstraints{
            $0.leading.equalTo(optionsFirst.snp.leading)
            $0.trailing.equalTo(optionsFirst.snp.trailing)
            $0.top.equalTo(optionsFirst.snp.bottom).offset(10)
            $0.height.equalTo(75)
        }
        why.snp.makeConstraints{
            $0.top.equalTo(optionsSecond.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        good.snp.makeConstraints{
            $0.top.equalTo(why.snp.bottom).offset(24)
            $0.leading.equalTo(why.snp.leading).offset(-48)
            $0.height.equalTo(100)
            $0.width.equalTo(16)
        }
        items.snp.makeConstraints{
            $0.leading.equalTo(why.snp.leading)
            $0.top.equalTo(good.snp.top)
            $0.bottom.equalTo(good.snp.bottom)
        }
    }
    
    private func setupAnimationView() {
        
        animationView = .init(name: "subscribeAnimationView")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        animationView.play()
        
    }
    
    private func configure() {
        
        optionsFirst.configure(viewModel: paymentOptionsViewComponent.ViewModel(
            time: "1 Month",
            fontS: .boldSystemFont(ofSize: 18),
            textColorS: .black,
            price: "$1.99",
            fontP: .boldSystemFont(ofSize: 18),
            textColorP: .black,
            discount: "3 day free trial",
            fontD: .systemFont(ofSize: 18),
            textColorD: .lightGray,
            componentRadius: 15,
            componentBackgroundColor: .tabbarLocationView
        ))
        
        optionsSecond.configure(viewModel: paymentOptionsViewComponent.ViewModel(
            time: "1 Year",
            fontS: .boldSystemFont(ofSize: 18),
            textColorS: .black,
            price: "$19.99",
            fontP: .boldSystemFont(ofSize: 18),
            textColorP: .black,
            discount: "Save 20%",
            fontD: .systemFont(ofSize: 18),
            textColorD: .lightGray,
            componentRadius: 15,
            componentBackgroundColor: .iconandIdentifierViewComponentColor1
        ))
    
    }
    
}


