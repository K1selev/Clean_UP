import UIKit
import Photos

class SimilarPhotosViewController: UIViewController {
    var photoGroups: [[PHAsset]] = []
    var selectedAssets: Set<PHAsset> = []
    var deleteButton: UIButton!

    var allPhotoCount = 0
    let titleLabel = UILabel()
    let counterLabel = UILabel()
    let mainView = UIView()
    let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBlue
        
        requestPhotoAccess()
        
        titleLabel.text = "Similar"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        counterLabel.text = "\(allPhotoCount) photos • \(selectedAssets.count) selected"
        counterLabel.textColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(counterLabel)
        
        mainView.layer.cornerRadius = 16
        mainView.backgroundColor = .white
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
        mainView.addSubview(tableView)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: -80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            counterLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: -40),
            counterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupDeleteButton()
    }
    
    private func requestPhotoAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    #if targetEnvironment(simulator)
                        self.loadPhotos()
                    #else
                        self.loadPhotosFromLibrary()
                    #endif
                case .denied, .restricted:
                    self.showAccessDeniedAlert()
                default:
                    break
                }
            }
        }
    }

    private func showAccessDeniedAlert() {
        let alert = UIAlertController(title: "Доступ к фото запрещён", message: "Разрешите доступ к фото в настройках.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
            self.requestPhotoAccess()
        }))
        present(alert, animated: true)
    }

    func loadPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else { return }
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            var grouped: [[PHAsset]] = []
            var tempGroup: [PHAsset] = []

            allPhotos.enumerateObjects { asset, _, _ in
                tempGroup.append(asset)
                if tempGroup.count == 4 {
                    grouped.append(tempGroup)
                    tempGroup = []
                }
            }
            self.allPhotoCount = allPhotos.count
            if !tempGroup.isEmpty {
                grouped.append(tempGroup)
            }

            DispatchQueue.main.async {
                self.photoGroups = grouped
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadPhotosFromLibrary() {
        DispatchQueue.global(qos: .userInitiated).async {
            var photoAssets: [PhotoAsset] = []
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.resizeMode = .fast

            fetchResult.enumerateObjects { asset, _, _ in
                let targetSize = CGSize(width: 100, height: 100)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                    if let image = image {
                        let observation = PhotoAnalyzer.computeFeaturePrint(for: image)
                        let photoAsset = PhotoAsset(asset: asset, image: image, featurePrintObservation: observation)
                        photoAssets.append(photoAsset)
                    }
                }
            }

            let grouped = PhotoAnalyzer.groupSimilarPhotos(from: photoAssets)
            let groupedAssets: [[PHAsset]] = grouped.map { group in
                group.map { $0.asset }
            }

            DispatchQueue.main.async {
                self.photoGroups = groupedAssets
                self.tableView.reloadData()
            }
        }
    }

    
    private func setupDeleteButton() {
        deleteButton = UIButton()
        deleteButton.setTitle("    Delete \(selectedAssets.count) photos", for: .normal)
        deleteButton.setImage(UIImage(named: "trash"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(deleteSelectedPhotos), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.backgroundColor = .systemBlue
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.layer.cornerRadius = 24

        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            deleteButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }

    @objc func deleteSelectedPhotos() {
        let selected = selectedAssets
        guard !selected.isEmpty else { return }
        var assetsToDelete: [PHAsset] = []
        for indexPath in selected {
            assetsToDelete.append(indexPath)
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.navigateToSuccessScreen(deletedCount: assetsToDelete.count)
                }
            }
        }
    }
    
    private func navigateToSuccessScreen(deletedCount: Int) {
        let vc = SuccessViewController()
        vc.deletedCount = deletedCount
        navigationController?.pushViewController(vc, animated: true)
    }

    func toggleSelectAll(in section: Int) {
        let group = photoGroups[section]
        let isAllSelected = group.allSatisfy { selectedAssets.contains($0) }
        if isAllSelected {
            group.forEach { selectedAssets.remove($0) }
        } else {
            group.forEach { selectedAssets.insert($0) }
        }
        counterLabel.text = "\(allPhotoCount) photos • \(selectedAssets.count) selected"
        setupDeleteButton()
        tableView.reloadRows(at: [IndexPath(row: section, section: 0)], with: .automatic)
    }
}

extension SimilarPhotosViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return photoGroups.count }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260 // Header + horizontal collection height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        let group = photoGroups[indexPath.row]
        let isAllSelected = group.allSatisfy { selectedAssets.contains($0) }
        cell.configure(assets: group, selectedAssets: selectedAssets, title: "\(group.count) Similar", isAllSelected: isAllSelected)
        cell.onToggleSelectAll = { [weak self] in
            self?.toggleSelectAll(in: indexPath.row)
        }
        cell.onAssetTapped = { [weak self] asset in
            guard let self = self else { return }
            if self.selectedAssets.contains(asset) {
                self.selectedAssets.remove(asset)
            } else {
                self.selectedAssets.insert(asset)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        counterLabel.text = "\(allPhotoCount) photos • \(selectedAssets.count) selected"
        setupDeleteButton()
        return cell
    }
}
