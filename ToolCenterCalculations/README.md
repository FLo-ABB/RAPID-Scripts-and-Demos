# ToolCenterCalculations Module

## Overview

This RAPID module, `ToolCenterCalculations`, provides functionality for calibrating a Tool Center Point (TCP) using sphere fitting methods. It's designed for ABB robots and includes procedures for initializing, calculating the TCP, and displaying results.

## Features

- Supports both 4-point and multi-point (>4) TCP calibration methods
- Uses built-in `MToolTCPCalib` for 4-point calibration
- Implements custom sphere fitting algorithm for >4 points
- Calculates and displays error metrics (max error and mean error)
- Includes error handling and user feedback

## Constants and Variables

- `nNumberPoints`: Defines the number of points used for calibration (default: 5)
- `robtargetsArray`: Array to store calibration points
- `pToolCenterTaughtX`: Predefined robtargets for calibration points
- `toolToDeterminate`: Persistent tooldata to store the calculated tool

## Main Procedures

1. `main()`: Example procedure demonstrating the calibration process
2. `calcToolCenter()`: Calculates the Tool Center Point
3. `displayResults()`: Outputs the calibration results
4. `init()`: Initializes the module
5. `syncRS()`: Synchronizes the robot to the calibration points

## Helper Procedures

- `calcError()`: Calculates error metrics
- `findSphereInTool0()`: Finds sphere center in tool frame
- `findSphereInWobj0()`: Finds sphere center in work object frame
- `initializeRobTargetsArray()`: Populates the robtargets array

## Usage

1. Define the number of calibration points in `nNumberPoints`
2. Set the `pToolCenterTaughtX` robtargets to your calibration positions
3. Call `main()` to run the calibration process
4. The results will be displayed, and the `toolToDeterminate` will be updated

## Error Handling

The module includes error handling for various scenarios, such as:
- Insufficient or too many calibration points
- Points in a straight line (for sphere fitting)
- Issues with initializing the robtargets array

## Notes

- The `main()` procedure is provided as an example and should be removed or modified for production use to avoid multiple main definitions.
- Ensure that the naming convention `pToolCenterTaughtX` is followed for the calibration points, where X ranges from 1 to `nNumberPoints`.
- The module uses the `tool0` frame for calculations.

## Functions

- `NormVector(pos vector)`: Normalizes a vector (currently unused in the main logic)

For more detailed information about specific procedures or usage, please refer to the inline comments in the module code.

# ToolCenterCalculations Module

[... Previous content remains unchanged ...]

## Step-by-Step Explanation

This section provides a detailed explanation of the Tool Center Point (TCP) calibration process, with accompanying visuals.

### 1. Initialization
- The `init()` procedure is called to clear the teach pendant display and initialize the `robtargetsArray` with the taught points.

### 2. Sphere Fitting in Work Object Frame
- `findSphereInWobj0()` is called to fit a sphere to the taught points in the work object frame (wobj0).
- This step uses the `FitSphere` function to determine the center and radius of the sphere.

![Sphere in Work Object Frame](placeholder_for_sphere_in_wobj0.png)

*Figure 1: Sphere fitted to the taught points in the work object frame*

### 3. Transforming Points to Tool Frame
- The center of the sphere found in step 2 is transformed to the tool frame for each taught point.
- This transformation creates a new set of points in the tool frame.

![Points in Tool Frame](placeholder_for_points_in_tool_frame.png)

*Figure 2: Transformed points in the tool frame*

### 4. Sphere Fitting in Tool Frame
- `findSphereInTool0()` fits another sphere to the transformed points in the tool frame.
- The center of this sphere represents the Tool Center Point (TCP) relative to the tool0 frame.

![Sphere in Tool Frame](placeholder_for_sphere_in_tool0.png)

*Figure 3: Sphere fitted to the transformed points in the tool frame, with its center representing the TCP*

### 5. Error Calculation
- `calcError()` computes the maximum and mean errors by calculating the distances between the calculated TCP and each of the transformed points.

### 6. Result Display
- `displayResults()` shows the calculated TCP position and error metrics on the teach pendant.

### 7. Tool Data Update
- The `toolToDeterminate` persistent variable is updated with the new TCP data.