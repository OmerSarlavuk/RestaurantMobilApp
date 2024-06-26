//
//  BasketViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 26.06.2024.
//

import UIKit
import SnapKit
import UIView_Shimmer

class BasketViewController: UIViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    var meals = [FavoriteDto]()
    
    lazy private var icon = UIImageView().then{
        $0.image = .noData
    }
    
    
    lazy private var error = UILabel().then{
        $0.text = .StringContentinLocalizable.noData.localised
        $0.font = .systemFont(ofSize: 22)
        $0.textColor = .menuItemTitle
    }
    
    private var isLoading = true {
        didSet {
            collectionView.isUserInteractionEnabled = !isLoading
            collectionView.reloadData()
        }
    }
    
    lazy private var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.register(BasketItemCell.self, forCellWithReuseIdentifier: BasketItemCell.key)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator   = false
            collectionView.delegate = self
            collectionView.dataSource = self
            return collectionView
    }()
    
}

extension BasketViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isLoading = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoading = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        self.navigationItem.title = "My Basket"
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func noData() {
          
        view.addSubview(icon)
        view.addSubview(error)
        
        icon.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.centerX.equalToSuperview().offset(-90)
        }
        error.snp.makeConstraints{
            $0.leading.equalTo(icon.snp.trailing).offset(10)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
    }
    
    private func hideNoData() {
        self.icon.removeFromSuperview()
        self.error.removeFromSuperview()
    }
    
    
    func fetchData() {
        self.meals.removeAll()
        
        let dataService = DataService()
        let local = LocalDataBaseProcess()
        
        dataService.fetchCategoryNames { categoryNames in
            
            categoryNames.forEach{
                dataService.fetchMeals(category: $0.strCategory) { meals in
                    
                    meals.forEach{
                        
                        
                        //Bura güncellenecek burası addedBaskette eklenen keylere göre çekeceğiz.
                        //Ona göre de gelen veriyi parçalayacağız.
                        //Mesela "\($0.strMeal)basket" gibi orada atadığımız keye göre çekeceğiz
                        //Gelecek olan veri içerisinde imageURL ve mealName lazım sadece
                        
                        let check = local.getDATA(key: $0.strMeal)
                        
                        if !check.isEmpty {
                            
                            let partial = check.split(separator: "\r\n")
                            
                            let imageURL = partial[0]
                            let mealName = partial[1]
                            let mealId   = partial[2]
                            
                            self.meals.append(FavoriteDto(mealId: "\(mealId)", imageURL: "\(imageURL)", mealName: "\(mealName)"))
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        
        collectionView.reloadData()
        
    }
    
}

extension BasketViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
            
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            if meals.isEmpty {
                self.noData()
                return 0
            } else {
                self.hideNoData()
                return self.meals.count
            }
        
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketItemCell.key, for: indexPath) as! BasketItemCell
            let meal = meals[indexPath.row]
            cell.configure(viewModel: BasketItemCell.ViewModel(
                image: meal.imageURL,
                mealName: meal.mealName)
            )
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
            return UICollectionViewCell()
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtindexPath: IndexPath) -> CGSize {
            return CGSize(width: 360, height: 120)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
}


