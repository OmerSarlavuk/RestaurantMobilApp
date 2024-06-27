//
//  BasketViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 26.06.2024.
//

import UIKit
import SnapKit
import UIView_Shimmer
import Then

class BasketViewController: UIViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    var meals = [FavoriteDto]()
    
    lazy private var indicator = customActivityIndicatorViewComponent()
    
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
    
    lazy private var tabView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var siparis: UIButton = {
       let button = UIButton()
        button.setTitle("choose a table and order →", for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        button.setTitleColor(.iconandIdentifierViewComponentColor1, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.primaryThemeandText.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy private var total: UILabel = {
       let label = UILabel()
        label.text = "• Get Membersip\n• Select Table\n•Choose Order\n•Orders delivered to your table"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
}

extension BasketViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isLoading = true
        addIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoading = false
            self.indicator.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        self.navigationItem.title = "My Basket"
        fetchData()
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
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(tabView)
        tabView.addSubview(siparis)
        tabView.addSubview(total)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            $0.bottom.equalTo(tabView.snp.top)
        }
        tabView.snp.makeConstraints{
            $0.trailing.leading.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        siparis.snp.makeConstraints{
            $0.height.equalTo(55)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(200)
        }
        total.snp.makeConstraints{
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(siparis.snp.leading).offset(-4)
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
                        
                        let check = local.getDATA(key: "\($0.strMeal)basket")
                        
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
        cell.delegate = self
        cell.index = indexPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meal = self.meals[indexPath.row]
        
        let alert = UIAlertController(title: "Detail", message: "Do you want to go detail?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go", style: .destructive, handler: { _ in
            self.coordinator?.navigateCategoryMeal(categoryMealDto:
                                                CategoryMealDto(mealName: meal.mealName,
                                                                mealId: meal.mealId,
                                                                mealURL: meal.imageURL))
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension BasketViewController: sendValue {

    func send(indexPath: IndexPath, mealName: String) {
        let alert = UIAlertController(title: "Remove Meal", message: "Do you want to remove this meal from your basket?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            LocalDataBaseProcess().removeDATA(key: "\(mealName)basket")
            LocalDataBaseProcess().removeDATA(key: "\(mealName)piece")
            self.meals.remove(at: indexPath.row)
            self.collectionView.reloadData()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func addNote() {
        
        let alert = UIAlertController(title: "Add Note", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your note here"
            textField.font = UIFont.systemFont(ofSize: 18)
            textField.textColor = .black
            textField.borderStyle = .roundedRect
            textField.textAlignment = .left
            textField.contentVerticalAlignment = .top
            textField.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            if let textField = alert?.textFields?.first {
                let noteText = textField.text
                print("note -> \(noteText!)")
            }
        }
        
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func didButtonTapped() { coordinator?.navigateBasketSubscription() }

}


