import Foundation
import UIKit
import AVFoundation
import GameKit
private let reuseIdentifier = "subCell"
class SubtractionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellNumber: UILabel!
}
class SubtractionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var timer = Timer()
    var second = 60
    var arrayOfNumbers = [arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1]
    var selNum = 1
    var val1 = 0
    var val2 = 0
    var total = 0
    var score = 0
    var playAttempts = [PlayAttempt]()
    var currentPlayAttempt = PlayAttempt()
    var selectionsPlayed: Int = 0
    @IBOutlet weak var subtractionCollection: UICollectionView!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gameOver") {
        var gameOverViewController = segue.destination as! GameOverViewController
        gameOverViewController.finalScoreNumber = score
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        subtractionCollection.delegate = self
        subtractionCollection.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SubtractionViewController.timerTick), userInfo: nil, repeats: true)
        let topColor = UIColor(red: (255/255.0), green: (253/255.0), blue: (191/255.0), alpha: 1)
        let bottomColor = UIColor(red: (254/255.0), green: (253/255.0), blue: (120/255.0), alpha: 1)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    @objc func timerTick() {
        second -= 1
        if second == 0 {
            labelTimer.textColor = UIColor.red
            timer.invalidate()
            performSegue(withIdentifier: "gameOver", sender: nil)
        }
        labelTimer.text = "\(second)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfNumbers.count
    }
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SubtractionViewCell
        let number = arrayOfNumbers[indexPath.row]
        print(number)
        subCell.cellNumber.text = String(number)
        subCell.backgroundColor = UIColor.cyan
        subCell.layer.borderColor = UIColor.black.cgColor
        subCell.layer.borderWidth = 1
        subCell.layer.cornerRadius = 8
        return subCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("entered did select that item")
        let subCell = collectionView.cellForItem(at: indexPath)as! SubtractionViewCell
        print ("assigned cell")
        if selNum == 1 {
            currentPlayAttempt = PlayAttempt()
            selectionsPlayed += 1
            print ("entering selection 1")
            val1 = Int(subCell.cellNumber.text!)!
            selNum = selNum + 1
            subCell.backgroundColor = UIColor(red: (255/255.0), green: (179/255.0), blue: (71/255.0), alpha: 1)
            currentPlayAttempt.Number1 = val1
        }
        else if selNum == 2 {
            print ("entering selection 2")
            val2 = Int(subCell.cellNumber.text!)!
            selNum = selNum + 1
            subCell.backgroundColor = UIColor(red: (255/255.0), green: (179/255.0), blue: (71/255.0), alpha: 1)
            currentPlayAttempt.Number2 = val2
        }
        else if selNum == 3 {
            print ("entering total")
            total = Int(subCell.cellNumber.text!)!
            selNum = 1
            currentPlayAttempt.FinalScore = total
            var hasSelectionBeenPlayed: Bool = false
            if selectionsPlayed > 1 {
                print("Number of items in PlayAttempts: \(playAttempts.count)")
                for selection in playAttempts {
                    print("First selection Number 1: \(selection.Number1)")
                    print("First selection Number 2: \(selection.Number2)")
                    print("First selection Final Score: \(selection.FinalScore)")
                    if selection.Number1 == currentPlayAttempt.Number1 && selection.Number2 == currentPlayAttempt.Number2 && selection.FinalScore == currentPlayAttempt.FinalScore {
                        hasSelectionBeenPlayed = true
                        subCell.backgroundColor = UIColor.red
                        break
                    }
                }
            }
            if hasSelectionBeenPlayed == false {
                print("has been played = false so calculate score!")
                playAttempts.append(currentPlayAttempt)
                print("appended the score to the playattempt array")
                if total == val1 - val2 {
                    score = score + 5
                    second = second + 3
                    scoreLabel.text = String(score)
                    subCell.backgroundColor=UIColor.green
                    SubtractionViewController.vibrate()
                    saveHighScore(number: score)
                }
                else {
                    subCell.backgroundColor = UIColor.red
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let subCell = collectionView.cellForItem(at: indexPath)
        subCell?.backgroundColor = UIColor.cyan
    }
    func saveHighScore(number : Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "com.score.mathercise")
            scoreReporter.value = Int64(number)
            let scoreArray : [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    @IBAction func newBoard(_ sender: Any) {
        arrayOfNumbers = [arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1]
        self.subtractionCollection.reloadData()
        self.subtractionCollection.reloadItems(at: subtractionCollection.indexPathsForVisibleItems)
        playAttempts.removeAll()
        selNum = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
