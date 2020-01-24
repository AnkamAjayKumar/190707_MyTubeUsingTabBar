//
//  BollywoodMovieDetails.swift
//  NavigationVC_TabVC
//
//  Created by Ankam Ajay Kumar on 14/12/19.
//  Copyright © 2019 Ankam Ajay Kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class BollywoodMovieDetails: UIViewController {

    //MARK:- IBOutlet Properties
        @IBOutlet weak var posterImageView: UIImageView!
        @IBOutlet weak var contentView: UIView!
        @IBOutlet weak var videoView: UIView!
        @IBOutlet weak var titleLbl: UILabel!
        @IBOutlet weak var actorNameLbl: UILabel!
        @IBOutlet weak var directorNameLbl: UILabel!
        @IBOutlet weak var storyTextView: UITextView!
        @IBOutlet weak var songsStackView: UIStackView!
            
        //instance creation
        var audioBtn:UIButton!
        var audioButtonSelected:Int?
        var audioButtonArray = [UIButton]()
        var avPlayerController:AVPlayerViewController!
        var audioPlayerController:AVPlayerViewController!
        
            
        //MARK:- viewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
                
            //JsonData.shared.songs[0][0].play()
            jsonMovieDetails()
        }
            
        //MARK:- Method Creation
        //method to display json data in movie details view controller
        func jsonMovieDetails()
        {
            posterImageView.image = JsonData.shared.posters[JsonData.shared.buttonTapped]
            
            storyTextView.text = JsonData.shared.stories[JsonData.shared.buttonTapped]
            titleLbl.text = JsonData.shared.title[JsonData.shared.buttonTapped]
            directorNameLbl.text = JsonData.shared.directorName[JsonData.shared.buttonTapped]
            
            //to display all actors
            var actors = String()
            for selectedActor in JsonData.shared.actorName[JsonData.shared.buttonTapped]
            {
                actors = actors + selectedActor + ", "
            }
            actorNameLbl.text = actors
            
            //to display all trailers
            avPlayerController = AVPlayerViewController()
            avPlayerController.player = JsonData.shared.trailer[JsonData.shared.buttonTapped]
            avPlayerController.view.frame = CGRect(x: 0 , y: 0, width: videoView.frame.width, height: videoView.frame.height)
            avPlayerController.player?.play()
            self.videoView.addSubview(avPlayerController.view)
                
            //to display all songs
            var i = 0
            var noOfSongs = 1
            for x in JsonData.shared.songs[JsonData.shared.buttonTapped]
            {
                
                audioBtn = UIButton()
                audioBtn.setTitle("Song \(noOfSongs)", for: UIControl.State.normal)
                audioBtn.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: UIControl.State.normal)
                audioBtn.backgroundColor = .white
                audioBtn.layer.cornerRadius = 5
                audioBtn.clipsToBounds = true
                //audioBtn.pulseButton()
                audioBtn.addTarget(self, action: #selector(audioToPlay(playBtn:)), for: UIControl.Event.touchUpInside)
                audioBtn.tag = i
                //audioBtn.pulseButton()
                songsStackView.addArrangedSubview(audioBtn)
                i += 1
                noOfSongs += 1
            }
                
        }
           
        //to play songs
        @objc func audioToPlay(playBtn:UIButton)
        {
            //pause video trailer when back to home
            avPlayerController.player?.pause()
            
            audioPlayerController = AVPlayerViewController()
            
            print(JsonData.shared.songs[JsonData.shared.buttonTapped])
            
            audioPlayerController.player = JsonData.shared.songs[JsonData.shared.buttonTapped][playBtn.tag]
            audioPlayerController.player?.play()
            print("songs are:", audioPlayerController.player)
                
            let posterImage = UIImageView()
            posterImage.frame = CGRect(x: 0, y: 200, width: 420, height: 500)
            posterImage.image = JsonData.shared.posters[JsonData.shared.buttonTapped]
            audioPlayerController.contentOverlayView?.addSubview(posterImage)
        
            present(audioPlayerController, animated: true, completion: nil)
             
        }

    }
