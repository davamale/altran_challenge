//
//  GnomeListView.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit
import AndroidDialogAlert

// MARK: - Constants
fileprivate extension GnomeListViewController {
  
  struct PrivateConstants {
    /// Constants related do filterControl
    struct FilterControl {
      static let height: CGFloat = 30.0
      static let leading: CGFloat = 20
      static let trailing: CGFloat = -20.0
      
      static let maxWidth: CGFloat = 400
    }
    
    /// Constants related to tableView
    struct TableView {
      static let padding: CGFloat = 4
    }
  }
}

class GnomeListViewController: UIViewController {
  
  //MARK: - Properties
  fileprivate lazy var tableView: UITableView = {
    
    let tv = UITableView()
    
    tv.delegate = self
    tv.dataSource = self
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.tableFooterView = UIView()
    tv.register(GnomeCell.nib,
                forCellReuseIdentifier: GnomeCell.identifier)
    tv.cellLayoutMarginsFollowReadableWidth = false
    
    if #available(iOS 10.0, *) {
      tv.refreshControl = self.refreshControl
    } else {
      tv.addSubview(self.refreshControl)
    }
    
    return tv
  }()
  
  fileprivate lazy var refreshControl: UIRefreshControl = {
    
    let rc = UIRefreshControl()
    
    rc.addTarget(self,
                 action: #selector(refreshList),
                 for: .valueChanged)
    
    return rc
  }()
  
  fileprivate let loadingView: UIActivityIndicatorView = {
    let lv = UIActivityIndicatorView(activityIndicatorStyle: .white)
    lv.hidesWhenStopped = true
    
    return lv
  }()
  
  fileprivate lazy var filterControl: UISegmentedControl = {
    
    let fc = UISegmentedControl(items: ["All", "No Friends", "No Job"])
    
    fc.tintColor = .white
    fc.translatesAutoresizingMaskIntoConstraints = false
    fc.selectedSegmentIndex = 0
    fc.addTarget(self,
                 action: #selector(filterControlSelection(sender:)),
                 for: .valueChanged)
    
    return fc
  }()
  
  // TODO: Refactor
  fileprivate let emptyView: UIView = {
    
    let view = UIView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .defaultBlack
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = "Initial loading my take a few moments..."
    label.textAlignment = .center
    
    view.addSubview(label)
    
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      .isActive = true
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      .isActive = true
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      .isActive = true
    label.heightAnchor.constraint(equalToConstant: 20)
      .isActive = true
    
    return view
  }()
  
  fileprivate lazy var viewModel: GnomeListViewModel = {
    return GnomeListViewModel() { action in
      self.handleAction(action)
    }
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareUI()
    loadingView.startAnimating()
    refreshControl.beginRefreshing()
    
    viewModel.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.barTintColor = .defaultBlue
  }
  
  func handleAction(_ action: Action) {
    
    showError(withMessage: action.alertMessage)
    
    switch action.tableViewAction {
    case .insert(let value):
      tableView.insertRows(at: [value.indexPath],
                           with: .automatic)
      break
      
    case .update(let value):
      tableView.reloadRows(at: [value.indexPath],
                           with: .automatic)
      break
      
    case .beginUpdates:
      tableView.beginUpdates()
      break
      
    case .endUpdates:
      tableView.endUpdates()
      break
      
    case .reload:
      tableView.reloadData()
      break
      
    case .finishedLoading:
      didFinishLoading()
      break
      
    case .showEmptyView:
      showEmtpyListView()
      break
      
    default: break
      
    }
  }
  
}

//MARK: - Private Methods
fileprivate extension GnomeListViewController {
  
  @objc func filterControlSelection(sender: UISegmentedControl) {
    viewModel.filter(using: Constants.Filter(rawValue: sender.selectedSegmentIndex)!)
  }
  
  @objc func refreshList() {
    viewModel.handleGetList()
  }
}

//MARK: - UITableView DataSource
extension GnomeListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: GnomeCell.identifier,
                                             for: indexPath) as! GnomeCell
    return cell.configure(withEntity: viewModel.object(atIndexPath: indexPath))
  }
}

//MARK: - UITableView Delegate
extension GnomeListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return GnomeCell.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let gnome = viewModel.object(atIndexPath: indexPath),
      let storyboard = storyboard,
      let detailView = storyboard.instantiateViewController(withIdentifier: "Detail") as? GnomeDetailViewController else { return }
    
    detailView.gnomeName = gnome.name
    detailView.navigationBarColor = gnome.hairColor != nil ? gnome.hairColor!.hairColor() : nil
    navigationController?.pushViewController(detailView, animated: true)
  }
}

//MARK: - Private Methods
fileprivate extension GnomeListViewController {
  
  func showEmtpyListView() {
    view.addSubview(emptyView)
    
    emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
      .isActive = true
    emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      .isActive = true
    emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      .isActive = true
    emptyView.topAnchor.constraint(equalTo: view.topAnchor)
      .isActive = true
    
    emptyView.layoutIfNeeded()
  }
  
  func showError(withMessage message: String?) {
    
    guard let message = message else { return }
    
    DispatchQueue.main.async {
      // hide refresh control
      self.refreshControl.endRefreshing()
      
      let alert = AndroidDialogAlert(titleText: "Network Error",
                                     messageText: message,
                                     buttonText: "Cancel")
      alert.dialogBorderColor = .groupTableViewBackground
      
      alert.buttonCompletion = { (alert) in
        self.loadingView.stopAnimating()
        alert.dismiss(animated: true, completion: nil)
      }
      
      alert.alternateButton(title: "Retry") { (alert) in
        self.viewModel.handleGetList()
        alert.dismiss(animated: true, completion: nil)
      }
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func didFinishLoading() {
    
    DispatchQueue.main.async {
      
      // hide refresh control
      self.refreshControl.endRefreshing()
      
      self.loadingView.stopAnimating()
      
      // removes empty view in case it was active in the view stack
      self.emptyView.removeFromSuperview()
    }
  }
}

// MARK: - Customizable
extension GnomeListViewController: Customizable {
  
  func prepareUI() {
    
    view.backgroundColor = .defaultBlue
    navigationController?.navigationBar.removeHairline()
    let barLoading = UIBarButtonItem(customView: loadingView)
    navigationItem.rightBarButtonItem = barLoading
    view.addSubview(tableView)
    view.addSubview(filterControl)
    
    addContraints()
  }
  
  func addContraints() {
    
    // filter control
    filterControl.topAnchor.constraint(equalTo: view.topAnchor,
                                       constant: 0).isActive = true
    filterControl.heightAnchor.constraint(equalToConstant: PrivateConstants.FilterControl.height)
      .isActive = true
    filterControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      .isActive = true
    filterControl.widthAnchor.constraint(lessThanOrEqualToConstant: PrivateConstants.FilterControl.maxWidth)
      .isActive = true
    
    let leadingFC = filterControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                           constant: PrivateConstants.FilterControl.leading)
    leadingFC.priority = 750
    leadingFC.isActive = true
    
    let trailingFC = filterControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                             constant: PrivateConstants.FilterControl.trailing)
    trailingFC.priority = 750
    trailingFC.isActive = true
    
    // table view
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
      .isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
      .isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
      .isActive = true
    tableView.topAnchor.constraint(equalTo: filterControl.bottomAnchor,
                                   constant: PrivateConstants.TableView.padding).isActive = true
    
  }
}





