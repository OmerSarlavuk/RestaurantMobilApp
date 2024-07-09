//
//  AboutViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 10.06.2024.
//

import UIKit
import SnapKit
import Then


class AboutViewController: UIViewController {
    
    
    weak var coordinator: MainCoordinatorProtocol?
    
    
    lazy private var logo: UIImageView = {
       let view = UIImageView()
        view.image = .goodFood
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy private var scrollView = UIScrollView().then{
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy private var contentView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy private var scrollContent = UILabel().then{
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.text = """
        Good Food has been the home cooks’ choice for over 35 years. It’s the UK’s most popular food media brand with goodfood.com reaching over 50 million users.

        Good Food is proud owner of the UK’s number one food website; a brilliant app, the UK's market-leading food magazine and digital edition; the UK’s largest food event – Good Food Show – and a hugely successful series of cookbooks. You can also learn with us and enjoy storytelling and recipes in our podcasts.

        Every recipe published by Good Food is thoroughly tested by the recipe development team. The brand offers more than just trusted recipe content; Good Food is the go-to destination for everything to do with food including health, meal planning, smart budgeting, family, drinks and reviews. Whether you’re looking for healthy recipes, how-to cook advice, kitchen gadget reviews, easy family recipes, budget meal plans and shopping lists, the latest foodie travel inspiration or the perfect recipe for dinner tonight, we’re here to help.i
        """
    }

    lazy private var stackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 36
        $0.addArrangedSubview(instagram)
        $0.addArrangedSubview(twitter)
        $0.addArrangedSubview(facebook)
        $0.addArrangedSubview(tiktok)
        $0.addArrangedSubview(pinterest)
    }
    
    lazy private var instagram = UIButton().then{
        $0.setImage(.instagram, for: .normal)
        $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        $0.tag = 0
    }
    
    lazy private var facebook = UIButton().then{
        $0.setImage(.facebook, for: .normal)
        $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        $0.tag = 2
    }
    
    lazy private var twitter = UIButton().then{
        $0.setImage(.twitter, for: .normal)
        $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        $0.tag = 1
    }
    
    lazy private var tiktok = UIButton().then{
        $0.setImage(.tiktok, for: .normal)
        $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        $0.tag = 3
    }
    
    lazy private var pinterest = UIButton().then{
        $0.setImage(.pinterest, for: .normal)
        $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        $0.tag = 4
    }
    
    lazy private var bottomText = UILabel().then{
        $0.text = "© Immediate Media Company Ltd. 2024"
        $0.font = .systemFont(ofSize: 12)
    }
    
}


extension AboutViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .themePrimary
        self.navigationItem.title = "About"
        view.addSubview(logo)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(scrollContent)
        view.addSubview(stackView)
        view.addSubview(bottomText)
        setupConstraints()
    }
    
    private func setupConstraints() {
        logo.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(65)
        }
        scrollView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(logo.snp.bottom).offset(24)
            $0.bottom.equalTo(stackView.snp.top).offset(-16)
        }
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        scrollContent.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(bottomText.snp.top).offset(-12)
            $0.height.equalTo(44)
        }
        bottomText.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        var website = ""
        
        let urls = [
            "https://www.instagram.com/goodfoodeveryday/",
            "https://x.com/BBCgoodfood",
            "https://www.facebook.com/goodfoodeveryday/",
            "https://www.tiktok.com/@goodfood?lang=en",
            "https://www.pinterest.co.uk/goodfood/"
        ]
        
        
        switch button.tag {
            
        case 0:
            website = urls[0]
        case 1:
            website = urls[1]
        case 2:
            website = urls[2]
        case 3:
            website = urls[3]
        case 4:
            website = urls[4]
        default:
            print("tag!!")
        }
        
        
        if let websiteURL = URL(string: website), UIApplication.shared.canOpenURL(websiteURL) {
        UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
        } else {
            debugPrint("Geçerli bir Chrome URL'si değil veya cihaz Chrome'u açamıyor.")
        }
        
    }
    
}



