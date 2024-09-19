# VLoyal

VLoyal is a virtual loyalty card system that allows users to store and manage their loyalty cards digitally. Users can scan QR codes to collect virtual stamps and claim rewards, making loyalty programs easier to access and manage. The project was built as a collaborative effort during Le Wagon's Web Development Bootcamp, with a team of 5 members.

## Key Features

-   **User Authentication:** Sign up and log in to manage your loyalty cards.
    
-   **Virtual Loyalty Cards:** Add and manage loyalty cards in a digital wallet.
    
-   **QR Code Scanner:** Scan QR codes with your phone’s camera to collect virtual stamps.
    
-   **Reward System:** Collect stamps and redeem rewards via a generated QR code.
    
-   **Store Locator:** Find nearby participating stores using Mapbox API.
    
-   **Responsive UI:** Mobile-friendly design for easy in-store use.
    

## Tech Stack

-   **Backend:** Ruby on Rails (Ruby version 3.1.2, Rails version 7.1.2)
    
-   **Frontend:** HTML, SCSS, Stimulus.js
    
-   **Database:** PostgreSQL
    
-   **Authentication:** Devise gem
    
-   **Geolocation:** Geocoder gem, Mapbox API
    
-   **Image Storage:** Cloudinary
    
-   **Forms:** Simple Form gem
    
-   **QR Code Scanner:** Integrated via a [QR code scanning tutorial](https://dev.to/morinoko/qr-code-reader-on-rails-5816)
    

## Installation

To set up the project locally:

1.  Clone the repository.
    
2.  Install dependencies:
    
	    bundle install
	    
	    yarn install

3.  Set up the database:
    
	    rails db:create
	    
	    rails db:migrate

		rails db:seed

4.  Start the server:
    
	    rails s

## Usage

-   **Sign Up:** Create an account to start adding virtual loyalty cards.
    
-   **Add Loyalty Cards:** Add cards from participating stores into your wallet.
    
-   **QR Code Scanner:** Use the camera to scan QR codes at participating stores to collect stamps.
    
-   **Redeem Rewards:** Once enough stamps are collected, a QR code will be generated for reward redemption.
    

## Contributors

-   Developed by a team of 5 during Le Wagon's Bootcamp.
-   Original idea pitched by: Daniel Shaw
