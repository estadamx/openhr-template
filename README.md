# 🧵 openHR Rails Template

This Rails application template sets up Bootstrap 5.3, dartsass, and honour-tier scaffolding for ethical, resilient apps. It’s designed to reflect openHR’s onboarding values: clarity, dignity, and legacy-aware defaults.

## ✨ Features

- Adds `bootstrap` and `dartsass-rails` gems  
- Pins Bootstrap and Popper.js to exact versions from `Gemfile.lock`  
- Configures `application.scss` and `application.js` defensively  
- Precompiles assets and provides clear status updates  
- Avoids overwriting existing styles or duplicate imports  
- Asserts honour-tier onboarding from the first `rails new`

## 📦 Prerequisites

Before running this template, ensure the following are installed:

- [Node.js](https://nodejs.org/) (includes `npm`)  
- [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/)

These are required for asset compilation and dartsass integration.

## 🚀 Usage

```bash
rails new my_app -m https://raw.githubusercontent.com/estadamx/openhr-template/main/openhr_bootstrap_template.rb
