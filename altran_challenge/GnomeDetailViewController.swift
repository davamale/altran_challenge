//
//  GnomeDetailViewController.swift
//  altran_challenge
//
//  Created by Dava on 7/13/17.
//
//

import UIKit
import STXImageCache

// MARK: - Constants
fileprivate extension GnomeDetailViewController {
  struct PrivateConstants {
    
    static let padding: CGFloat = 8
  }
}

class GnomeDetailViewController: UIViewController {
  
  fileprivate var nameLabel = UILabel.detailLabel()
  fileprivate var ageLabel = UILabel.detailLabel()
  fileprivate var heightLabel = UILabel.detailLabel()
  fileprivate var weightLabel = UILabel.detailLabel()
  fileprivate let hairColorLabel = UILabel.detailLabel()
  fileprivate let viewModel = DetailViewModel()
  var gnomeName: String!
  var navigationBarColor: UIColor?
  fileprivate lazy var tableView: UITableView = {
    
    let tv = UITableView()
    
    tv.delegate = self
    tv.dataSource = self
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.tableFooterView = UIView()
    tv.register(GnomeCell.nib, forCellReuseIdentifier: GnomeCell.identifier)
    tv.backgroundColor = .clear
    tv.cellLayoutMarginsFollowReadableWidth = false
    
    return tv
  }()
  
  fileprivate var imageView: UIImageView = {
    
    let iv = UIImageView()
    
    iv.backgroundColor = UIColor.defaultGray
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    
    return iv
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareUI()
    bindViewModel()
    viewModel.viewDidLoad(with: gnomeName)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    handleLayout()
  }
  
  override func willMove(toParentViewController parent: UIViewController?) {
    navigationController?.navigationBar.barTintColor = .defaultBlue
    super.willMove(toParentViewController: parent)
  }
}

// MARK: - Private Methods
fileprivate extension GnomeDetailViewController {
  
  func bindViewModel() {
    viewModel.outputs.gnomeObject
      .subscribe { observable in self.populate(with: observable.element != nil ? observable.element! : nil) }
      .addDisposableTo(viewModel.disposeBag)
    
    
  }
  
  /// Adjust layout changes
  func handleLayout() {
    imageView.layer.cornerRadius = imageView.frame.height / 2
  }
}

// MARK: - UITableView DataSource
extension GnomeDetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let section = Constants.DetailTableView
      .Section(rawValue: indexPath.section) else { return UITableViewCell() }
    
    switch section {
    case .profession: return UITableViewCell()
      
    case .friend: return UITableViewCell()
    }
  }
}

// MARK: - UITableView Delegate
extension GnomeDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    // height for Friends cell
    if let section = Constants.DetailTableView.Section(rawValue: indexPath.section), section == .friend {
      return GnomeCell.cellHeight
    }
    
    return Constants.DetailTableView.professionCellHeight
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ""
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - GnomeDetailViewModel Delegate
extension GnomeDetailViewController {
  func populate(with gnome: Gnome?) {
    
    guard let gnome = gnome else { return }
    
    nameLabel.text = gnome.name
    ageLabel.text = "Age: \(gnome.age)"
    
    if  let hairColor = gnome.hairColor {
      hairColorLabel.text = "Hair Color: \(hairColor)"
    }
    
    weightLabel.text = "Weight: \(gnome.weight)"
    heightLabel.text = "Height: \(gnome.height)"
    
    if let imageUrlString = gnome.pictureUrl, let imageUrl = URL(string:imageUrlString)  {
      imageView.stx.image(atURL: imageUrl)
    }
  }
}

// MARK: - Customizable
extension GnomeDetailViewController: Customizable {
  func prepareUI() {
    
    navigationController?.navigationBar.barTintColor = navigationBarColor
    navigationController?.navigationBar.isTranslucent = false
    
    view.addSubview(imageView)
    view.addSubview(tableView)
    view.addSubview(nameLabel)
    view.addSubview(ageLabel)
    view.addSubview(weightLabel)
    view.addSubview(heightLabel)
    view.addSubview(hairColorLabel)
    
    addContraints()
  }
  
  func addContraints() {
    
    // image view
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PrivateConstants.padding).isActive = true
    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: PrivateConstants.padding).isActive = true
    
    // priority lower than max width allow
    let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: view.frame.width / 3)
    widthConstraint.priority = 750
    widthConstraint.isActive = true
    
    imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 0).isActive = true
    
    // name label
    nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: PrivateConstants.padding).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // age label
    ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: PrivateConstants.padding).isActive = true
    ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
    ageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    ageLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
    
    // hair color label
    hairColorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: PrivateConstants.padding).isActive = true
    hairColorLabel.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 0).isActive = true
    hairColorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PrivateConstants.padding).isActive = true
    hairColorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // width label
    weightLabel.topAnchor.constraint(equalTo: hairColorLabel.bottomAnchor, constant: PrivateConstants.padding).isActive = true
    weightLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
    weightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PrivateConstants.padding).isActive = true
    weightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // height label
    heightLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: PrivateConstants.padding).isActive = true
    heightLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
    heightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PrivateConstants.padding).isActive = true
    heightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // table view
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    
    view.layoutIfNeeded()
  }
}











