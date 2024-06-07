//
//  CategoryMealViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 4.06.2024.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import UIView_Shimmer

class CategoryMealViewController: UIViewController {
    
    weak var coordinator: FirstViewCoordinatorProtocol?
    var categoryMealDto: CategoryMealDto?
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryMealTopCell.self, forCellWithReuseIdentifier: CategoryMealTopCell.key)
        collectionView.register(CategoryMealDetailCell.self, forCellWithReuseIdentifier: CategoryMealDetailCell.key)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clearLightGray
        return collectionView
    }()
    
    lazy private var tabbarView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy private var titleYoutubeandWebsite = UILabel().then{
        $0.text = "Youtube & Website"
        $0.textColor = .iconandIdentifierViewComponentColor2
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    
    lazy private var youtubeButton: UIButton = {
       let button = UIButton()
        button.setImage(.youtube, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var websiteButton: UIButton = {
       let button = UIButton()
        button.setImage(.chrome, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private var isLoading = true {
        didSet {
            collectionView.isUserInteractionEnabled = !isLoading
            collectionView.reloadData()
        }
    }
    
}

extension CategoryMealViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isLoading = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(tabbarView)
        tabbarView.addSubview(titleYoutubeandWebsite)
        tabbarView.addSubview(youtubeButton)
        tabbarView.addSubview(websiteButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(view.frame.width - 150))
        }
        tabbarView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        titleYoutubeandWebsite.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        youtubeButton.snp.makeConstraints{
            $0.width.height.equalTo(36)
            $0.trailing.equalTo(websiteButton.snp.leading).offset(-16)
            $0.centerY.equalTo(titleYoutubeandWebsite.snp.centerY)
        }
        websiteButton.snp.makeConstraints{
            $0.width.height.equalTo(36)
            $0.centerY.equalTo(titleYoutubeandWebsite.snp.centerY)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func fetchMealDetail(completion: @escaping ((MealDetailViewModel.MealDetailClearModel) -> Void)) {
        guard let dto = categoryMealDto else { return }
        self.navigationItem.title = dto.mealName
        let dataService = DataService()
        let viewModel   = MealDetailViewModel(dataService: dataService)
        viewModel.fetchMealDetail(idMeal: dto.mealId) { mealDetail in
            completion(mealDetail)
        }
    }
    
}

extension CategoryMealViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryMealTopCell.key, for: indexPath) as! CategoryMealTopCell
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
            if let url = self.categoryMealDto?.mealURL {
                let url = URL(string: url)
                cell.mealImage.kf.setImage(with: url)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryMealDetailCell.key, for: indexPath) as! CategoryMealDetailCell
            cell.ingredientsProtocol = self
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
            fetchMealDetail { detail in
                var innerIngredients: String = ""
                for number in 1...detail.strIngredients.count {
                    innerIngredients += "• \(detail.strIngredients[number - 1])\n"
                }
                
                cell.configure(viewModel: CategoryMealDetailCell.ViewModel(
                    strIngredients: innerIngredients,
                    font: .systemFont(ofSize: 14, weight: .semibold),
                    textColor: .black,
                    textAligment: .natural,
                    youtubeURL: detail.strYoutube,
                    websiteURL: detail.strSource))
            }
            return cell
        }
    
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            return CGSize(width: view.frame.width, height: view.frame.width)
            
        default:
            return CGSize(width: view.frame.width - 80, height: view.frame.width)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
            
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        default:
            return UIEdgeInsets(top: -20, left: 0, bottom: 15, right: 0)
            
        }
        
    }
    
}

extension CategoryMealViewController: IngredientsHeight{
    
    func heightValue(height: CGFloat) {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
        
        collectionView.performBatchUpdates({
            let indexPath = IndexPath(item: 0, section: 1)
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryMealDetailCell {
                cell.frame.size = CGSize(width: view.frame.width - 80, height: height + 50)
            }
        }, completion: nil)
    }
    
}

extension CategoryMealViewController {
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
//        guard let linkURLs = urls else { return }
//        
//        if button == youtubeButton {
//             
//            let youtube = linkURLs.0
//            
//            if let youtubeURL = URL(string: youtube), UIApplication.shared.canOpenURL(youtubeURL) {
//                        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
//                    } else {
//                        debugPrint("Geçerli bir YouTube URL'si değil veya cihaz YouTube'u açamıyor.")
//                    }
//            
//        }
//        
//        if button == websiteButton {
//            
//            let website = linkURLs.1
//            
//            if let websiteURL = URL(string: website), UIApplication.shared.canOpenURL(websiteURL) {
//            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
//            } else {
//                debugPrint("Geçerli bir Chrome URL'si değil veya cihaz Chrome'u açamıyor.")
//            }
//            
//        }
//        
    }
    
}

/***
    Burada collection view den ayrılan yere kullanıcıların favorileme görüntülenmesi oranı verlecek ayrıca bir buton tarzı bir şey eklenip nasıl yapıldığı adım adım farklı bir sayfada gösterilecek buna ek olarak bir yapay zeka robotu da eklenebiliecek.
 
    Örneğin malzeme girilerek kaç kişilik servis vs çıkacağı şeklinde
 
***/


