# Theater and Performing Arts Ticketing System

A comprehensive blockchain-based ticketing system built with Clarity smart contracts for theater and performing arts venues. This system provides dynamic pricing, seat management, season subscriptions, group sales, accessibility accommodations, and performance analytics.

## System Overview

The ticketing system consists of five interconnected smart contracts:

### 1. Venue Management Contract (`venue-management.clar`)
- Manages theater venues, seating layouts, and capacity
- Handles venue registration and configuration
- Tracks accessibility features and special accommodations

### 2. Performance Management Contract (`performance-management.clar`)
- Manages show schedules, performance details, and metadata
- Handles performance creation, updates, and cancellations
- Tracks performance analytics and audience metrics

### 3. Dynamic Pricing Contract (`dynamic-pricing.clar`)
- Implements intelligent pricing algorithms based on demand
- Manages base prices, surge pricing, and discount structures
- Handles real-time price adjustments based on availability

### 4. Ticket Sales Contract (`ticket-sales.clar`)
- Core ticketing functionality for individual and group sales
- Manages seat reservations, purchases, and transfers
- Handles accessibility accommodations and special requests

### 5. Season Subscriptions Contract (`season-subscriptions.clar`)
- Manages season ticket packages and subscriber benefits
- Handles subscription renewals and member perks
- Tracks subscriber analytics and engagement

## Key Features

### Dynamic Pricing
- Real-time price adjustments based on demand and availability
- Surge pricing for high-demand performances
- Early bird and last-minute discount strategies
- Group discount management

### Seat Management
- Comprehensive seating chart management
- Real-time availability tracking
- Accessibility seat reservations
- Premium seating categories

### Season Subscriptions
- Flexible subscription packages
- Member benefits and priority booking
- Automatic renewal options
- Subscriber analytics

### Group Sales
- Bulk ticket purchasing with discounts
- Group coordinator management
- Special group pricing tiers
- Event coordination tools

### Accessibility Features
- ADA-compliant seating options
- Special accommodation requests
- Assistive device management
- Accessibility pricing considerations

### Analytics and Insights
- Performance attendance tracking
- Revenue analytics
- Audience demographic insights
- Pricing optimization metrics

## Contract Architecture

Each contract is designed to be independent while working together seamlessly:

- **Data Isolation**: Each contract manages its own data structures
- **Event Emission**: Comprehensive logging for analytics
- **Error Handling**: Robust error codes and validation
- **Security**: Built-in access controls and validation

## Getting Started

1. Install dependencies: `npm install`
2. Run tests: `npm test`
3. Deploy contracts using Clarinet
4. Configure venue and performance data
5. Start selling tickets!

## Testing

The system includes comprehensive tests using Vitest covering:
- Contract deployment and initialization
- Venue and performance management
- Dynamic pricing algorithms
- Ticket purchasing flows
- Season subscription management
- Error handling and edge cases

## Configuration

- `Clarinet.toml`: Clarinet project configuration
- `package.json`: Node.js dependencies and scripts
- Test files: Comprehensive test coverage for all contracts

## License

MIT License - See LICENSE file for details
