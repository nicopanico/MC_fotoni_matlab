# Monte Carlo Simulation for Photon and Particle Transport

This repository contains MATLAB code for a **Monte Carlo simulation** of photon interactions and secondary particle transport (electrons and positrons) in different materials such as air, tissue, and bone. The simulation models the transport of photons and handles the major photon-matter interactions: photoelectric effect, Compton scattering, and pair production. Additionally, it tracks secondary electrons and positrons produced by these interactions.

## Features
- **Photon Transport**: Models photon interactions with air, tissue, and bone.
- **Particle Queue**: Manages photon and particle transport using a queue system to handle primary and secondary particles (electrons and positrons).
- **Stopping Power**: Calculates energy loss for electrons and positrons using stopping power for different materials.
- **Positron Annihilation**: Models positron annihilation when the positron energy falls below a threshold of 0.511 MeV.
- **Dose Calculation**: Deposits energy in a voxel grid to simulate dose distribution in the material.

## Code Overview

### Key Functions

#### Defined in `ScriptProvaMCfotoni.m`

1. **`coefficiente_attenuazione_tab(energia, energia_tab, mu_fotoelettrico_tab, mu_compton_tab, mu_pair_production_tab)`**:
   - **Purpose**: Interpolates the attenuation coefficients (photoelectric, Compton, and pair production) based on the photon energy using pre-tabulated data.
   - **Usage**: Used to determine the interaction probability for photons in different materials based on energy.
   
2. **`particella_fuori_griglia(posizione, grid_size)`**:
   - **Purpose**: Checks if a particle has moved outside the simulation grid.
   - **Usage**: Called during particle transport to stop the simulation of a particle if it leaves the voxel grid.

3. **`simula_interazione_fotone(fotone)`**:
   - **Purpose**: Simulates the interaction of a photon in the material, determining whether it undergoes photoelectric absorption, Compton scattering, or pair production.
   - **Usage**: Called in the main loop to handle photon interactions.

4. **`sezione_urto_elettrone(energia_elettrone, materiale)`**:
   - **Purpose**: Simulates the energy deposition and path length of an electron or positron in a material, using the stopping power.
   - **Usage**: Used during electron and positron transport to update their energy and position.

5. **`ottieni_stopping_power(materiale, energia)`**:
   - **Purpose**: Returns the stopping power of the material for a given electron energy. Stopping power values for air, tissue, and bone are currently hard-coded but can be improved by interpolation of real data.
   - **Usage**: This function is called whenever an electron or positron interacts with the material to calculate energy loss.

6. **`gestisci_annichilazione_positrone(positrone)`**:
   - **Purpose**: Handles the annihilation of a positrone when its energy falls below 0.511 MeV, generating two photons of 0.511 MeV each.
   - **Usage**: Called during positron transport when the positron energy is below the annihilation threshold.

#### Main Workflow

1. **Photon Transport**:
   - Photons are transported through a voxel grid. Their interactions are simulated based on the material they encounter. Depending on the interaction, secondary particles such as electrons and positrons are generated.

2. **Secondary Particle Transport**:
   - Secondary electrons and positrons are added to a **queue** and transported through the material. Their energy is deposited in the voxel grid based on the distance traveled and the material's stopping power.

3. **Positron Annihilation**:
   - If a positron's energy falls below 0.511 MeV, it annihilates with an electron, producing two photons of 0.511 MeV, which are added to the particle queue.

4. **Energy Deposition**:
   - Energy deposited by photons, electrons, and positrons is accumulated in a 3D **dose_grid**, which represents the dose distribution in the material.

## Files
- **`ScriptProvaMCfotoni.m`**: Main MATLAB script that runs the Monte Carlo simulation.
- **`sezione_urto_elettrone.m`**: Function to calculate the energy deposited by an electron in the material.
- **`ottieni_stopping_power.m`**: Function to retrieve the stopping power of the material based on the particle's energy.
- **`particella_fuori_griglia.m`**: Utility function that checks if a particle has exited the voxel grid.

## Parameters
- **Grid Size**: Defines the 3D voxel grid for the simulation.
- **Number of Photons**: Sets the number of primary photons to be simulated.
- **Materials**: Air, tissue, and bone are assigned specific interaction properties and stopping powers.

## Future Improvements
1. **Interpolation of Real Data**:
   - In future versions, the stopping power and interaction coefficients could be updated using real-world tabulated data from databases like NIST.

2. **Variance Reduction Techniques**:
   - To improve performance, variance reduction techniques such as Russian roulette or particle splitting could be implemented to reduce simulation noise.

3. **Advanced Dose Visualization**:
   - Implement a more advanced visualization method to represent the dose distribution in the voxel grid with color maps or 3D rendering.

## How to Run
1. Download or clone the repository.
2. Open **MATLAB** and navigate to the folder containing the scripts.
3. Run the main script **`ScriptProvaMCfotoni.m`**. You can modify the parameters in the script to adjust the number of photons, grid size, or materials.

## Requirements
- MATLAB R2021b or later
- Parallel Computing Toolbox (optional, for `parfor` acceleration)

## Contact
If you have any questions or suggestions, please feel free to contact me at [your-email@example.com].
