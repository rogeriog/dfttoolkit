# dfttoolkit

Welcome to **dfttoolkit** – a collection of scripts aimed at assisting with the preparation and processing of Density Functional Theory (DFT) results, specifically tailored for **Quantum Espresso** calculations.

## Features

This repository contains scripts that help with:

- Preprocessing input files for Quantum Espresso calculations
- Postprocessing output files for analysis
- Automating common tasks related to DFT calculations
- Managing and visualizing data from DFT simulations

## Getting Started

To use the scripts, simply clone the repository:

```bash
git clone https://github.com/your-username/dfttoolkit.git
cd dfttoolkit
```

### Prerequisites

Ensure that you have **Python** and **Quantum Espresso** installed on your system. Specific scripts may have additional dependencies, which will be mentioned in the respective script's documentation.

## Scripts Overview

**./submission_scripts**  -- contains scripts to submit a pw.x calculation and also automatizes several postprocessing calculations.

**./structure_editing** -- custom python scripts to edit structures in different ways to feed to Quantum Espresso.

**./plotting_scripts** -- several scripts to plot and analyze the results of the DFT calculations, including PDOS and bandstructures.

**./other_scripts** -- scripts for miscallenous tasks
  
Feel free to explore the scripts, and refer to the comments within each script for more detailed usage instructions.

## Contributing

If you have scripts to add or improvements to suggest, contributions are welcome. 

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
