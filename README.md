# Sales Tax Calculator

A Ruby application that calculates sales tax for shopping items based on their category and import status

## Description

This application processes a list of shopping items and calculates the appropriate sales tax for each item. The tax rules are:
- Basic sales tax of 10% applies to all goods, except books, food, and medical products
- Import duty of 5% applies to all imported goods with no exemptions
- Sales tax is rounded up to the nearest 0.05

The application uses the `informers` gem with zero-shot classification to automatically categorize items as book, food, medical, or other.

## Requirements

- Ruby 3.2.2 or higher
- `informers` gem

## Installation

1. Make sure you have Ruby installed:

```bash
ruby -v
```

2. Install the `informers` gem:

```bash
gem install informers
```

## Usage

Run the script:

```bash
ruby main.rb
```

### Input Format

Enter each item on a new line using the following format:

```
<quantity> [imported] <name> at <price>
```

For example:
```
1 book at 12.49
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50
```

Press Enter on an empty line to finish input and generate the receipt.

### Example

```
Enter your items (e.g., '2 imported book at 12.49'), one per line. Press enter on an empty line to finish:
1 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
[press Enter]

Receipt:
1 book: 12.49
1 music CD: 16.49
1 chocolate bar: 0.85

Sales Taxes: 1.5
Total: 29.83
```

Warning: The first time the application is used, there will be a delay while the `informers` gem downloads the model.

## Exception Handling

The application may throw the following exceptions:

- **ArgumentError**: Raised when an input line does not match the expected format
  - Specific error messages explain what's wrong with the input (missing quantity, price, etc.)
  - Example: `Invalid input: 1 book (Missing 'at' separator)`

- **Informers::Error**: May be raised by the classification service if there are issues with the ML model

- **StandardError**: Other unexpected errors during processing

## Testing
### Requirements

- RSpec gem

### Installation

```bash
gem install rspec
```

### Running Tests

Run all tests:

```bash
rspec
```
