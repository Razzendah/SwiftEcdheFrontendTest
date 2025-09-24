import Foundation
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif

@main
struct ECDHESwiftCLI {
    static func main() {
        print("🔐 ECDHE Swift CLI - Frontend")
        print("============================")
        
        // Test CryptoKit/Crypto availability
        testCryptoAvailability()
        
        // Initialize ECDHE
        let ecdheFrontend = ECDHEFrontend()
        ecdheFrontend.run()
    }
    
    static func testCryptoAvailability() {
        do {
            // Test symmetric key generation
            let symmetricKey = SymmetricKey(size: .bits256)
            print("✅ Symmetric key generation: SUCCESS (\(symmetricKey.bitCount) bits)")
            
            // Test P-256 ECDHE key generation
            let privateKey = P256.KeyAgreement.PrivateKey()
            let publicKey = privateKey.publicKey
            print("✅ P-256 ECDHE key generation: SUCCESS")
            print("   Public key size: \(publicKey.rawRepresentation.count) bytes")
            
            // Test AES-GCM
            let data = "Hello, ECDHE!".data(using: .utf8)!
            let sealedData = try AES.GCM.seal(data, using: symmetricKey)
            let decryptedData = try AES.GCM.open(sealedData, using: symmetricKey)
            print("✅ AES-GCM encryption/decryption: SUCCESS")
            
        } catch {
            print("❌ Crypto test failed: \(error)")
        }
    }
}
