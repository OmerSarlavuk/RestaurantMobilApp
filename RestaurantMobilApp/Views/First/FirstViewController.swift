//
//  ViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit
import SnapKit
import Then
import UIView_Shimmer
import Kingfisher

class FirstViewController: UIViewController {

    weak var coordinator: MainCoordinatorProtocol?
    private var categories = [Category]()
    private var filteredCategories = [Category]()
    private var meals = [Meal]()
    
    
    lazy private var icon = UIImageView().then{
        $0.image = .noData
    }
    
    
    lazy private var error = UILabel().then{
        $0.text = .StringContentinLocalizable.noData.localised
        $0.font = .systemFont(ofSize: 22)
        $0.textColor = .menuItemTitle
    }
    
    lazy private var gesture: UITapGestureRecognizer = {
        let ges = UITapGestureRecognizer(target: self, action: #selector(parentViewTapped))
        ges.delegate = self
        return ges
    }()
    
    lazy private var parentView: UIVisualEffectView = {
        let ve = UIVisualEffectView()
        ve.effect = UIBlurEffect(style: .regular)
        ve.addGestureRecognizer(gesture)
        return ve
    }()
    
    
    lazy private var menuView = UIView().then{
        $0.backgroundColor = .white
    }

    let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.gray]
    
    lazy private var searchBar: UISearchBar = {
       let sb = UISearchBar()
        sb.delegate = self
        return sb
    }()
    
    lazy private var version: UILabel = {
       let label = UILabel()
        label.text      = .StringContentinLocalizable.versionNumber.localised
        label.font      = .boldSystemFont(ofSize: 10)
        label.textColor = .darkGray
        return label
    }()
    
    
    lazy private var item1: MenuItemViewComponent = {
       let item = MenuItemViewComponent()
        item.configure(viewModel: MenuItemViewComponent.ViewModel(icon: .reservation, title: .StringContentinLocalizable.menuReservation.localised, font: .systemFont(ofSize: 16), textColor: .menuItemTitle, handleTap: {
            self.coordinator?.navigateReservation()
        }))
        return item
    }()
    
    lazy private var item2: MenuItemViewComponent = {
       let item = MenuItemViewComponent()
        item.configure(viewModel: MenuItemViewComponent.ViewModel(icon: .location, title: .StringContentinLocalizable.menuLocation.localised, font: .systemFont(ofSize: 16), textColor: .menuItemTitle, handleTap: {
            self.coordinator?.navigateLocation()
        }))
        return item
    }()
    
    lazy private var item3: MenuItemViewComponent = {
       let item = MenuItemViewComponent()
        item.configure(viewModel: MenuItemViewComponent.ViewModel(icon: .photos, title: .StringContentinLocalizable.menuPhotos.localised, font: .systemFont(ofSize: 16), textColor: .menuItemTitle, handleTap: {
            self.coordinator?.navigatePhotos()
        }))
        return item
    }()
    
    lazy private var item4: MenuItemViewComponent = {
       let item = MenuItemViewComponent()
        item.configure(viewModel: MenuItemViewComponent.ViewModel(icon: .favorite, title: .StringContentinLocalizable.menuFavorites.localised, font: .systemFont(ofSize: 16), textColor: .menuItemTitle, handleTap: {
            self.coordinator?.navigateFavorite()
        }))
        return item
    }()
    
    lazy private var item5: MenuItemViewComponent = {
       let item = MenuItemViewComponent()
        item.configure(viewModel: MenuItemViewComponent.ViewModel(icon: .help, title: .StringContentinLocalizable.menuAbout.localised, font: .systemFont(ofSize: 16), textColor: .menuItemTitle, handleTap: {
            self.coordinator?.navigateAbout()
        }))
        return item
    }()
    
    lazy private var item6: MenuItemViewComponent = {
       let item = MenuItemViewComponent()
        item.configure(viewModel: MenuItemViewComponent.ViewModel(icon: .login, title: .StringContentinLocalizable.login.localised, font: .systemFont(ofSize: 16), textColor: .menuItemTitle, handleTap: {
            self.coordinator?.navigateLogin()
        }))
        return item
    }()
    
    lazy private var menuStackView: UIStackView = {
       let stack = UIStackView()
        stack.backgroundColor = .white
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 2
        stack.addArrangedSubview(item1)
        stack.addArrangedSubview(item2)
        stack.addArrangedSubview(item3)
        stack.addArrangedSubview(item4)
        stack.addArrangedSubview(item5)
        stack.addArrangedSubview(item6)
        return stack
    }()
    
    
    private func createMenuItem() -> MenuItemViewComponent {
        return MenuItemViewComponent()
    }
    
