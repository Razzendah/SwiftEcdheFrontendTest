import Foundation
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif

// The Problem:
// Swift doesn't allow @main attribute when there's top-level code (imports) in the same file
// The compiler was confused about the entry point
// The Solution:
// Removed the @main struct wrapper
// Converted to traditional Swift top-level execution
// Made testCryptoAvailability() a regular function
// Called the functions directly at the top level
// What the code now does:
// Imports the necessary crypto libraries
// Prints the application banner
// Tests crypto availability with a dedicated function
// Creates and runs the ECDHE frontend
/*
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
*/

// Main entry point
print("🔐 ECDHE Swift CLI - Frontend")
print("============================")

// Test CryptoKit/Crypto availability
func testCryptoAvailability() {
    do {
        // Test symmetric key generation
        let symmetricKey = SymmetricKey(size: .bits256)
        print("✅ Symmetric key generation: SUCCESS (\(symmetricKey.bitCount) bits)")
        
        // Test P-256 ECDHE key generation
        let privateKey = P256.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        print("✅ P-256 ECDHE key generation: SUCCESS")
        print("   Public key size: \(publicKey.rawRepresentation.count) bytes")
        print("   DER format size: \(publicKey.derRepresentation.count) bytes")
        
        // Test AES-GCM
        let data = "Hello, ECDHE!".data(using: .utf8)!
        let sealedData = try AES.GCM.seal(data, using: symmetricKey)
        let decryptedData = try AES.GCM.open(sealedData, using: symmetricKey)
        print("✅ AES-GCM encryption/decryption: SUCCESS")
    } catch {
        print("❌ Crypto test failed: \(error)")
    }
}

testCryptoAvailability()

// Initialize ECDHE
let ecdheFrontend = ECDHEFrontend()
ecdheFrontend.run()
