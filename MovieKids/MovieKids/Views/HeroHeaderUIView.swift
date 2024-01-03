//
//  HeroHeaderUIView.swift
//  MovieKids Project (Netflix Clone)
//
//  Created by Mahmud Cikrik on 01/12/2023.
//

import UIKit

protocol HeroHeaderUIViewPlayDelegate: AnyObject {
    func DidTapPlayButton( header: HeroHeaderUIView, viewModel: TitlePreviewViewModel)
}

class HeroHeaderUIView: UIView {
    
    var randomTitle: Title?
    weak var delegate: HeroHeaderUIViewPlayDelegate?
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        
        return imageView
    }()

    
    public func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.startPoint = CGPoint( x: 0.0, y: 0.4) // (0,0): sol üst köşe
        gradientLayer.endPoint = CGPoint(x:0.0, y: 0.99)   // (1,1): sağ alt köşe
        
        gradientLayer.frame = bounds
        layer.mask = gradientLayer
        layer.addSublayer(gradientLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        setupDownloadButton()
        setupPlayButton()
        applyConstraints()
    }
    
    private func applyConstraints() {
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupDownloadButton() {
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }

    @objc private func downloadButtonTapped() {
        downloadTitle()
    }
    
    private func setupPlayButton() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    private func playTitle() {
        guard let title = randomTitle else { return }
        guard let titleName = title.title ?? title.original_title ?? title.original_name else {
            return
        }


        APICaller.shared.getMovie(with: "\(titleName) trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.randomTitle
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.DidTapPlayButton(header: strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }

    @objc private func playButtonTapped() {
        playTitle()
        
    }
    
    private func downloadTitle() {
        guard let model = randomTitle else { return }
        DataPersistenceManager.shared.downloadTitleWith(model: model) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


