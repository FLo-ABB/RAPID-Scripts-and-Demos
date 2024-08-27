# PickPlace Module

![Pick Place sequence](https://raw.githubusercontent.com/FLo-ABB/RAPID-Scripts-and-Demos/main/PickPlace/img/PickAndPlaceSequence.gif)

*Figure 1: Pick Place sequence using the matrix operation procedure*

## Overview
The PickPlace module is a RAPID program designed for ABB robots to perform pick and place operations in a matrix-like arrangement. It provides a flexible and robust solution for handling objects in a predefined grid pattern.

## Features
- Configurable matrix dimensions (columns, rows, levels)
- Adjustable spacing between positions
- Z-offset for approach and retreat movements
- Error handling for invalid position indices
- Customizable gripper control
- Configurable zone data for movement precision
- Load handling for picked objects

## Constants
- `nZOffset`: Vertical offset for approach and retreat movements
- `nGripperPickTime`: Time delay for pick operation
- `nGripperPlaceTime`: Time delay for place operation
- `nColumnCount`: Number of columns in the matrix
- `nRowCount`: Number of rows in the matrix
- `nLevelCount`: Number of levels in the matrix
- `nColumnSpacing`: Spacing between columns
- `nRowSpacing`: Spacing between rows
- `nLevelSpacing`: Spacing between levels
- `vPickPlace`: Speed data for pick and place operations
- `zRefZone`: Reference zone data for movements

## Main Procedures
1. `PerformMatrixOperation`: Executes pick or place operation at a specified matrix position
2. `PickWithZOffset`: Performs a pick operation with a vertical offset
3. `PlaceWithZOffset`: Performs a place operation with a vertical offset
4. `ControlGripper`: Manages gripper actions (pick or place)
5. `syncRS`: Synchronizes the robot to the matrix origin

## Usage
To use the PickPlace module:

1. Configure the constants according to your setup.
2. Adjust the `myTool`, `myWobj`, and `loadPart` data to match your robot configuration and part characteristics.
3. Modify the `pMatrixOrigin` to set the starting point of your matrix.
4. Call `PerformMatrixOperation` with the desired position index and operation type.

Example:
```rapid
PerformMatrixOperation 0, \pick;  ! Pick from position 0
PerformMatrixOperation 20, \place;  ! Place at position 20
```

## Error Handling
The module includes error handling for invalid position indices. If an out-of-range index is provided, it will raise a custom error (ERR_INDEX) with a descriptive message.

## Customization
- Gripper Control: Modify the `ControlGripper` procedure to implement your specific gripper logic.
- Speed: Adjust the `vPickPlace` constant to change the operation speed.
- Matrix Configuration: Modify the matrix constants to match your specific arrangement.
- Zone Data: Adjust the `zRefZone` constant and the dynamic zone calculations in `PickWithZOffset` and `PlaceWithZOffset` procedures for movement precision.
- Load Handling: Update the `loadPart` data to match the characteristics of the objects being handled.

## New Features
- Dynamic Zone Calculation: The module now uses dynamic zone calculations based on the Z-offset for more precise movements.
- Load Handling: The `GripLoad` instruction is used to account for the weight and center of gravity of picked objects.
- Synchronization: A `syncRS` procedure is available to move the robot to the matrix origin, useful for system synchronization or homing.

## Additional Functions
- `IsPositionValid`: A helper function to check if a given position index is within the valid range of the matrix.