//
//  MyTubeBollywoodMovies.swift
//  NavigationVC_TabVC
//
//  Created by Ankam Ajay Kumar on 11/12/19.
//  Copyright © 2019 Ankam Ajay Kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MyTubeBollywoodMovies: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControlObj: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var genreScrollView: UIScrollView!
    
    var movieJsonData = [[String:Any]]()
    var allButtonObj = [UIButton]()
    var allLabelObj = [UILabel]()
    var avPlayerController:AVPlayerViewController!
    var myAlert:UIAlertController!
    var okAction:UIAlertAction!
    var tollywoodMovies = ["Ala Vaikuntapuram lo":"T", "Saaho":"T", "Rakshasudu":"T", "Jersey":"T", "Manmadhudu 2":"T", "Mallesham":"T", "Khaidi":"T", "Agent Sai Srinivasa Athreya":"T", "Sye Raa Narasimha Reddy":"T", "Gaddalakonda Ganesh":"T", "George Reddy":"T", "Game Over":"T", "Dear Comrade":"T", "Petta":"T", "118":"T", "Gang Leader":"T", "War":"B", "Frozen 2":"H", "Pehlwaan":"B", "The Zoya Factor":"B", "Oh! Baby":"T", "Evaru":"T", "Whistle":"T", "Evvarikee Cheppoddu":"T"]
    var movieGenres = [UIImage(named: "action"), UIImage(named: "comedy"), UIImage(named: "crime"), UIImage(named: "drama"), UIImage(named: "animated"), UIImage(named: "horror")]
    var genresNames = ["Action", "Comedy", "Crime", "Drama", "Animated", "Horror"]
    
    
       
        //MARK: - IBAction
        @IBAction func loadActionBtn(_ sender: Any) {
            
            //pagecontrol to start from '0' page
            pageControlObj.currentPage = 0
            
            //calling method to show movie details
            latestMovieDetails()
        }
        
        //MARK: - viewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
            //calling method to show movie details
            latestMovieDetails()
            
            movieGenreDetails()
            
            //adding scheduled timer to movie poster
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerEH), userInfo: nil, repeats: true)

        }
        
        //MARK: - Method Creation
        //custom button
        func customBtn(_ button: UIButton, _ string: String)
        {
            button.setImage(UIImage(systemName: string), for: UIControl.State.normal)
            button.layer.cornerRadius = button.frame.size.width / 2
            button.clipsToBounds = true
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            button.tintColor = .white
            button.pulseButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        //custom label
        func customLbl(_ label:UILabel, _ string:String)
        {
            label.text = string
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont(name: "Georgia", size: 12)
        }
        
        //method to set timer for pagecontrol
        @objc func timerEH()
        {
            
            if(pageControlObj.currentPage != pageControlObj.numberOfPages - 1)
            {
                pageControlObj.currentPage += 1
            }
            else
            {
                pageControlObj.currentPage = 0
            }
            
            scrollView.contentOffset.x = CGFloat(pageControlObj.currentPage) * scrollView.frame.width
        }
        
        //method to navigate and button tag values in singleton
        @objc func navigateToMovieDetails(obj:UIButton)
        {
            JsonData.shared.buttonTapped = obj.tag
        
            let movieDetails = storyboard?.instantiateViewController(withIdentifier: "BollywoodMovieDetails") as! BollywoodMovieDetails
            
            self.navigationController?.pushViewController(movieDetails, animated: true)
        }
        
        //method to watch movie
        @objc func watchMovie(obj:UIButton)
        {
            JsonData.shared.buttonTapped = obj.tag
            avPlayerController = AVPlayerViewController()
            avPlayerController.player = JsonData.shared.trailer[JsonData.shared.buttonTapped]
            avPlayerController.player?.play()
            present(avPlayerController, animated: true, completion: nil)
        }
        
        //method for movie watchlist
        @objc func watchList(obj:UIButton)
        {
            JsonData.shared.buttonTapped = obj.tag
            myAlert = UIAlertController(title: "Alert", message: "\(JsonData.shared.title[JsonData.shared.buttonTapped]) movie added to WatchList ", preferredStyle: UIAlertController.Style.alert)
            okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            myAlert.addAction(okAction)
            present(myAlert, animated: true, completion: nil)
        }
        
        //method for movie downlaod
        @objc func movieDownload(obj:UIButton)
        {
            JsonData.shared.buttonTapped = obj.tag
            myAlert = UIAlertController(title: "Alert", message: "Join MyTube VIP to download \(JsonData.shared.title[JsonData.shared.buttonTapped]) movie", preferredStyle: UIAlertController.Style.alert)
            okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            myAlert.addAction(okAction)
            present(myAlert, animated: true, completion: nil)
        }
        
        
        //method to display movie details
        func latestMovieDetails()
        {
            scrollView.delegate = self
            
            //removing all buttons and labels
            for (x,y) in zip(allButtonObj, allLabelObj)
            {
               print("x")
                
                x.removeFromSuperview()
                y.removeFromSuperview()
            }
            
            //buttons and labels will be empty after removing
            allButtonObj = [UIButton]()
            allLabelObj = [UILabel]()
        
            //singleton variables will be empty after loading
            JsonData.shared.posters = [UIImage]()
            JsonData.shared.title = [String]()
            JsonData.shared.directorName = [String]()
            JsonData.shared.stories = [String]()
            JsonData.shared.actorName = [[String]]()
            JsonData.shared.trailer = [AVPlayer]()
            JsonData.shared.songs = [[AVPlayer]]()
            
            //storing json data
            movieJsonData = JsonData.shared.movieDataFromJson()
            //pageControlObj.numberOfPages = movieJsonData.count
            
            var i = 0
            for x in movieJsonData
            {
                if(tollywoodMovies[x["title"] as! String] == "B")
                {
                    let poster = (x["posters"] as! [String])[0]
                    let urlString = poster.replacingOccurrences(of: " ", with: "%20")
                    print(poster)
                    let posterURL = URL(string: "https://www.brninfotech.com/tws/\(urlString)")
                    let posterDataTask = URLSession.shared.dataTask(with: posterURL!) { (data, connDetails, err) in
                        
                        DispatchQueue.main.async {
                            
                            //adding subView in scrollView
                            let subView = UIView()
                            subView.frame = CGRect(x: CGFloat(i) * self.scrollView.frame.width, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
                            subView.backgroundColor = .black
                            self.scrollView.addSubview(subView)
                            
                            //to display posters in button
                            let posterBtn = UIButton()
                            posterBtn.setImage(UIImage(data: data!), for: UIControl.State.normal)
                            posterBtn.layer.cornerRadius = 6
                            posterBtn.clipsToBounds = true
                            self.allButtonObj.append(posterBtn)
                            posterBtn.translatesAutoresizingMaskIntoConstraints = false
                            posterBtn.widthAnchor.constraint(equalToConstant: 280).isActive = true
                            posterBtn.heightAnchor.constraint(equalToConstant: 200).isActive = true
                            
                            //to display title name in label
                            let titleLbl = UILabel()
                            titleLbl.text = (x["title"] as! String)
                            titleLbl.textColor = .white
                            titleLbl.textAlignment = .center
                            titleLbl.font = UIFont(name: "Georgia", size: 20)
                            self.allLabelObj.append(titleLbl)
                            
                            //button and label for Watch Movie
                            let watchMovieBtn = UIButton()
                            watchMovieBtn.addTarget(self, action: #selector(self.watchMovie(obj:)), for: UIControl.Event.touchUpInside)
                            watchMovieBtn.tag = i
                            self.customBtn(watchMovieBtn, "play")
                            
                            let watchMovieLbl = UILabel()
                            self.customLbl(watchMovieLbl, "Watch Now")
                            
                            //button and label for Watch List
                            let downloadBtn = UIButton()
                            downloadBtn.addTarget(self, action: #selector(self.movieDownload(obj:)), for: UIControl.Event.touchUpInside)
                            downloadBtn.tag = i
                            self.customBtn(downloadBtn, "square.and.arrow.down")
                            
                            let downloadLbl = UILabel()
                            self.customLbl(downloadLbl, "Download")
                            
                            //button and label for Download
                            let watchListBtn = UIButton()
                            watchListBtn.addTarget(self, action: #selector(self.watchList(obj:)), for: UIControl.Event.touchUpInside)
                            watchListBtn.tag = i
                            self.customBtn(watchListBtn, "plus")
                            
                            let watchListLbl = UILabel()
                            self.customLbl(watchListLbl, "Watch List")
                            
                            //button and label for More Details
                            let moreDetailsBtn = UIButton()
                            moreDetailsBtn.addTarget(self, action: #selector(self.navigateToMovieDetails(obj:)), for: UIControl.Event.touchUpInside)
                            moreDetailsBtn.tag = i
                            self.customBtn(moreDetailsBtn, "list.bullet")
                            
                            let moreDetailsLbl = UILabel()
                            self.customLbl(moreDetailsLbl, "More Details")
                            
                            //to display watch movie button and label
                            let watchMovieStackView = UIStackView(arrangedSubviews: [watchMovieBtn, watchMovieLbl])
                            watchMovieStackView.axis = .vertical
                            watchMovieStackView.distribution = .fillEqually
                            
                            //to display downlaod button and label
                            let downloadStackView = UIStackView(arrangedSubviews: [downloadBtn, downloadLbl])
                            downloadStackView.axis = .vertical
                            downloadStackView.distribution = .fillEqually
                            
                            //to display watch List button and label
                            let watchListStackView = UIStackView(arrangedSubviews: [watchListBtn, watchListLbl])
                            watchListStackView.axis = .vertical
                            watchListStackView.distribution = .fillEqually
                            
                            //to display More Details button and label
                            let detailsStackView = UIStackView(arrangedSubviews: [moreDetailsBtn, moreDetailsLbl])
                            detailsStackView.axis = .vertical
                            detailsStackView.distribution = .fillEqually
                            
                            //stackview to display poster and title
                            let firstStackView = UIStackView(arrangedSubviews: [posterBtn, titleLbl])
                            firstStackView.axis = .vertical
                            
                            //stackview to display button and label stackviews
                            let secondStackView = UIStackView(arrangedSubviews: [watchMovieStackView, watchListStackView, downloadStackView, detailsStackView])
                            secondStackView.axis = .horizontal
                            secondStackView.distribution = .fillEqually
                            secondStackView.spacing = 12
                            
                            //main stackview
                            let mainStackView = UIStackView(arrangedSubviews: [firstStackView, secondStackView])
                            mainStackView.axis = .vertical
                            mainStackView.alignment = .fill
                            mainStackView.distribution = .fill
                            mainStackView.spacing = 10
                            subView.addSubview(mainStackView)
                            mainStackView.translatesAutoresizingMaskIntoConstraints = false
                            mainStackView.topAnchor.constraint(equalTo: subView.topAnchor, constant: 10).isActive = true
                            mainStackView.leftAnchor.constraint(equalTo: subView.leftAnchor, constant: 20).isActive = true
                            mainStackView.rightAnchor.constraint(equalTo: subView.rightAnchor, constant: -20).isActive = true
                            mainStackView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -10).isActive = true
                            
                            
                            //storing all singleton variables
                            JsonData.shared.posters.append(UIImage(data: data!)!)
                            JsonData.shared.title.append(x["title"] as! String)
                            JsonData.shared.stories.append(x["story"] as? String ?? "😟Story not Available")
                            JsonData.shared.directorName.append(x["director"] as! String)
                            
                            //storing all actors in singleton variable
                            var allActors = [String]()
                            for actors in (x["actors"] as! [String])
                            {
                                allActors.append(actors)
                            }
                            JsonData.shared.actorName.append(allActors)
                            
                            //storing all trailers in singleton variable
                            let trailer = (x["trailers"] as! [String])[0]
                            let urlString = trailer.replacingOccurrences(of: " ", with: "%20")
                            let trailerPath = "https://www.brninfotech.com/tws/\(urlString)"
                            let avPlayer = AVPlayer(url: URL(string: trailerPath)!)
                            JsonData.shared.trailer.append(avPlayer)
                            
                            //storing all songs in singleton variable
                            var audios = [AVPlayer]()
                            let audioArray = x["songs"] as! [String]
                            for a in audioArray
                            {
                                let urlString = a.replacingOccurrences(of: " ", with: "%20")
                                print("songs:", urlString)
                                let songPath = "https://www.brninfotech.com/tws/\(urlString)"
                                let audio = AVPlayer(url: URL(string: songPath)!)
                                audios.append(audio)
                                
                            }
                            JsonData.shared.songs.append(audios)
                            JsonData.shared.songNames.append(audioArray)
                            
                            
                            i += 1
                            
                             self.pageControlObj.numberOfPages = i
                            print("SL No : ", i)
                            
                           
                            
                        }
                    }
                    posterDataTask.resume()
                    
                    //setting content size for scrollview
                    scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(movieJsonData.count), height: scrollView.frame.height)
                    
                    print("^^^^^^^^^^^^^^^^^^^^^: ",x["title"] as! String)
                    
                }
                
                else
                {
                    //adding subView in scrollView
                    let subView = UIView()
                    subView.frame = CGRect(x: CGFloat(i) * self.scrollView.frame.width, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
                    subView.backgroundColor = .black
                    self.scrollView.addSubview(subView)
                    
                    //to display posters in button
                    let posterBtn = UIButton()
                    //posterBtn.setImage(UIImage(named: "noposter"), for: UIControl.State.normal)
                    posterBtn.setTitle("No Movies Available😇", for: UIControl.State.normal)
                    posterBtn.layer.cornerRadius = 6
                    posterBtn.clipsToBounds = true
                    self.allButtonObj.append(posterBtn)
                    posterBtn.translatesAutoresizingMaskIntoConstraints = false
                    posterBtn.widthAnchor.constraint(equalToConstant: subView.frame.width).isActive = true
                    posterBtn.heightAnchor.constraint(equalToConstant: subView.frame.height).isActive = true
                    subView.addSubview(posterBtn)
                }
            }
            
        }
    func movieGenreDetails()
    {
        var i = 0
        for x in movieGenres
        {
            let posterBtn = UIButton()
            //posterBtn.frame = CGRect(x: CGFloat(i) * 180, y: 0, width: 170, height: self.genreScrollView.bounds.height)
            posterBtn.setImage(x, for: UIControl.State.normal)
            posterBtn.layer.cornerRadius = 6
            posterBtn.clipsToBounds = true
            
            let genreLbl = UILabel()
            genreLbl.text = genresNames[i]
            genreLbl.textColor = .white
            genreLbl.textAlignment = .center
            genreLbl.font = UIFont(name: "Georgia", size: 18)
            
            let genreStackView = UIStackView(arrangedSubviews: [posterBtn, genreLbl])
            genreStackView.frame = CGRect(x: CGFloat(i) * 180, y: 0, width: 170, height: self.genreScrollView.bounds.height)
            genreStackView.axis = .vertical
            genreStackView.distribution = .fill
            genreStackView.spacing = 10
            self.genreScrollView.addSubview(genreStackView)
            
            i += 1
            
            //setting content size for scrollview
            genreScrollView.contentSize = CGSize(width: 180 * CGFloat(movieGenres.count), height: genreScrollView.frame.height)
                            
        }
    }
            
        //MARK: - scrollview delegate method
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            pageControlObj.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            
        }
        

    }


