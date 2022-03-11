//
//  MainViewController.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 9.03.2022.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet weak var nowPlayingSlider: UICollectionView!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var sliderControl: UIPageControl!

    var networkService = NetworkService()
    var mainViewModel = MainViewModel()
    var activityIndicator = UIActivityIndicatorView()

    var sliderTimer = Timer()
    var sliderCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNowPlayingSlider()
        configureUpcomingTableView()
        fetchUpcomingData()
        fetchNowPlayingData()
        configureSlider()
        
              
    }
    
    
    func configureNowPlayingSlider(){
        self.nowPlayingSlider.delegate = self
        self.nowPlayingSlider.dataSource = self
        self.nowPlayingSlider.register(SliderCell.nib, forCellWithReuseIdentifier: SliderCell.identifier)
    }
    
    func configureUpcomingTableView(){
        self.upcomingTableView.delegate = self
        self.upcomingTableView.dataSource = self
        upcomingTableView.separatorStyle = .singleLine
        upcomingTableView.separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.upcomingTableView.register(UpcomingCustomCell.nib, forCellReuseIdentifier: UpcomingCustomCell.identifier)
    }
    
    
//    MARK: - Slider
    func configureSlider(){
        sliderTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeNowPlayingMovie), userInfo: nil, repeats: true)
        sliderControl.numberOfPages = mainViewModel.nowPlayingMovies.count
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        sliderControl.currentPage = Int(scrollPos)
        sliderCounter = Int(scrollPos)
    }

    @objc func changeNowPlayingMovie(){
        if sliderCounter < mainViewModel.nowPlayingMovies.count {
                let index = IndexPath.init(item: sliderCounter, section: 0)
                self.nowPlayingSlider.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                sliderControl.currentPage = sliderCounter
                sliderCounter += 1
           } else {
                sliderCounter = 0
                let index = IndexPath.init(item: sliderCounter, section: 0)
                self.nowPlayingSlider.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                 sliderControl.currentPage = sliderCounter
                 sliderCounter = 1
             }
    }
    
    
//    MARK: - Scroll view
    override func viewWillAppear(_ animated: Bool) {
        self.upcomingTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.upcomingTableView.reloadData()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        self.upcomingTableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
                if let newValue = change?[.newKey]{
                    let newSize = newValue as! CGSize
                    self.tableHeight.constant = newSize.height
                }
        }
    }


//    MARK: - UIStatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let status = UITraitCollection.current.userInterfaceStyle
        if status == .dark{
            return .lightContent
        } else{
            return .lightContent
        }
    }
    
    
    
//    MARK: - Fetching movie data
    func fetchNowPlayingData(){
        mainViewModel.getNowPlayingMovies(networkService: networkService) {
            DispatchQueue.main.async {
                self.nowPlayingSlider.reloadData()
                self.sliderControl.numberOfPages = self.mainViewModel.nowPlayingMovies.count
            }
        }
    }
    
    func fetchUpcomingData(){
        mainViewModel.getUpcomingMovies(networkService: networkService) {
            DispatchQueue.main.async {
                self.upcomingTableView.reloadData()
            }
        }
    }

    func fetchNextMovie(){
        if networkService.pageNumber < 19{
        networkService.pageNumber += 1
        mainViewModel.getUpcomingMovies(networkService: networkService) {
                self.upcomingTableView.reloadData()
        }
        }
    }

}


// MARK: - Slider
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCell.identifier, for: indexPath) as? SliderCell else{
            fatalError("xib doesn't exist")
        }
        cell.setupCell(movie: mainViewModel.nowPlayingMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if indexPath.row == self.mainViewModel.upcomingMovies.count - 1 {
                self.fetchNextMovie()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "detailScreen") as! DetailViewController
        detailVC.movieID = mainViewModel.nowPlayingMovies[indexPath.row].id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Slider flow layout
extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfSlider = self.nowPlayingSlider.frame.size.width
        let heightOfSlider = self.nowPlayingSlider.frame.size.height
        
        return CGSize(width: widthOfSlider, height: heightOfSlider)
    }
}


// MARK: - Table view
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingCustomCell.identifier, for: indexPath) as? UpcomingCustomCell else{
            fatalError("xib doesn't exist")
        }
        
        cell.setupCell(movie: mainViewModel.upcomingMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "detailScreen") as! DetailViewController
        detailVC.movieID = mainViewModel.upcomingMovies[indexPath.row].id
        navigationController?.pushViewController(detailVC, animated: true)



    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}
