
import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    var username: String!
    var followers:[Follower] = []
    var hasMoreFollowers = true
    var filteredFollowers: [Follower] = []
  
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,Follower>!
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createColumFlowLayout(in:view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    func getFollowers(username: String,page: Int) {
       
       NetworkManager.shared.getFollowers(for: username, page: page) { [weak self]  result in
        guard let self = self else { return }
//       self.dismissLoadingView()
            
           switch result {
            case .success(let followers):
               if followers.count < 100 { self.hasMoreFollowers = false }
               self.followers.append(contentsOf:followers)
               
               if self.followers.isEmpty {
                   let message = "this user doesnt have any user follow them 🫥."
                   DispatchQueue.main.async {self.showEmptyStateView(with: message, inview: self.view)}
                    
                   return
   
               }
               
               self.updateData(on:self.followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider:  {(collectionView, indexPath, follower) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FollowerCell.reuseID,for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
        
    }
    
    
    func updateData(on followers:[Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot,animatingDifferences: true) }
           
        }
    
    }


extension FollowerListVC: UICollectionViewDelegate{
    private func scrollViewWillEndDragging(_ scrollView: UIScrollView,willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
            
            
        }
        
    }

    func collectionView(_ collectionView:UICollectionView,didSelectItemAt indexPath:IndexPath){
        let follower = followers
}
    
}

extension FollowerListVC: UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text,!filter.isEmpty else {return}
        
        filteredFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
    }
    
    
}

 
