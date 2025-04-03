 # In_Out - Personal Finance Tracker

[![Flutter](https://img.shields.io/badge/Flutter-2.0+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)


## Overview
This application allows users to track both income and expenses, categorize transactions, visualize spending patterns through interactive charts, and receive AI-powered financial recommendations based on their spending habits.

## Features
# Core Functionality
-  Transaction Tracking: Log income and expenses with categories, dates, and descriptions
- Financial Overview: View your financial history and current month's status at a glance
- Search: Quickly find transactions by name or category
- Multi-platform: Works on iOS and Android devices

# Visualizations
- Line Graph: Track your spending patterns over time
- Pie Chart: Understand your spending distribution by category
- Monthly Summaries: View aggregated data by month throughout the year

# User Management
- User Accounts: Create an account to securely store your financial data
- Guest Mode: Try the app without creating an account
- Cloud Sync: Automatically sync data between devices when signed in

# Smart Analysis
- AI Recommendations: Get personalized insights and recommendations powered by Google's Gemini AI
- Spending Patterns: Identify unusual spending patterns and potential savings opportunities

# Future Projections
- View estimated future expenses based on your historical data
- new diagrams
- budget manager


## Getting Started
# Prerequisites
Flutter SDK
Firebase project set up
Google Generative AI API key

# Installation
Clone the repository:
Install dependencies:
Configure Firebase:
Create a Firebase project
Enable Firestore database
Add your google-services.json (Android) and/or GoogleService-Info.plist (iOS) to the project
Set up Google Generative AI:

Obtain an API key
Update the key in gemini_service.dart
Run the app:

### Usage
## Authentication
 - Create an account with email and password
 - Log in with existing credentials
 - Use guest mode for quick access without registration

## Adding Transactions
 - Tap the floating action button to add a new transaction
 - Enter amount, category, and description
 - All data is automatically saved locally and to the cloud (when signed in)

## Viewing Data
- The home page shows a comprehensive overview of your finances
- Filter history by time period (7 days, 1 month, 6 months, 1 year)
- Toggle between income and expense views
- Use the search bar to find specific transactions

## Getting Insights
 - View recommendations based on AI analysis of your spending patterns
 - Identify categories where you might be overspending
 - Get alerts for unusual spending activities

