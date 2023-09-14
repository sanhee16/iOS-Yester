//
//  SelectLocationViewController.swift
//  WeatherApp
//
//  Created by sandy on 2023/07/18.
//


import UIKit
import SwiftUI
import Combine
import PinLayout
import FlexLayout

class SelectLocationViewController: BaseViewController {
    typealias VM = SelectLocationViewModel
    
    private let vm: VM
    
    fileprivate lazy var rootFlexContainer: UIView = UIView()
    fileprivate lazy var results: [Geocoding] = []
    
    fileprivate lazy var lottieVC: LottieVC = {
        let lottieVC = LottieVC(type: .progressing)
        lottieVC.modalPresentationStyle = .overFullScreen
        lottieVC.modalTransitionStyle = .crossDissolve
        lottieVC.view.backgroundColor = .clear
        return lottieVC
    }()
    
    private let bottomButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("search".localized(), for: .normal)
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
    
    private let searchingLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .en14r
        label.textColor = .black
        return label
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = ""
        
        return searchController
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        return tableView
    }()
    
    init(vm: VM) {
        self.vm = vm
        super.init()
        self.bind(to: vm)
        self.setUpTableView()
        
        self.searchController.searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    private func bind(to vm: VM) {
        vm.isLoading.observe(on: self) {[weak self] isLoading in
            DispatchQueue.main.asyncAfter(deadline: .now() + (isLoading ? 0.0 : 0.6) ) { [weak self] in
                self?.lottieVC.view.isHidden = !isLoading
            }
        }
        
        vm.status.observe(on: self) { [weak self] status in
            guard let self = self else { return }
            self.searchingLabel.flex.markDirty()
            self.bottomButton.flex.markDirty()
            self.tableView.flex.markDirty()
            
            switch status {
            case .ready:
                self.searchingLabel.isHidden = true
                self.bottomButton.isHidden = true
                
                self.results.removeAll()
                self.tableView.reloadData()
                break
            case .entering:
                self.searchingLabel.isHidden = true
                self.bottomButton.setTitle("search".localized(), for: .normal)
                self.bottomButton.isHidden = vm.name.value.isEmpty
                break
            case .searching:
                self.searchingLabel.isHidden = true
                self.bottomButton.isHidden = true
                break
            case let .finished(result):
                self.searchingLabel.isHidden = false
                self.bottomButton.isHidden = true
                
                self.results = result
                self.tableView.reloadData()
                
                if !result.isEmpty {
                    if result.isEmpty {
                        self.searchingLabel.text = "search_no_result_text".localized([vm.name.value])
                        self.searchingLabel.isHidden = true
                    } else {
                        self.searchingLabel.text = "search_result_text".localized([vm.name.value])
                        self.searchingLabel.isHidden = false
                    }
                }
                break
            case .select(_, _):
                self.bottomButton.setTitle("add".localized(), for: .normal)
                self.bottomButton.isHidden = false
                break
            }
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        vm.viewDidLoad()
        
        self.navigationItem.title = "add_location".localized()
        self.navigationItem.searchController = searchController
        self.searchController.searchResultsUpdater = self
        self.tableView.register(SelectLocationCell.self, forCellReuseIdentifier: SelectLocationCell.identifier)
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        searchingLabel.pin.top().left().right()
        bottomButton.pin.bottom().left().right()
        tableView.pin.top().left().right().above(of: bottomButton)
        
        self.layout()
    }
    
    private func layout() {
        rootFlexContainer.flex.layout()
        tableView.flex.layout()
    }
    
    private func setLayout() {
        self.addChild(self.lottieVC)
        
        self.view.addSubview(self.lottieVC.view)
        self.view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.spaceBetween)
            .define { flex in
                bottomButton.addTarget(self, action: #selector(self.onClickBottomButton), for: .touchUpInside)
                flex.addItem(searchingLabel).margin(6, 12)
                flex.addItem(tableView).grow(1)
                flex.addItem(bottomButton).marginTop(6)
            }
    }
    
    
    @objc private func onClickBottomButton() {
        switch vm.status.value {
        case .select(_, _):
            vm.onClickAddLocation()
            break
        case .entering:
            vm.onClickSearch()
            break
        default:
            break
        }
    }
}

extension SelectLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectLocationCell.identifier, for: indexPath) as! SelectLocationCell
        cell.configure(vm, value: self.results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = SelectLocationCell()
        cell.configure(vm, value: self.results[indexPath.row])
        let size = cell.sizeThatFits(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude))

        return size.height
    }
}

extension SelectLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? SelectLocationCell else {
            return
        }
        vm.onClickItem(indexPath.row)
    }
}

extension SelectLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        vm.entering(searchController.searchBar.text)
    }
}

extension SelectLocationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.onClickCancel()
    }
}
