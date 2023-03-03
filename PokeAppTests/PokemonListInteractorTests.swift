import XCTest
@testable import PokeApp

final class PokemonListInteractorTests: XCTestCase {
    
    private var presenterSpy: PokemonListPresenterSpy!
    private var serviceSpy: PokemonServiceSpy!
    private var storageSpy: PokemonCacheStorageSpy!
    
    private var sut: PokemonListInteractor!
    
    override func setUp() {
        super.setUp()

        serviceSpy = PokemonServiceSpy()
        presenterSpy = PokemonListPresenterSpy()
        storageSpy = PokemonCacheStorageSpy()
        
        sut = PokemonListInteractor(presenter: presenterSpy, service: serviceSpy, storage: storageSpy)
    }

    override func tearDown() {
        presenterSpy = nil
        serviceSpy = nil
        storageSpy = nil
        sut = nil
        super.tearDown()
    }
}

// MARK: - Tests
extension PokemonListInteractorTests {
    func testSetupInitialScreen() {
        // act
        sut.setupInitialData()

        // assert
        XCTAssert(presenterSpy.presentLoaderInvoked)
        XCTAssert(serviceSpy.fetchPokemonsInvoked)
        XCTAssert(storageSpy.savePokemonsInvoked)
        XCTAssert(presenterSpy.presentPokemonsInvoked)
        XCTAssert(serviceSpy.fetchPokemonDetailsInvoked)
    }
    
    func testSetupInitialScreenError() {
        // arrange
        serviceSpy.fetchPokemonsSucceed = false
        
        // act
        sut.setupInitialData()

        // assert
        XCTAssert(presenterSpy.presentLoaderInvoked)
        XCTAssert(serviceSpy.fetchPokemonsInvoked)
        XCTAssertFalse(storageSpy.savePokemonsInvoked)
        XCTAssertFalse(presenterSpy.presentPokemonsInvoked)
        XCTAssertFalse(serviceSpy.fetchPokemonDetailsInvoked)
    }

    
    func testReload() {
        // act
        sut.reload()

        // assert
        XCTAssertFalse(presenterSpy.presentLoaderInvoked)
        XCTAssert(serviceSpy.fetchPokemonsInvoked)
        XCTAssert(storageSpy.clearInvoked)
        XCTAssert(storageSpy.savePokemonsInvoked)
        XCTAssert(presenterSpy.presentPokemonsInvoked)
        XCTAssert(serviceSpy.fetchPokemonDetailsInvoked)
    }
    
    func testLoadMorePokemons() {
        // act
        sut.loadMorePokemons()

        // assert
        XCTAssert(serviceSpy.uploadPokemonsInvoked)
    }
}
