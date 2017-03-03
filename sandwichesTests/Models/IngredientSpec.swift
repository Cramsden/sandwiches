import Foundation
import Quick
import Nimble

@testable import sandwiches
class IngredientSpec: QuickSpec {
    override func spec() {
        describe("Ingredient") {
            
            describe("takesOneForPrep") {
            
                context("when amount is greater than zero") {
                    it("returns an ingredient with the amount decremented") {
                        var ingredient = Ingredient(name: "Pastrami", details: "Tasty tasty pastrami", amount: 5, bestBy: Date(), category: .meat)
                        
                        let prepIngredient = ingredient.takeOneForPrep()
                        
                        expect(prepIngredient?.name).to(equal(ingredient.name))
                        expect(prepIngredient?.amount).to(equal(1))
                        expect(ingredient.amount).to(equal(4))
                    }
                }
                
                context("when there are none left") {
                    it("return nil") {
                        var ingredient = Ingredient(name: "Corn", details: "This is of the sangwich corn varietal", amount: 0, bestBy: Date(), category: .spread)
                        
                        let prepIngredient = ingredient.takeOneForPrep()
                        
                        expect(prepIngredient).to(beNil())
                        expect(ingredient.amount).to(equal(0))
                    }
                }
            }
            
        }
    }
}
