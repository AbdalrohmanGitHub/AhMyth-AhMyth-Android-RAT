#!/bin/bash
# Update README_KALI.md with Java requirements

# Create a temporary file with the updated content
cat > README_KALI_temp.md << 'EOL'
# AhMyth Android RAT - Kali Linux Setup Guide

## 📋 Overview
AhMyth is a powerful Android Remote Access Tool (RAT) designed for ethical hacking and security testing. This guide provides comprehensive setup instructions specifically for Kali Linux.

## ⚠️ Legal & Ethical Warning
**This tool is for educational and authorized security testing purposes only.**
- Only test on devices you own or have explicit written permission to test
- Unauthorized use constitutes illegal activity
- Use responsibly and follow all applicable laws

## 🛠️ Prerequisites

### System Requirements
- Kali Linux (recommended) or any Debian-based Linux distribution
- Minimum 4GB RAM (8GB recommended)
- 10GB free disk space
- Android device for testing (physical or emulator)

### Required Packages
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install Java (REQUIRED for Android APK building)
# Option 1: Java 17 (recommended)
sudo apt install -y openjdk-17-jdk

# Option 2: Java 11 (minimum required)
sudo apt install -y openjdk-11-jdk

# Set Java 17 as default (recommended)
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac

# Alternative: Set Java 11 as default
# sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java
# sudo update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac

# Verify Java installation
java -version
javac -version

# Install Android SDK tools
sudo apt install -y android-sdk android-sdk-platform-tools

# Install Git
sudo apt install -y git

# Install build tools
sudo apt install -y build-essential

# Install Python (for some dependencies)
sudo apt install -y python3 python3-pip
```

### Environment Variables
Add these to your `~/.bashrc` or `~/.zshrc`:
```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=/usr/lib/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/AbdalrohmanGitHub/AhMyth-AhMyth-Android-RAT.git
cd AhMyth-AhMyth-Android-RAT
```

### 2. Build Everything (Automated)
```bash
# Run the automated build script
./build_for_kali.sh
```

### 3. Manual Setup (Alternative)

#### Build Server Component
```bash
cd AhMyth-Server

# Install dependencies
npm install

# Build for Linux
npm run build:linux64

# Or run directly without building
npm start
```

#### Build Android Client
```bash
cd ../AhMyth-Client

# Make gradlew executable
chmod +x gradlew

# Build debug APK
./gradlew assembleDebug

# Build release APK (optional)
./gradlew assembleRelease
```

## 🔧 Configuration

### Server Configuration
The server configuration can be found in:
- `AhMyth-Server/app/main.js` - Main server logic
- `AhMyth-Server/package.json` - Dependencies and scripts

### Android Client Configuration
- `AhMyth-Client/app/build.gradle` - Build configuration
- `AhMyth-Client/app/src/main/AndroidManifest.xml` - App permissions
- `AhMyth-Client/app/src/main/java/ahmyth/mine/king/ahmyth/` - Source code

### Customizing the APK
```bash
# Edit server IP in the Android client
# File: AhMyth-Client/app/src/main/java/ahmyth/mine/king/ahmyth/MainActivity.java
# Change the SERVER_IP variable to your server's IP address
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Java Version Issues
```bash
# Check current Java version
java -version

# If wrong version, switch Java version
sudo update-alternatives --config java
sudo update-alternatives --config javac

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

#### 2. Gradle Build Fails
```bash
# Clear Gradle cache
cd AhMyth-Client
./gradlew clean
./gradlew build --refresh-dependencies

# Clear npm cache
cd ../AhMyth-Server
rm -rf node_modules package-lock.json
npm install
```

#### 3. Electron Root User Issues
```bash
# The package.json already includes --no-sandbox flag
# If issues persist, try running as non-root user
sudo useradd -m ahmyth
sudo su ahmyth
# Then run npm start
```

#### 4. Permission Issues
```bash
# Fix permission issues
chmod +x AhMyth-Server/node_modules/.bin/electron
chmod +x AhMyth-Client/gradlew

# Run with proper permissions
sudo chown -R $USER:$USER ~/.gradle
sudo chown -R $USER:$USER ~/.npm
```

#### 5. Android SDK Issues
```bash
# Install Android SDK if missing
sudo apt install -y android-sdk android-sdk-build-tools

# Set ANDROID_HOME
export ANDROID_HOME=/usr/lib/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### Dependencies Issues
```bash
# Update npm and node
npm install -g npm@latest
npm cache clean --force

# Reinstall all dependencies
cd AhMyth-Server
rm -rf node_modules
npm install

cd ../AhMyth-Client
./gradlew clean
./gradlew assembleDebug
```

## 🔒 Security Considerations

### For Ethical Use
1. **Always get permission** before testing any device
2. **Use in isolated environments** (virtual machines, test devices)
3. **Document your testing** activities
4. **Follow responsible disclosure** practices

### Protecting Yourself
1. **Don't test on production devices**
2. **Use VPN** when testing remotely
3. **Keep your system updated**
4. **Use antivirus** on your development machine

## 📚 Advanced Features

### Custom Payload Generation
```bash
# Generate custom APK with specific features
cd AhMyth-Server
npm start
# Use the web interface to customize and build APK
```

### Reverse Engineering
```bash
# Analyze the generated APK
apktool d ../AhMyth-Client/app/build/outputs/apk/debug/app-debug.apk -o analysis/
jadx -d decompiled/ ../AhMyth-Client/app/build/outputs/apk/debug/app-debug.apk
```

### Network Analysis
```bash
# Monitor network traffic
tcpdump -i any port 42474
wireshark &
```

## 🤝 Contributing

### Reporting Issues
- Use GitHub Issues for bug reports
- Include system information and error logs
- Provide steps to reproduce the issue

### Development
```bash
# Fork the repository
git clone https://github.com/yourusername/AhMyth-AhMyth-Android-RAT.git

# Create feature branch
git checkout -b feature/new-feature

# Make changes and test
# Commit and push
git push origin feature/new-feature

# Create pull request
```

## 📄 License
This project is licensed under GNU GPLv3 - see the LICENSE file for details.

## ⚖️ Disclaimer
This tool is provided for educational purposes only. The authors are not responsible for any misuse or illegal activities conducted with this software.

## 📞 Support
- GitHub Issues: For bug reports and feature requests
- Documentation: Check the docs/ directory for detailed guides
- Community: Join ethical hacking communities for discussions

---

**Remember**: Ethical hacking is about protecting systems, not exploiting them. Use this knowledge responsibly! 🔒
EOL

# Replace the original file
mv README_KALI_temp.md README_KALI.md
chmod 644 README_KALI.md

echo "✅ README_KALI.md updated with Java requirements and troubleshooting!"
