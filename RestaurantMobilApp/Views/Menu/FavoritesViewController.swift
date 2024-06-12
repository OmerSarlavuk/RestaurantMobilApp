//
//  FavoritesViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit
import Then


class FavoritesViewController: UIViewController {
    
    
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
    
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: MealCell.key)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var isLoading = true {
        didSet {
            collectionView.isUserInteractionEnabled = !isLoading
            collectionView.reloadData()
        }
    }
    
}


extension FavoritesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        self.navigationItem.title = "Favorites"
        isLoading = true
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func hideNoData() {
        self.icon.removeFromSuperview()
        self.error.removeFromSuperview()
    }
    
    
    private func noData() {
          
        view.addSubview(icon)
        view.addSubview(error)
        
        icon.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview().offset(-100)
            $0.centerY.equalToSuperview().offset(-200)
            
        }
        error.snp.makeConstraints{
            $0.leading.equalTo(icon.snp.trailing).offset(10)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
    }
    
    func fetchData() {
        
        let dataService = DataService()
        let local = LocalDataBaseProcess()
        
        dataService.fetchCategoryNames { categoryNames in
            
            categoryNames.forEach{
                dataService.fetchMeals(category: $0.strCategory) { meals in
                    
                    meals.forEach{
                        
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

extension FavoritesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.key, for: indexPath) as! MealCell
        let meal = self.meals[indexPath.row]
        cell.configure(viewModel: MealCell.ViewModel(image: meal.imageURL, effect: UIBlurEffect(style: .regular), title:meal.mealName, font: .boldSystemFont(ofSize: 16), textColor: .black, textAligment: .center))
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        return CGSize(width: (view.frame.width - 100) / 2, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 36, bottom: 20, right: 36)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = self.meals[indexPath.row]
        
        coordinator?.navigateCategoryMeal(categoryMealDto:
                                            CategoryMealDto(mealName: meal.mealName,
                                                            mealId: meal.mealId,
                                                            mealURL: meal.imageURL))
                                          
    }

}


