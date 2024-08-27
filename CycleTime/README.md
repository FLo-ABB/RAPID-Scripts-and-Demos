# CycleTime Module

![chrono in simulation](https://raw.githubusercontent.com/FLo-ABB/RAPID-Scripts-and-Demos/main/CycleTime/img/cycleTime.gif)

*Figure 1: Total cycle time display in a simulation label*

## Overview

This RAPID module, `CycleTime`, provides functionality for measuring and analyzing cycle times in ABB robot operations. It includes features for tracking cycle completions, calculating statistics, and simulating cycles for testing purposes.

## Features

- Tracks individual cycle times and total cycle count
- Calculates average, minimum, and maximum cycle times
- Computes cycles per hour and cycles per minute
- Includes a simulation feature for testing
- Provides a statistics display function

## Constants and Variables

- `cCycleTime`: Clock variable for timing cycles
- `nCycleDone`: Counter for completed cycles
- `nTotalCycleTime`: Accumulator for total cycle time
- `nAverageSecondsPerCycle`: Calculated average cycle time
- `nMinCycleTime`, `nMaxCycleTime`: Track extreme cycle times
- `nCyclePerHour`, `nCyclePerMinute`: Calculated cycle rates

## Main Procedures

1. `main()`: Example procedure demonstrating the module usage
2. `StartSimulation()`: Initializes the simulation
3. `CycleComplete()`: Records and processes a completed cycle
4. `PrintStatistics()`: Displays cycle time statistics
5. `SimulateCycle()`: Simulates a cycle for testing
6. `UpdateStatistics()`: Calculates and updates all statistics

## Usage

1. Call `StartSimulation()` to initialize the module
2. In your main program loop, call `CycleComplete()` at the end of each cycle
3. Use `PrintStatistics()` to display the current cycle time statistics

## Simulation

The module includes a simulation feature:
- `main()` runs 10 simulated cycles
- `SimulateCycle()` creates a random cycle time between 1 and 1.5 seconds

## Error Handling

The module includes basic error prevention:
- Avoids division by zero in rate calculations
- Initializes min/max cycle times to appropriate starting values

## Notes

- The `main()` procedure is provided as an example and should be modified or removed for production use.
- All time measurements are in seconds.
- The teach pendant display is used for output (`TPWrite` commands).

## Step-by-Step Explanation

1. **Initialization**
   - `StartSimulation()` resets and starts the cycle timer.

2. **Cycle Completion**
   - `CycleComplete()` records the time for each completed cycle.
   - It updates the total cycle count and accumulated time.

3. **Statistics Update**
   - `UpdateStatistics()` recalculates all statistics after each cycle.
   - This includes min/max times, average time, and cycle rates.

4. **Results Display**
   - `PrintStatistics()` shows all calculated statistics on the teach pendant.

5. **Simulation**
   - `SimulateCycle()` creates a random delay to simulate varied cycle times.
   - This is useful for testing the module without running actual robot operations.

By using this module, you can easily track and analyze cycle times in your ABB robot applications, helping to optimize performance and identify potential issues in your processes.