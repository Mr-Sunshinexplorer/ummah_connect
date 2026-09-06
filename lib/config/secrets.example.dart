// This is an EXAMPLE file - Copy this to secrets.dart and fill in your values
// DO NOT COMMIT secrets.dart to GitHub

class AppSecrets {
  // Your GitHub Personal Access Token
  // Get from: https://github.com/settings/tokens
  static const String githubToken = 'YOUR_GITHUB_TOKEN_HERE';
  
  // Your GitHub Username
  static const String githubUsername = 'YOUR_GITHUB_USERNAME_HERE';
  
  // Your GitHub Repository Name
  static const String githubRepo = 'ummah_connect';
  
  // Any other API keys
  static const String apiKey = 'YOUR_API_KEY_HERE';
}

// HOW TO USE:
// 1. Copy this file to secrets.dart
// 2. Fill in your actual values
// 3. secrets.dart is in .gitignore (won't be committed)
// 4. Import secrets.dart in your app
// 5. Use AppSecrets.githubToken instead of hardcoding