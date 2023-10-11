class SuperEnemy {
    var name: String
    var hitPoints: Int
    
    init(name: String, hitPoints: Int) {
        self.name = name
        self.hitPoints = hitPoints
    }
}
protocol Superhero {
    var name: String { get }
    var alias: String { get }
    var isEvil: Bool { get }
    var superPowers: [String: Int] { get set }
    
    func attack(target: SuperEnemy) -> Int
    mutating func performSuperPower(target: SuperEnemy) -> Int
}
extension Superhero {
    func printSuperheroInfo() {
        print("Name: \(name), Alias: \(alias), Evil: \(isEvil)")
        print("Remaining Superpowers: \(superPowers)")
    }
}
struct SpiderMan: Superhero {
    var name: String
    var alias: String
    var isEvil: Bool
    var superPowers: [String: Int]
    
    func attack(target: SuperEnemy) -> Int {
        let damage = Int.random(in: 20...40)
        target.hitPoints -= damage
        return target.hitPoints
    }
    
    mutating func performSuperPower(target: SuperEnemy) -> Int {
        guard let superPower = superPowers.keys.sorted().first else {
            return attack(target: target)
        }
        
        if let damage = superPowers.removeValue(forKey: superPower) {
            target.hitPoints -= damage
            print("\(name) used \(superPower) against \(target.name) for \(damage) damage!")
            return target.hitPoints
        } else {
            return attack(target: target)
        }
    }
}

class SuperheroSquad {
    var superheroes: [Superhero]
    
    init(superheroes: [Superhero]) {
        self.superheroes = superheroes
    }
    
    func listSuperheroes() {
        print("Superhero Squad:")
        for superhero in superheroes {
            superhero.printSuperheroInfo()
        }
    }
}

func simulateShowdown(squad: inout SuperheroSquad, enemy: SuperEnemy) {
    var remainingSuperheroes = squad.superheroes.count
    
    while enemy.hitPoints > 0 && remainingSuperheroes > 0 {
        for i in 0..<squad.superheroes.count {
            
            var hero = squad.superheroes[i]
            
            if hero.superPowers.isEmpty {
                let remainingLife = hero.attack(target: enemy)
                print("\(hero.name) performed a normal attack against \(enemy.name)! Remaining life: \(remainingLife)")
            } else {
                let remainingLife = hero.performSuperPower(target: enemy)
                print("\(hero.name) performed a superpower against \(enemy.name)! Remaining life: \(remainingLife)")
                
                if hero.superPowers.isEmpty {
                    remainingSuperheroes -= 1
                    print("\(hero.name) has run out of superpowers!")
                }
            }
            
            if enemy.hitPoints <= 0 {
                print("The enemy \(enemy.name) lost!")
                return
            }
        }
    }
    
    if remainingSuperheroes <= 0 {
        print("The superhero squad has run out of superheroes. The enemy \(enemy.name) won!")
    }
}

var superman = SpiderMan(name: "SpiderMan", alias: "Peter Parker", isEvil: false, superPowers: ["Web Slinging": 25, "Spider Sense": 30])
var ironman = SpiderMan(name: "Electro", alias: "Max Dillon", isEvil: false, superPowers: ["Electrical manipulation and generation.": 30, "Repulsor Beams": 40])
var squad = SuperheroSquad(superheroes: [superman, ironman])

var enemy = SuperEnemy(name: "Mysterio", hitPoints: 100)

simulateShowdown(squad: &squad, enemy: enemy)
