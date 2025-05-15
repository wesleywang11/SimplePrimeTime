Thanks to CustomizableComputingLab on Github for offering the lib files in following this link.
https://github.com/CustomizableComputingLab/CustomizableComputingLab.github.io/blob/master/class2/SYN_FLOW.zip

Preparing:
1. Plesse set the EDA tools environment first. So that the tools can be used.
2. Please input RTL designs and SDC designs first.
	-Put the netlist files into ./netlist/
	-Put the SDC files into ./constraints/
3. To avoid the cell name mismatch between the netlist and the library, please use the cells exist in the Sky130 library.

Environment Modulating:
4. Access %cd ./scripts/
5. Fix the run_pt.tcl
	-Modulate the variables Design name according to your design

Executing:
6. Using bash to start the PrimeTime
	-Analyze with OCV %run_pt_with_ocv.sh
	-Analyze without OCV %run_pt_without_ocv.sh
7. The STA timing reports are saved in ./reports/
