//
//  ManageLocationViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/09/06.
//

import UIKit
import Combine
import PinLayout
import FlexLayout
import GoogleMobileAds

class ManageLocationViewController: BaseViewController {
    typealias VM = ManageLocationViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate var cellTemplate = ManageLocationCell()
    fileprivate lazy var bannerVC: BannerADViewController = BannerADViewController()
    
    fileprivate lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("add_location".localized(), for: .normal)
        button.backgroundColor = .primeColor2
        
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 1.4, height: 2) // 가로방향으로 1.4만큼 세로방향으로 2만큼 그림자가 이동
        button.layer.shadowRadius = 2
        
        button.flex.paddingVertical(6)
        button.flex.margin(8)
        
        return button
    }()
    
    lazy var deleteAll: UILabel = {
        var label = UILabel()
        label.font = .en12r
        label.text = "delete_all".localized()
        label.textColor = .gray
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClickDeleteAll)))
        return label
    }()

    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    var locations: [Location] = []
    var lottieVC: LottieVC = {
        let lottieVC = LottieVC(type: .progressing)
        lottieVC.modalPresentationStyle = .overFullScreen
        lottieVC.modalTransitionStyle = .crossDissolve
        lottieVC.view.backgroundColor = .clear
        return lottieVC
    }()
    
    init(vm: VM) {
        self.vm = vm
        
        super.init()
        self.bind()
        self.setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        vm.isLoading.observe(on: self) {[weak self] isLoading in
            DispatchQueue.main.asyncAfter(deadline: .now() + (isLoading ? 0.0 : 0.3) ) { [weak self] in
                self?.lottieVC.view.isHidden = !isLoading
            }
        }
        
        vm.locations.observe(on: self) {[weak self] locations in
            guard let self = self else { return }
            self.locations.removeAll()
            self.locations = locations
            
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "manage_locations".localized()
        
        setLayout()
        vm.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
        
        collectionView.pin.below(of: deleteAll).left().right().above(of: addButton)
        collectionView.backgroundColor = .backgroundColor
    }
    
    private func setLayout() {
        self.addChild(self.lottieVC)
        self.view.addSubview(rootFlexContainer)
        self.view.addSubview(self.lottieVC.view)
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.spaceBetween)
            .define { flex in
                flex.addItem()
                    .direction(.column)
                    .grow(1).shrink(1)
                    .define { flex in
                        deleteAll.flex.padding(4, 8)
                        
                        flex.addItem(deleteAll).alignSelf(.end)
                        flex.addItem(collectionView)
                    }
                addButton.addTarget(self, action: #selector(self.onClickAdd), for: .touchUpInside)
                
                flex.addItem(addButton)
                
                flex.addItem(bannerVC.view)
                    .size(GADAdSizeBanner.size)
                    .alignSelf(.center)
            }
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ManageLocationCell.self, forCellWithReuseIdentifier: ManageLocationCell.identifier)
    }
    
    @objc
    func onClickAdd() {
        vm.onClickAdd()
    }
    
    @objc
    func onClickDeleteAll() {
        print("onClickDeleteAll")
        vm.onClickDeleteAll()
    }
}

extension ManageLocationViewController: UICollectionViewDataSource {
    // 1. 만들 cell 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    // 3. cell 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageLocationCell.identifier, for: indexPath) as? ManageLocationCell else {
            return UICollectionViewCell()
        }
        cell.configure(self.vm, location: self.locations[indexPath.item])
        
        return cell
    }
}

extension ManageLocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellTemplate = ManageLocationCell()
        cellTemplate.configure(self.vm, location: self.locations[indexPath.item])
        let size = cellTemplate.sizeThatFits(CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude))
        return size
    }
}
