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
    private let errorView = ErrorPlaceholderView()
    private var dataSource: UITableViewDiffableDataSource<UserListSection, UserCellViewModel>!

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

        tableView.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: UserTableViewCell.reuseIdentifier
        )
        tableView.delegate = self
        tableView.backgroundView = errorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { try await viewModel.loadData() }
    }

    override func updateProperties() {
        updateErrorPlaceholder()
        dataSource.apply(viewModel.snapshot)
    }

    private func updateErrorPlaceholder() {
        switch viewModel.loadState {
        case .error(let viewModel):
            errorView.isHidden = false
            errorView.update(with: viewModel)
        default:
            errorView.isHidden = true
            errorView.update(with: nil)
        }
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<UserListSection, UserCellViewModel>(tableView: tableView) { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
            cell.configure(with: viewModel)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        viewModel.notifyWillDisplayCell(at: indexPath)
    }
}
