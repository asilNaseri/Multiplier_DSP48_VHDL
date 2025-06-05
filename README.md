This vhdl file contains an instant of DSP48E2 which can do several operations like A*B+C since the operation '*' takes too much resources of the FPGA, this way is recommended.
This code can be run in Vivado.
The test bench I provided will recieve the inputs and calculate the desired output.
For inouts I provided a Matlab code in which the inputs are created in the way that is sync with the vhdl file.
To run the simulation section in Matlab you have to have a tcl file which I uploaded too.
