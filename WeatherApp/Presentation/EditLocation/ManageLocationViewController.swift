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

class ManageLocationViewController: BaseViewController {
    typealias VM = ManageLocationViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate var cellTemplate = ManageLocationCell()

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
            DispatchQueue.main.asyncAfter(deadline: .now() + (isLoading ? 0.0 : 0.6) ) { [weak self] in
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
        
        collectionView.pin.all()
    }
    
    private func setLayout() {
        self.view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.start)
            .define { flex in
                flex.addItem(collectionView)
            }
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ManageLocationCell.self, forCellWithReuseIdentifier: ManageLocationCell.identifier)
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
