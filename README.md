# ECDHE Swift CLI - Frontend

A Swift command-line application implementing ECDHE (Elliptic Curve Diffie-Hellman Ephemeral) key exchange with AES-GCM-256 encryption, compatible with the Java backend implementation.

## Features

- **ECDHE Key Exchange**: P-256 curve with ephemeral keys
- **Key Derivation**: HKDF (HMAC-based Key Derivation Function) with nonces
- **Encryption**: AES-GCM-256 for authenticated encryption
- **Key Formats**: Support for both X.509/DER and X9.63 formats
- **Cross-Platform**: Compatible with Java backend for testing
- **JSON Support**: Structured data exchange with nonces

## Requirements

- Swift 5.8+
- **Apple Platforms** (macOS 13+, iOS 16+): Uses native CryptoKit for optimal performance
- **Cross-Platform** (Windows, Linux): Uses Swift Crypto for compatibility  
- Xcode 14.0+ (for macOS/iOS development)

## Building and Running

### Using Swift Package Manager

```bash
# Navigate to the Swift project directory
cd ECDHEPartyA-Swift

# Build the project
swift build

# Run the application
swift run
```

### Using Xcode

1. Open `Package.swift` in Xcode
2. Build and run the project

## Usage

The application provides an interactive menu with the following options:

1. **Initialize Master Keys**: Generate ECDHE key pair and display public key
2. **Complete Key Exchange**: Enter the backend's public key to derive shared secret
3. **Verify Keys Match**: Display key verification data for comparison
4. **Test JSON Key Exchange**: Create JSON key exchange data with nonces
5. **Encrypt Data**: Encrypt plaintext using AES-GCM-256
6. **Decrypt Data**: Decrypt ciphertext using AES-GCM-256
7. **Test JSON Encryption**: Encrypt data and format as JSON
8. **Exit**: Close the application

## Key Exchange Process

1. **Frontend (Swift)**: Generate key pair and share public key
2. **Backend (Java)**: Receive public key and generate own key pair
3. **Both**: Derive shared secret using ECDHE
4. **Both**: Derive AES-256 key using HKDF with nonces
5. **Both**: Encrypt/decrypt data using AES-GCM-256

## Cross-Platform Compatibility

This Swift implementation is designed to be compatible with the Java backend:

- **Key Formats**: Supports both X.509/DER (Java standard) and X9.63 (mobile-friendly)
- **HKDF**: Uses the same HKDF parameters as the Java implementation
- **AES-GCM**: Compatible encryption parameters and data formats
- **JSON Format**: Same structure for key exchange and encrypted data

## Architecture

```
Sources/
├── main.swift                 # Application entry point and CLI menu
├── ConsoleUI.swift           # User interface handling
├── KeyExchangeService.swift  # High-level key exchange operations
├── KeyService.swift          # ECDHE key generation and HKDF
├── EncryptionService.swift   # AES-GCM encryption/decryption
└── X963KeyConverter.swift    # Key format conversion utilities
```

## Security Features

- **Ephemeral Keys**: New key pair generated for each session
- **Perfect Forward Secrecy**: Compromise of long-term keys doesn't affect past communications
- **Authenticated Encryption**: AES-GCM provides both confidentiality and authenticity
- **Secure Nonces**: Cryptographically secure random nonce generation
- **Key Verification**: Ability to verify derived keys match between parties

## Example Session

```
🔐 ECDHE Frontend Swift CLI - Secure Key Exchange & Encryption
═════════════════════════════════════════════════════════════
Version: 1.0.0 (Auto-detects CryptoKit/Swift Crypto)
Compatible with Java Backend for cross-platform testing
Algorithms: ECDHE (P-256), HKDF, AES-GCM-256
═════════════════════════════════════════════════════════════

Choose an option:
1. Initialize Master Keys (Generate and display public key)
2. Complete Key Exchange (Enter Backend's public key)
3. Verify Keys Match (Check if derived AES keys are identical)
4. Test JSON Key Exchange (With nonces)
5. Encrypt Data (AES-GCM-256)
6. Decrypt Data (AES-GCM-256)
7. Test JSON Encryption
8. Exit
Enter your choice (1-8): 1

Generating new ECDHE key pair...
Select key encoding format:
1. X.509/DER (Standard Java format - for Java-to-Java communication)
2. X9.63 (Mobile-friendly format - for Android/iOS apps)
Enter your choice (1-2): 2

=== Your Public Key (X9.63 format) ===
Share this public key with the Backend:
----------------------------------------
BHxL2Z8V3qF5mN7Kp4R9Wb6E1Q8Yt2Xc3Vf7Gu9In0Jm5Lk8Pw...
----------------------------------------
⚠️ Keep this key safe but it's okay to share publicly

✅ Key pair generated successfully!
```

## Testing with Java Backend

1. Run the Swift frontend and initialize keys (option 1)
2. Copy the generated public key
3. Run the Java backend and paste the public key
4. Copy the backend's generated public key
5. Return to Swift frontend and complete key exchange (option 2)
6. Verify keys match using option 3
7. Test encryption/decryption between both applications

## Troubleshooting

- **Build Errors**: Ensure you're using Swift 5.7+ and macOS 13.0+
- **CryptoKit Issues**: Make sure you're targeting a supported platform version
- **Key Exchange Failures**: Verify the public key format matches what the backend expects
- **Encryption Errors**: Ensure key exchange was completed successfully before encrypting

## License

This project is licensed under the MIT License - see the LICENSE file for details.
