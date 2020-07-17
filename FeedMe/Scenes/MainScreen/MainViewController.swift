//
//  MainViewController.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTableView: UITableView!
    @IBOutlet private weak var badgedButton: BadgedButton!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    
    private enum Constants {
        static let iPhoneHasTopNotch = UIDevice.current.hasNotch
        static let navBarHeightSize: CGFloat = iPhoneHasTopNotch ? 100 : 76
    }
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.isHidden = false
        headerHeightConstraint.constant = Constants.navBarHeightSize
        UIView.animate(withDuration: 0.6) {
            self.badgedButton.alpha = 1
            self.titleLabel.alpha = 1
            self.view.layoutSubviews()
        }
        badgedButton.badgetNumber = viewModel.cart.orders.count
    }
    
    @IBAction func handleCartTap(_ sender: UIButton) {
        print("go to cart")
    }
}

//MARK: - UITableView Methods

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.foodToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTypeTableViewCell", for: indexPath) as? FoodTypeTableViewCell else {
            return UITableViewCell()
        }
        let foodViewModel = viewModel.foodToDisplay[indexPath.row]
        cell.set(viewModel: foodViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = contentTableView.cellForRow(at: indexPath) as? FoodTypeTableViewCell else { return }
        let auxFrame = cell.convert(cell.titleImageView.frame, to: contentTableView.superview!)
        viewModel.handleRowTapFor(cell: cell, on: self, withImageFrame: auxFrame)
    }
}

//MARK: - Private Methods

private extension MainViewController {
    func configureUI() {
        titleLabel.isHidden = true
        headerView.backgroundColor = .customGreen
        headerHeightConstraint.constant = UIScreen.main.bounds.height
        badgedButton.alpha = 0
        titleLabel.alpha = 0
    }
    
    func configureTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        contentTableView.register(UINib(nibName: "FoodTypeTableViewCell", bundle: Bundle.main),
                                  forCellReuseIdentifier: "FoodTypeTableViewCell")
    }
}