    lazy private var menu: UIButton = {
       let button = UIButton()
        button.setImage(.menu, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    lazy private var logo: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.image = .restaurantLogo
        return view
    }()
    
    lazy private var ai: UIButton = {
       let button = UIButton()
        button.setImage(.ai, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var horizontalLine = UIView().then{
        $0.backgroundColor = .lightGray
    }
    
    
    lazy private var languageOptions = LanguageSelectionsViewComponent()
 
    
    lazy private var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.instance)
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

extension FirstViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isLoading = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoading = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(menu)
        view.addSubview(searchBar)
        view.addSubview(ai)
        view.addSubview(horizontalLine)
        view.addSubview(collectionView)
        setupConstraints()
        fetchCategories()
        addPanGesture()
    }
    
    private func setupConstraints() {
        menu.snp.makeConstraints{
            $0.height.width.equalTo(44)
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.leading.equalToSuperview().offset(16)
        }
        searchBar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(menu.snp.trailing).offset(8)
            $0.trailing.equalTo(ai.snp.leading).offset(-16)
            $0.height.equalTo(45)
        }
        ai.snp.makeConstraints{
            $0.width.height.equalTo(44)
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        horizontalLine.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.top.equalTo(searchBar.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(horizontalLine.snp.bottom).offset(22)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        
        if button == menu {
            showMenu()
        }
        
        if button == ai {
            self.coordinator?.navigateAi()
        }
        
    }
    
    
    private func disableMenuViewInteraction() {
        parentView.removeGestureRecognizer(gesture)
    }

    private func enableMenuViewInteraction() {
        parentView.addGestureRecognizer(gesture)
    }
    
    private func fetchCategories() {
        let dataService = DataService()
        let dataViewModel = CategoryViewModel(dataService: dataService)
        dataViewModel.fetchCategories { categories in
            self.categories = categories
            self.filteredCategories = categories
            self.collectionView.reloadData()
        }
    }
    
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .ended {
            
            if translation.x > 0 {
                showMenu()
            } else {
                parentView.removeFromSuperview()
            }
        }
    }
    
    
    @objc private func parentViewTapped(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: parentView)
        if !menuView.frame.contains(touchLocation) {
            self.parentView.removeFromSuperview()
        }
    }

    
    private func noData() {
          
        view.addSubview(icon)
        view.addSubview(error)
        
        icon.snp.makeConstraints{
            $0.width.height.equalTo(50)
            $0.top.equalTo(horizontalLine.snp.bottom).offset(24)
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
    
    private func showMenu() {
        
        view.addSubview(parentView)
        parentView.contentView.addSubview(menuView)
        menuView.addSubview(logo)
        menuView.addSubview(menuStackView)
        menuView.addSubview(version)
        
        parentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        menuView.snp.makeConstraints{
            $0.bottom.top.leading.equalToSuperview()
            $0.width.equalTo(260)
        }
        logo.snp.makeConstraints{
            $0.width.height.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-250)
        }
        menuStackView.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(80)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(350)
        }
        version.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
}
extension FirstViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
            
    
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
                if filteredCategories.isEmpty {
                    self.noData()
                    return 0
                } else {
                    self.hideNoData()
                    return self.filteredCategories.count
                }
            
            }
        
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.instance, for: indexPath) as! CategoriesCell
                let category = filteredCategories[indexPath.row]
                cell.configure(viewModel: 
                                CategoriesCell.ViewModel(
                                    image: category.strCategoryThumb,
                                    categoryName: category.strCategory,
                                    identifier: category.strCategoryDescription
                ))
                cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
                return cell
            }

            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: 360, height: 120)
            }
    
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 10
            }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.filteredCategories[indexPath.row]
        
        languageOptions.removeFromSuperview()
        self.menuView.removeFromSuperview()
        self.view.endEditing(true)

        coordinator?.navigateFirstDetail(firstDetailDto: FirstDetailDto(
            categoryDescription: category.strCategoryDescription,
            imageURL: category.strCategoryThumb,
            categoryName: category.strCategory)
        )
        
    }
}
extension FirstViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCategories = categories.filter { category in
            return category.strCategory.lowercased().contains(searchText.lowercased())
        }
        
        collectionView.reloadData()
        
        
        if searchText.isEmpty {
            self.fetchCategories()
            collectionView.reloadData()
        }
    
        
    }
    
}

extension FirstViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
           let touchLocation = touch.location(in: parentView)
           if menuView.frame.contains(touchLocation) {
               return false
           }
           return true
       }
    
}


