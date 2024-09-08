import MiniAppCore
import WeatherMiniApp
import TicTacToeMiniApp

struct MiniAppModel {
    
    // MARK: - Properties
    
    let miniApps: [MiniAppProtocol]
    
    // MARK: - Initializers
    
    init() {
        self.miniApps = MiniAppModel.createMiniApps()
    }
}

// MARK: - Private Methods

private extension MiniAppModel {
    
    static func createMiniApps() -> [MiniAppProtocol] {
        let configurations: [MiniAppConfiguration] = [
            MiniAppConfiguration(backgroundColor: .systemBlue, textColor: .white, font: .boldSystemFont(ofSize: 18)),
            MiniAppConfiguration(backgroundColor: .systemOrange, textColor: .black, font: .systemFont(ofSize: 16)),
            MiniAppConfiguration(backgroundColor: .systemYellow, textColor: .white, font: .systemFont(ofSize: 21)),
            MiniAppConfiguration(backgroundColor: .systemGreen, textColor: .black, font: .italicSystemFont(ofSize: 14)),
            MiniAppConfiguration(backgroundColor: .systemRed, textColor: .white, font: .systemFont(ofSize: 15)),
            MiniAppConfiguration(backgroundColor: .systemPurple, textColor: .black, font: .boldSystemFont(ofSize: 20))
        ]
        
        var miniApps: [MiniAppProtocol] = []
        
        for config in configurations {
            let weatherMiniApp = WeatherMiniApp()
            weatherMiniApp.configure(with: config)
            
            let ticTacToeMiniApp = TicTacToeMiniApp()
            ticTacToeMiniApp.configure(with: config)
            
            miniApps.append(weatherMiniApp)
            miniApps.append(ticTacToeMiniApp)
        }
        
        miniApps.shuffle()
        
        return miniApps
    }
}
