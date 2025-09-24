import Foundation
#if canImport(CryptoKit)
import CryptoKit
#else
import Crypto
#endif

/// ECDHE Frontend implementation for key exchange and encryption
class ECDHEFrontend {
    private var privateKey: P256.KeyAgreement.PrivateKey?
    private var sharedKey: SymmetricKey?
    
    func run() {
        print("\n📋 Available Operations:")
        print("1. Initialize Master Keys")
        print("2. Complete Key Exchange")
        print("3. Verify Keys Match")
        print("4. Test JSON Key Exchange")
        print("5. Encrypt Data")
        print("6. Decrypt Data")
        print("7. Exit")
        
        // For now, just run a basic test
        initializeMasterKeys()
    }
    
    /// Generate ECDHE key pair and display public key
    func initializeMasterKeys() {
        print("\n🔑 Initializing Master Keys...")
        
        do {
            // Generate P-256 private key
            privateKey = P256.KeyAgreement.PrivateKey()
            guard let privateKey = privateKey else {
                print("❌ Failed to generate private key")
                return
            }
            
            let publicKey = privateKey.publicKey
            
            // Display public key in different formats
            print("✅ ECDHE Key Pair Generated Successfully!")
            print("\n📤 Public Key (X9.63 format):")
            print(publicKey.rawRepresentation.base64EncodedString())
            
            print("\n📤 Public Key (X.509/DER format):")
            print(publicKey.derRepresentation.base64EncodedString())
            
            print("\n📊 Key Information:")
            print("   Algorithm: P-256 ECDHE")
            print("   Key Size: 256 bits")
            print("   Raw Size: \(publicKey.rawRepresentation.count) bytes")
            print("   DER Size: \(publicKey.derRepresentation.count) bytes")
            
        } catch {
            print("❌ Key generation failed: \(error)")
        }
    }
    
    /// Derive shared secret from partner's public key
    func completeKeyExchange(partnerPublicKeyBase64: String) {
        guard let privateKey = privateKey else {
            print("❌ No private key available. Initialize master keys first.")
            return
        }
        
        do {
            // Decode partner's public key
            guard let partnerKeyData = Data(base64Encoded: partnerPublicKeyBase64) else {
                print("❌ Invalid base64 public key")
                return
            }
            
            let partnerPublicKey = try P256.KeyAgreement.PublicKey(rawRepresentation: partnerKeyData)
            
            // Perform key agreement
            let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: partnerPublicKey)
            
            // Derive symmetric key using HKDF
            sharedKey = sharedSecret.hkdfDerivedSymmetricKey(
                using: SHA256.self,
                salt: Data(),
                sharedInfo: Data("ECDHE-AES-GCM-256".utf8),
                outputByteCount: 32
            )
            
            print("✅ Key exchange completed successfully!")
            print("   Shared secret derived")
            print("   Symmetric key ready for AES-GCM-256")
            
        } catch {
            print("❌ Key exchange failed: \(error)")
        }
    }
}
