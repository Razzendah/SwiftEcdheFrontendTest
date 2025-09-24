import XCTest
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif
@testable import ECDHESwiftCLI

final class ECDHESwiftCLITests: XCTestCase {
    
    func testCryptoKitAvailability() throws {
        // Test that we can create symmetric keys
        let key = SymmetricKey(size: .bits256)
        XCTAssertEqual(key.bitCount, 256)
    }
    
    func testP256KeyGeneration() throws {
        // Test P-256 key generation
        let privateKey = P256.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        
        // Verify key properties
        // P-256 public key in raw format is 64 bytes (32 bytes X + 32 bytes Y coordinates)
        // This is the compressed/compact format used by CryptoKit
        XCTAssertEqual(publicKey.rawRepresentation.count, 64) // Compact format: 32 + 32 (X + Y coordinates)
        XCTAssertGreaterThan(publicKey.derRepresentation.count, 0)
        
        // Additional verification - DER format should be larger than raw
        XCTAssertGreaterThan(publicKey.derRepresentation.count, publicKey.rawRepresentation.count)
    }
    
    func testAESGCMEncryption() throws {
        // Test AES-GCM encryption/decryption
        let key = SymmetricKey(size: .bits256)
        let plaintext = "Hello, ECDHE Swift CLI!".data(using: .utf8)!
        
        // Encrypt
        let sealedData = try AES.GCM.seal(plaintext, using: key)
        
        // Decrypt
        let decryptedData = try AES.GCM.open(sealedData, using: key)
        
        XCTAssertEqual(decryptedData, plaintext)
    }
    
    func testECDHEKeyExchange() throws {
        // Test complete ECDHE key exchange
        let alicePrivateKey = P256.KeyAgreement.PrivateKey()
        let bobPrivateKey = P256.KeyAgreement.PrivateKey()
        
        let alicePublicKey = alicePrivateKey.publicKey
        let bobPublicKey = bobPrivateKey.publicKey
        
        // Perform key agreement from both sides
        let aliceSharedSecret = try alicePrivateKey.sharedSecretFromKeyAgreement(with: bobPublicKey)
        let bobSharedSecret = try bobPrivateKey.sharedSecretFromKeyAgreement(with: alicePublicKey)
        
        // Derive symmetric keys
        let sharedInfo = Data("ECDHE-AES-GCM-256".utf8)
        let aliceKey = aliceSharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: Data(),
            sharedInfo: sharedInfo,
            outputByteCount: 32
        )
        let bobKey = bobSharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: Data(),
            sharedInfo: sharedInfo,
            outputByteCount: 32
        )
        
        // Test that both parties derived the same key by encrypting/decrypting
        let testData = "Test message".data(using: .utf8)!
        let encryptedByAlice = try AES.GCM.seal(testData, using: aliceKey)
        let decryptedByBob = try AES.GCM.open(encryptedByAlice, using: bobKey)
        
        XCTAssertEqual(decryptedByBob, testData)
    }
    
    func testECDHEFrontendInitialization() throws {
        // Test that ECDHEFrontend can be instantiated
        let frontend = ECDHEFrontend()
        XCTAssertNotNil(frontend)
    }
}
