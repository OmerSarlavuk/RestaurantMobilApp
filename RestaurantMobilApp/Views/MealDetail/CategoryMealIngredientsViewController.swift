//
//  CategoryMealIngredientsViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 10.06.2024.
//

import UIKit
import SnapKit
import WebKit
import Then

class CategoryMealIngredientsViewController: UIViewController {

    weak var coordinator: FirstDetailViewCoordinatorProtocol?
    var mealIngredientsDto: CategoryMealIngredientsDto?

    lazy private var webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()

    lazy private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    lazy private var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }

    lazy private var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    private func setupUI() {
        view.addSubview(webView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupConstraints()
    }

    private func setupConstraints() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(400)
        }
        scrollView.snp.makeConstraints {
            $0.leading.equalTo(webView.snp.leading)
            $0.trailing.equalTo(webView.snp.trailing)
            $0.top.equalTo(webView.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().offset(-24)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configure() {
        guard let dto = self.mealIngredientsDto else { return }

        view.backgroundColor = .themePrimary
        self.navigationItem.title = "Prepare Of"
        // MARK: webview youtube video load
        let url = URL(string: dto.youtubeURL)
        guard let ur = url else { return }
        webView.load(URLRequest(url: ur))

        let steps = dto.strInstructions.split(separator: "\r\n")

        for number in 1...steps.count {
            var comp = instructionsStepViewComponent()
            comp = self.sendComponent(viewModel: instructionsStepViewComponent.ViewModel(
                title: "Step \(number)",
                textColor: .black,
                font: .boldSystemFont(ofSize: 20),
                identifier: "\(steps[number - 1])",
                textColorI: .black,
                fontI: .systemFont(ofSize: 16),
                textAligment: .natural,
                handleTap: {
                    comp.change.isSelected = !comp.change.isSelected
                    comp.identifier.isHidden = !comp.identifier.isHidden
                    let additionalHeight = comp.getIdentifierHeight()
                    comp.snp.updateConstraints {
                        $0.height.equalTo(comp.change.isSelected ? (65 + additionalHeight) : 65)
                    }
                    UIView.animate(withDuration: 0.1) {
                        comp.layoutIfNeeded()
                    }
                })
            )
            comp.snp.makeConstraints {
                $0.height.equalTo(65)
            }
            stackView.addArrangedSubview(comp)
        }
    }

    private func sendComponent(viewModel: instructionsStepViewComponent.ViewModel) -> instructionsStepViewComponent {
        let comp = instructionsStepViewComponent()
        comp.configure(viewModel: viewModel)
        return comp
    }
}


