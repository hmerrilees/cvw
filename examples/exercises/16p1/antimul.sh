#!/bin/bash

# Check if WALLY environment variable is set
if [ -z "$WALLY" ]; then
    echo "Error: WALLY environment variable is not set."
    echo "Please set it with: export WALLY=/path/to/your/wally/directory"
    exit 1
fi

# Check which OS we're on
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version
    sed -i '' 's/assign MFunctD.*/assign MFunctD = 0; \/\/ *** Replace with your logic/' "$WALLY/src/ieu/controller.sv"
    sed -i '' 's/ControlsD.*Divide/assign ControlsD = 0; \/\/ *** Replace with your logic/' "$WALLY/src/ieu/controller.sv"
    # For multi-line operations on macOS, we need a different approach
    perl -0777 -i -pe 's/\/\/ Number systems.*?logic/  logic/s' "$WALLY/src/mdu/mul.sv"
    perl -0777 -i -pe 's/assign Aprime.*?Memory/\/\/ Memory/s' "$WALLY/src/mdu/mul.sv"
else
    # Linux version
    sed -i 's/assign MFunctD.*/assign MFunctD = 0; \/\/ *** Replace with your logic/' "$WALLY/src/ieu/controller.sv"
    sed -i 's/ControlsD.*Divide/assign ControlsD = 0; \/\/ *** Replace with your logic/' "$WALLY/src/ieu/controller.sv"
    sed -zi 's/\/\/ Number systems.*logic/  logic/' "$WALLY/src/mdu/mul.sv"
    sed -zi 's/assign Aprime.*Memory/\/\/ Memory/' "$WALLY/src/mdu/mul.sv"
fi

echo "Modifications completed successfully."
