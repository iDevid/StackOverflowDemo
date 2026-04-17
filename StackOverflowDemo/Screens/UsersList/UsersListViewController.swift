//
//  UsersListViewController.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import NetworkLayer
import UIKit

class UsersListViewController: UIViewController {

    private var viewModel: UsersListViewModel!
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
        title = "Users"
    }
}
