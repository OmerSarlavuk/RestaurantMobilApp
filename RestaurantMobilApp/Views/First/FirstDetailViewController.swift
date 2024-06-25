//
//  FirstDetailViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 31.05.2024.
//

import UIKit
import SnapKit
import Then
import UIView_Shimmer


class FirstDetailViewController: UIViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    var meals = [Meal]()
    private var filteredCategories = [Meal]()
    var firstDetailDto: FirstDetailDto?

//    lazy private var searchBar: UISearchBar = {
//       let sb = UISearchBar()
//        sb.delegate = self
//        return sb
//    }()
    
    lazy private var searchController = UISearchController(searchResultsController: nil)
    
    lazy private var clear: UIButton = {
       let button = UIButton()
        button.setImage(.clearAll, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        collectionView.register(MealCategoryCell.self, forCellWithReuseIdentifier: MealCategoryCell.instance)
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

extension FirstDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isLoading = true
        
        guard let dto = self.firstDetailDto else { return }
        self.navigationItem.title = "\(dto.categoryName)"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationItem.searchController?.isActive = true
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
        setupConstraints()
        setupSearchController()
        self.fetchMeals()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    
    public func fetchMeals() {
        guard let dto = self.firstDetailDto else { return }
        let dataService = DataService()
        let dataViewModel = MealViewModel(dataService: dataService)
        dataViewModel.fetchMeals(category: dto.categoryName) { meals in
            self.meals = meals
            self.filteredCategories = meals
            self.collectionView.reloadData()
        }
    }
    
    private func setupSearchController() {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Meals"
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
            definesPresentationContext = true
        }
    
    private func noData() {
          
        view.addSubview(icon)
        view.addSubview(error)
        
        icon.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview().offset(-100)
            $0.centerY.equalToSuperview().offset(200)
            
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
    
    @objc private func didButtonTapped() {
        self.fetchMeals()
        collectionView.reloadData()
//        searchBar.text = ""
        clear.removeFromSuperview()
    }
    
}

extension FirstDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meal = self.filteredCategories[indexPath.row]
        
        switch indexPath.section {
            
        case 1:
            coordinator?.navigateCategoryMeal(categoryMealDto:
                                                CategoryMealDto(mealName: meal.strMeal,
                                                                mealId: meal.idMeal,
                                                                mealURL: meal.strMealThumb)
            )
        default:
            print("not 1")
            
        }
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
        case 1:
            
            if filteredCategories.isEmpty {
                self.noData()
                return 0
            } else {
                self.hideNoData()
                return self.filteredCategories.count
            }
            
        default:
            return -1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        switch indexPath.section {
            
        case 0:
            guard let dto = self.firstDetailDto else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCategoryCell.instance, for: indexPath) as! MealCategoryCell
            cell.configure(viewModel: MealCategoryCell.ViewModel(image: dto.imageURL, identifier: dto.categoryDescription))
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.key, for: indexPath) as! MealCell
            let meal = self.filteredCategories[indexPath.row]
            cell.configure(viewModel: MealCell.ViewModel(image: meal.strMealThumb, effect: UIBlurEffect(style: .regular), title: meal.strMeal, font: .boldSystemFont(ofSize: 16), textColor: .black, textAligment: .center))
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.key, for: indexPath) as! MealCell
            let meal = self.filteredCategories[indexPath.item - 2]
            cell.configure(viewModel: MealCell.ViewModel(image: meal.strMealThumb, effect: UIBlurEffect(style: .regular), title: meal.strMeal, font: .boldSystemFont(ofSize: 16), textColor: .black, textAligment: .center))
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            return CGSize(width: view.frame.width, height: 400)
        default:
            return CGSize(width: (view.frame.width - 100) / 2, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 1 {
            return UIEdgeInsets(top: 20, left: 36, bottom: 20, right: 36)
        }
    
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            let offset = scrollView.contentOffset.y
//        if offset > view.frame.width - 65 {
//                UIView.animate(withDuration: 0.3) {
//                    self.view.addSubview(self.searchBar)
//                    self.searchBar.snp.makeConstraints{
//                        $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
//                        $0.leading.equalToSuperview().offset(16)
//                        $0.trailing.equalToSuperview().offset(-16)
//                        $0.height.equalTo(45)
//                    }
//                    self.searchBar.alpha = 1
//                }
//            } else {
//                UIView.animate(withDuration: 0.3) {
//                    self.searchBar.alpha = 0
//                    self.searchBar.removeFromSuperview()
//                }
//            }
//        }
    
}

//extension FirstDetailViewController : UISearchBarDelegate {
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    
//        self.navigationController?.navigationBar.addSubview(self.clear)
//        clear.snp.makeConstraints{
//            $0.width.height.equalTo(44)
//            $0.trailing.equalToSuperview().offset(-16)
//            $0.centerY.equalToSuperview()
//        }
//        
//        
//        filteredCategories = meals.filter { meal in
//            return meal.strMeal.lowercased().contains(searchText.lowercased())
//        }
//        
//        collectionView.reloadData()
//        
//        if searchText.isEmpty {
//            self.fetchMeals()
//            collectionView.reloadData()
//        }
//        
//    }
//    
//}

extension FirstDetailViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        // Arama işlemi burada yapılacak
        
        
        filteredCategories = meals.filter { meal in
            return meal.strMeal.lowercased().contains(searchText.lowercased())
        }
        
        collectionView.reloadData()
        
        if searchText.isEmpty {
            self.fetchMeals()
            collectionView.reloadData()
        }
        
    }
}


