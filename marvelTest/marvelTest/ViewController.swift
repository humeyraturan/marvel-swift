

import UIKit

 


struct Character: Codable {
  let name: String
  let description: String?
  let thumbnail: Thumbnail
  let series: Series
  let stories: Stories
  let events: Events
  let comics: Comics
  var id: Int?
}

struct Comics: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Events: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Series: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Stories: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Item: Codable {
  let resourceURI: String
  let name: String
}

struct Thumbnail: Codable {
  let path: String
}

struct CharacterDataWrapper: Codable {
  let data: CharacterDataContainer
}

struct CharacterDataContainer: Codable {
  let results: [Character]
  let offset: Int
  let total: Int

  init(results: [Character], offset: Int, total: Int) {
      self.results = results
      self.offset = offset
      self.total = total
  }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    
    var characters = [Character]()
    
    var filteredChars: [Character] = []
    var likes: [String]!
    
    var isFetchingData = false
    var currentPage = 1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        fetchingApiData(URL: "https://gateway.marvel.com:443/v1/public/characters?ts=1690482116&apikey=3e3cfb2ebfc3dac4d734c0da13ab425c&hash=215b9cf7391359982b009d204bfbfcf4", page: self.currentPage, limit: 40) { data, response  in
            
            self.characters = data
            self.filteredChars.append(contentsOf: self.characters)
            self.likes = [String](repeating:"unlike", count: self.filteredChars.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  
        func fetchingApiData(URL urlString: String, page: Int, limit: Int, completion: @escaping ([Character], Int) -> Void) {
        let urlString = "\(urlString)&offset=\(page * limit)&limit=\(limit)"
        print("URL string is now \(urlString)")
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                return
            }
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Geçersiz yanıt.")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let characterDataWrapper = try decoder.decode(CharacterDataWrapper.self, from: data)
                    
                    let characters = characterDataWrapper.data.results
                    let total = characterDataWrapper.data.results.count
                    print("API Cevabı:")
                    completion(characters, total)
                } catch {
                    print("JSON dönüştürme hatası: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let threshold = tableView.contentSize.height - 100 - scrollView.frame.size.height
        
        if position > threshold && !self.isFetchingData {
                
                self.isFetchingData = true

                var currentPage = 1
                if characters.count > 0 {
                    currentPage = characters.count / 40 + 1
                }

                
                let limit = 40
                
                
                fetchingApiData(URL: "https://gateway.marvel.com/v1/public/characters?ts=1690482116&apikey=3e3cfb2ebfc3dac4d734c0da13ab425c&hash=215b9cf7391359982b009d204bfbfcf4", page: currentPage, limit: limit) { data, total in
                    self.currentPage += 1
                    
                    self.characters.append(contentsOf: data)
                    self.filteredChars = self.characters
                    self.likes = [String](repeating:"unlike", count: self.filteredChars.count)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.isFetchingData = false
                }
            }
        }
    }


    extension ViewController {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var character = filteredChars[indexPath.row]
               character.id = indexPath.row
               
        print("selected cell \(indexPath.row)" + character.name)
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController{
            
            let imageURLString =  "\(character.thumbnail.path)/portrait_xlarge.jpg"
            loadImageFromURL(urlString: imageURLString) { image in
                if let image = image {
                    
                    vc.img = image
                    print("Resim yüklendi.")
                    
                } else {
                    
                    print("Resim yüklenirken hata oluştu.")
                }
            }
                    
                    vc.user_name = filteredChars[indexPath.row].name
                    let seriesNames = filteredChars[indexPath.row].series.items.map { $0.name }
                    let combinedNames = seriesNames.joined(separator: ", ")
                    vc.series = combinedNames
                    
                    let storyNames = filteredChars[indexPath.row].stories.items.map { $0.name }
                    let combinedStoryNames = storyNames.joined(separator: ", ")
                    vc.stories = combinedStoryNames
                    
                    let eventNames = filteredChars[indexPath.row].events.items.map { $0.name }
                    let combinedEventNames = eventNames.joined(separator: ", ")
                    vc.events = combinedEventNames
                    
                    let comicNames = filteredChars[indexPath.row].comics.items.map { $0.name }
                    let combinedComicNames = comicNames.joined(separator: ", ")
                    vc.comics = combinedComicNames
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
    
    
        func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = URL(string: urlString) else {
            completion(nil)
            return
        }

        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Resim yüklenirken hata oluştu: \(error)")
                completion(nil)
                return
            }

            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! CharacterCell
        
        
        var character = filteredChars[indexPath.row]
        character.id = indexPath.row
        cell.tblName.text = character.name
        
        cell.charImage.load(urlString: "\(character.thumbnail.path)/portrait_xlarge.jpg")
        cell.favButton.tag = character.id!
        cell.favButton.addTarget(self, action: #selector(handleClick), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    @IBAction func handleClick(sender: UIButton) {
        print(sender.tag)
        if likes[sender.tag] == "like" {
            likes[sender.tag] = "unlike"
            let filledHeartImage = UIImage(systemName: "suit.heart")
            sender.setImage(filledHeartImage, for: .normal)
        } else {
            likes[sender.tag] = "like"
            let filledHeartImage = UIImage(systemName: "suit.heart.fill")
            sender.setImage(filledHeartImage, for: .normal)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredChars = searchText.isEmpty ? characters : characters.filter({(char: Character)->Bool in
            let name = char.name
            return name.range(of: searchText, options: .caseInsensitive) != nil
        })
                
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension UIImageView {
    
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.image = image
                            }
                        }
                    }
                }
            }
        }

