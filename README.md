# MarketTrack

**MarketTrack** is a COBOL-based inventory management system designed for small to medium-sized businesses. It manages product data, tracks sales, generates inventory reports, and helps maintain stock efficiently.

## Features

- **Add Products**: Easily add new products with relevant information (code, name, category, quantity, price).
- **Update Products**: Modify existing product details such as quantity, price, and category.
- **Delete Products**: Remove outdated or obsolete product entries.
- **Record Sales**: Log product sales, automatically updating stock quantities.
- **Inventory Report**: Generate reports highlighting products below a configurable restocking threshold.
- **Search Products**: Find products by name or code.

## File Structure

- `inventaire_market.dat`: Data file where product information is stored in line sequential format.

## Getting Started

### Prerequisites

To run this project, you need a COBOL compiler such as:
- [GnuCOBOL](https://gnucobol.sourceforge.io/)
- Any other COBOL compiler compatible with your operating system.

### Running the Program

1. Clone the repository:
   ```bash
   git clone https://github.com/Kamionn/MarketTrack.git
2. Navigate to the project directory:
   ```bash
   cd markettrack
3. Compile the COBOL program:
   ```bash
   cobc -x -o MarketTrack GestionInventaire.cob
4. Run the program:
   ```bash
   /MarketTrack
