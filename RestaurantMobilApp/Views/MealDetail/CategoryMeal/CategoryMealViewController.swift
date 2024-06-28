//
//  CategoryMealViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 4.06.2024.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import UIView_Shimmer
import PDFKit

class CategoryMealViewController: UIViewController {
    
    var coordinator: FirstDetailViewCoordinatorProtocol?
    var categoryMealDto: CategoryMealDto?
    var mealDetail: MealDetailViewModel.MealDetailClearModel?
    var ingredints = ""
    var instructions = ""
    var pdfData: Data!
    
    lazy private var pdfView = PDFView().then{ $0.autoScales = true }
    
    lazy private var indicator = customActivityIndicatorViewComponent()
    
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
    
    
    lazy private var favoriteRed: UIButton = {
       let button = UIButton()
        button.setImage(.favoriteRed, for: .normal)
        return button
    }()
    
    
    //number take a out. Ex -> Service
    
    lazy private var favoriteText: UILabel = {
       let label = UILabel()
        label.text = "24 people favorited it"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy private var ingredients: UIButton = {
       let button = UIButton()
        button.setTitle("Instructions →", for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        button.setTitleColor(.iconandIdentifierViewComponentColor1, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.primaryThemeandText.cgColor
        return button
    }()
    
    lazy private var addedBasket: UIButton = {
       let button = UIButton()
        button.setTitle("Add to Basket +", for: .normal)
        button.setTitle("Remove to basket -", for: .selected)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        button.setTitleColor(.iconandIdentifierViewComponentColor1, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.primaryThemeandText.cgColor
        return button
    }()
    
    lazy private var caloriImage = UIImageView().then{
        $0.image = .checkList
    }
    
    lazy private var caloriText = UILabel().then{
        $0.text = "Nutrition per Serving"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .darkGray
    }

    //Bu 4 component servisten beslenecek şimdilik burada configure edildi ancak ileride bu vc de bir configure methodu yazılıp her bir configure onun içinde yapılabilir.
    
    lazy private var stackGeneralView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy private var componentsStackView: UIStackView = {
        let sw = UIStackView()
        sw.distribution = .fillEqually
        sw.axis = .horizontal
        sw.addArrangedSubview(titleAndValueComponent1)
        sw.addArrangedSubview(titleAndValueComponent2)
        sw.addArrangedSubview(titleAndValueComponent3)
        sw.addArrangedSubview(titleAndValueComponent4)
        return sw
    }()
    
    lazy private var titleAndValueComponent1: TitleandValueViewComponent = {
       let comp = TitleandValueViewComponent()
        comp.configure(viewModel: TitleandValueViewComponent.ViewModel(title: "CALORIES", titleFont: .boldSystemFont(ofSize: 12), titleTextColor: .iconandIdentifierViewComponentColor1, titleTextAligment: .left, value: "155 kcal", valueFont: .systemFont(ofSize: 12), valueTextColor: .darkGray, valueTextAligment: .left))
        return comp
    }()
    
    lazy private var titleAndValueComponent2: TitleandValueViewComponent = {
       let comp = TitleandValueViewComponent()
        comp.configure(viewModel: TitleandValueViewComponent.ViewModel(title: "CARBS", titleFont: .boldSystemFont(ofSize: 12), titleTextColor: .iconandIdentifierViewComponentColor1, titleTextAligment: .left, value: "16 g", valueFont: .systemFont(ofSize: 12), valueTextColor: .darkGray, valueTextAligment: .left))
        return comp
    }()
    
    lazy private var titleAndValueComponent3: TitleandValueViewComponent = {
       let comp = TitleandValueViewComponent()
        comp.configure(viewModel: TitleandValueViewComponent.ViewModel(title: "FAT", titleFont: .boldSystemFont(ofSize: 12), titleTextColor: .iconandIdentifierViewComponentColor1, titleTextAligment: .left, value: "9 g", valueFont: .systemFont(ofSize: 12), valueTextColor: .darkGray, valueTextAligment: .left))
        return comp
    }()
    
    lazy private var titleAndValueComponent4: TitleandValueViewComponent = {
       let comp = TitleandValueViewComponent()
        comp.configure(viewModel: TitleandValueViewComponent.ViewModel(title: "PROTEIN", titleFont: .boldSystemFont(ofSize: 12), titleTextColor: .iconandIdentifierViewComponentColor1, titleTextAligment: .left, value: "4 g", valueFont: .systemFont(ofSize: 12), valueTextColor: .darkGray, valueTextAligment: .left))
        return comp
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
        isLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    
        isLogin()
    }
    
    private func addIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints{
            $0.leading.equalTo(addedBasket.snp.trailing).offset(2)
            $0.centerY.equalTo(addedBasket.snp.centerY)
            $0.width.height.equalTo(24)
        }
        indicator.startAnimation()
    }
    
    private func isLogin() {
        
        guard let dto = categoryMealDto else { return }
        
        let value = LocalDataBaseProcess().getDATA(key: "isLogin")
        
        if value == "login" {
            
            let check = LocalDataBaseProcess().getDATA(key: "\(dto.mealName)basket")
            
            addedBasket.isSelected = !check.isEmpty ? true : false
            
            view.addSubview(addedBasket)
            addedBasket.snp.makeConstraints{
                $0.height.equalTo(40)
                $0.leading.equalTo(caloriText.snp.trailing).offset(16)
                $0.trailing.equalTo(ingredients.snp.trailing).offset(-16)
                $0.top.equalTo(ingredients.snp.bottom).offset(10)
            }
            
        }
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(tabbarView)
        view.addSubview(favoriteRed)
        view.addSubview(favoriteText)
        view.addSubview(ingredients)
        view.addSubview(caloriImage)
        view.addSubview(caloriText)
        view.addSubview(stackGeneralView)
        stackGeneralView.addSubview(componentsStackView)
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
        favoriteRed.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(ingredients.snp.centerY)
            $0.leading.equalToSuperview().offset(24)
        }
        favoriteText.snp.makeConstraints{
            $0.leading.equalTo(favoriteRed.snp.trailing).offset(8)
            $0.centerY.equalTo(favoriteRed.snp.centerY)
            $0.trailing.equalTo(ingredients.snp.leading).offset(-16)
        }
        ingredients.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.height.equalTo(50)
            $0.width.equalTo(200)
        }
        caloriImage.snp.makeConstraints{
            $0.leading.equalTo(favoriteRed.snp.leading)
            $0.top.equalTo(ingredients.snp.bottom).offset(16)
        }
        caloriText.snp.makeConstraints{
            $0.leading.equalTo(caloriImage.snp.trailing).offset(10)
            $0.centerY.equalTo(caloriImage.snp.centerY)
        }
        stackGeneralView.snp.makeConstraints{
            $0.leading.equalTo(caloriImage.snp.leading)
            $0.trailing.equalTo(ingredients.snp.trailing)
            $0.top.equalTo(caloriImage.snp.bottom)
            $0.bottom.equalTo(tabbarView.snp.top)
        }
        componentsStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.trailing.equalToSuperview()
        }
        tabbarView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(85)
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
            self.mealDetail = mealDetail
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
            if let url = self.categoryMealDto?.mealURL,
               let mealName = self.categoryMealDto?.mealName,
               let mealId = self.categoryMealDto?.mealId{
                let urls = URL(string: url)
                cell.mealImage.kf.setImage(with: urls)
                cell.favoriteDto = FavoriteDto(mealId: mealId, imageURL: url, mealName: mealName)
            }
            cell.control()
            cell.delegate = self
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
                self.ingredints = innerIngredients
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
        
        guard let mealDetail = self.mealDetail else { return }
        
        if button == youtubeButton {
             
            let youtube =  mealDetail.strYoutube

            if let youtubeURL = URL(string: youtube), UIApplication.shared.canOpenURL(youtubeURL) {
                        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                    } else {
                        debugPrint("Geçerli bir YouTube URL'si değil veya cihaz YouTube'u açamıyor.")
                    }
            
        }
        
        if button == websiteButton {
            
            let website = mealDetail.strSource

            if let websiteURL = URL(string: website), UIApplication.shared.canOpenURL(websiteURL) {
            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
            } else {
                debugPrint("Geçerli bir Chrome URL'si değil veya cihaz Chrome'u açamıyor.")
            }
            
        }
        
        if button == ingredients {
            coordinator?.navigateCategoryMealIngredients(categoryMealIngredientsDto: CategoryMealIngredientsDto(strInstructions: mealDetail.strInstructions, youtubeURL: mealDetail.strYoutube))
        }
        
        if button == addedBasket {
            
            //ilk etapta false sonra true oluyor
            
            button.isSelected = !button.isSelected
            
            let local = LocalDataBaseProcess()
            guard let dto = self.categoryMealDto else { return }
            self.addIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.indicator.removeFromSuperview()
                if button.isSelected { //false iken
                    local.setDATA(value: "\(dto.mealURL)\r\n\(dto.mealName)\r\n\(dto.mealId)", key: "\(dto.mealName)basket")
                    local.setDATA(value: "1", key: "\(dto.mealName)piece")
                    //Burada baskete ekleme işlemi yapılacak ilgili öge zaten dolu ve seçili olacaktır.
                } else {
                    local.removeDATA(key: "\(dto.mealName)basket")
                    local.removeDATA(key: "\(dto.mealName)piece")
                }
            }
        
        }
    
    }

}

extension CategoryMealViewController: orderButton {
    
    func orderButtonTapped(dto: FavoriteDto) {
        
        let pdfCreator = PDFCreator()
        
        let url = URL(string: dto.imageURL)
        let view = UIImageView()
        view.kf.setImage(with: url)
        guard let img = view.image,
              let mealDetail = self.mealDetail
        else { return }
        
        let pdfData = pdfCreator.createPDF(
            logo: UIImage.restaurantLogo,
            title: dto.mealName,
            mainImage: img,
            firstParagraph: mealDetail.strInstructions,
            secondParagraph: self.ingredints
        )
        
        self.pdfData = pdfData
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(dto.mealName).pdf")
               do {
                   try pdfData.write(to: tempURL)
               } catch {
                   print("Could not save PDF file: \(error)")
                   return
               }
        
        let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        /*
         //MARK: İsteğe bağlı olarak PDF dosyası gösterilebilir.
         self.coordinator?.navigatePDF(dto: PDFFileDto(
             mealName: dto.mealName,
             mealImage: img,
             instructions: mealDetail.strInstructions,
             ingredients: self.ingredints
         ))
         */
        
    }
}

