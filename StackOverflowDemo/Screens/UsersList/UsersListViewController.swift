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
    private let refreshControl = UIRefreshControl()
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
        title = String(localized: .Localization.usersListTitle)

        tableView.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: UserTableViewCell.reuseIdentifier
        )
        tableView.delegate = self
        tableView.backgroundView = errorView
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
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
        updateErrorPlaceholder(viewModel.state)
        updateLoadingState(viewModel.state)
        dataSource.apply(viewModel.snapshot)
    }

    private func updateLoadingState(_ state: UsersListState) {
        state == .loading
            ? refreshControl.beginRefreshing()
            : refreshControl.endRefreshing()
    }

    private func updateErrorPlaceholder(_ state: UsersListState) {
        switch state {
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

    @objc
    private func refreshControlValueChanged() {
        viewModel.reloadData()
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
