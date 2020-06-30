# VHDL simulation model of TMS5220 chip

## About
This implements the TMS5220 voice synthesizer processor (VSP), popular in many arcade games of the 80's. I had originally intended to follow the schematics in the patent US4335277, however that proved to be far too complicated for me due to them not being standard TTL logic, but as the patent puts it: "The synthesizer is preferably implemented using pre-charged, conditional discharge type logic".  

## Implementation
It proved far easier in fact to base this entire implementation on the MAME source code for the `TMS5220.cpp` driver, and only refer to the patent for clarification where needed. I have great respect for the MAME contributors and they have already done all the heavy lifting in writing the `TMS5220.cpp` driver.  

The timeline of writing this was roughly this:  

Started with compiling a standalone version version of the MAME TMS5220 driver and a wrapper main that feeds it with a LPC data stream borrowed from the `BlueWizard` project. This LPC data stream is 17 seconds long and speaks the phrase `"The machines were announced in Dec of 1978. And they actually begun shipping in 1979. The first time they were ever shown off was at the Winter Consumer Electronic Show or CES and that was in early Jan 1979."`  

The converted LPC data is written out as a PCM stream in a standard wave file format which can be readily played on any platform. Additionally the program produces several hundreds of megabytes of logging of all its internal states and flags and the values of all the matrix multiplication and interpolation filter as well as the final output sample. This logging when redirected to a file, is used as the "reference" for debugging the VHDL behaviour, for more detailed info see the `Testing` section below.  

I know the driver has its own debug logging that can be turned on with certain #defines but I chose to implement my own debug output in fuction dump_int_state().  

All one needs to compile the MAME driver is a standard C++ compiler. On windows one could install a basic [[MSYS2]](https://www.msys2.org/) environment and use the "pacman" package manager to add the GNU G++ compiler.

On the VHDL side, I first started with the basics, implementing the internal chip timing signals, such as the four PHI phases, the T, IC and PC counters and the flags that indicate if the current cycle is A or B. These match page 5, Fig 5 of the patent.  

The next phase was to implement the weird 16 byte FIFO which takes in byte values but the data is extracted 1, 3, 4, 5, or 6 bits at a time, depending on the LPC datastream parsing. After some design choice considerations I decided on a simple 128 bit shift register with a single tracking pointer which tracks the "total free bits in FIFO". When a byte is added to the FIFO, it is added in reverse bit order (to facilitate the bit extraction later) and the pointer is adjusted accordingly . If there is no space in the FIFO the data is lost, because this means the user is writing data to the chip ignoring the FIFO flags or Ready status. When bits are extracted from the FIFO, the pointer is adjusted and the 128 bit register shifted accordingly, so new data is always inserted at one end of the FIFO and bits are extracted from the other end while the FIFO is shifted so the empty (spare) FIFO bits are always on the "write" side.  

Once the FIFO was debugged the FIFO flags "Buffer Low" and "Buffer Empty" for an external processor could be implemented as well as IRQ and the `Ready` output status pin. The command processing was added next, which only responds to commands NOP, "Speak External" and "Reset". This means that this TMS5220 implementation can only make speech if an LPC data stream is written to it by an external processor.  

*The Voice Synthesis Memory (VSM) interface is not implemented so speech stored in external TMS6100 ROM can not be processed*  
Therefore commands "Load Address", "Read Byte", "Read and Branch" and "Speak" are not implemented.  

When both WS and RS pins are low, the datasheet states that the TMS5220 state is undefined, whereas for the TMS5220C chip, it is a reset condition. I chose to implement that state as chip reset similar to TMS5220C. However the "variable frame rate" of the TMS5220C is not implemented so this model behaves like a TMS5220 in terms of LPC stream processing, not as a TMS5220C

Once the flags, FIFO, command processing and LPC bit stream parsing was fully debugged against the MAME reference, the next stage was to write up the parameter interpolator and verify its consistency against MAME as well. The math is done using signed integer arithmetic and while I tried initially to implement right bit shifting through division, I was getting incorrect (close but not exact) matches with MAME reference. I therefore chose to use VHDL type conversion to_integer and to_signed in order to be able to use the VHDL shift_right operand which resulted in identical math with the reference.  

Finally the last step was to implement the lattice filter which is the very last component needed to produce speech data samples. Unlike MAME which implements the filter is a nice straightforward manner, the FPGA implementation has to be artificially serialized. This is a perfect illustration of the difference bewteen a CPU which does "everything sequentially" and a FPGA which does "everything at once" on every clock. By breaking out the lattice filter execution into discrete T time periods I was able to obtain a perfect match with the MAME reference.  

## Testing
While initially the test consisted of only the "CES" phrase as mentioned above, the testing was expanded to contain many more LPC samples by including all 280+ sounds from the Atari game Gauntlet and Gauntlet II for a total of over 5 minutes worth of total output sound. The LPC data for all the sounds is streamed sequentially to the VHDL model by the testbench and log data of all internal states is written to a file in iseconfig/build/sim.log during a simulation run and also in the same place is a sound.raw file with RAW sample data in signed 32bit litle endian format. This can be imported in Audacity via File, Import, Raw with parameters "Signed 16 bit PCM" "Little Endian" "2 Chan Stereo" "8000 sample rate". I think there is a bug in Audacity importing signed 32 bit samples, so the above settings treat the 32 bit signed as two 16 bit samples. Since the PCM data is only 16 bits anyway but written as 32 bits from the testbench due to limitations, one ends up with one "stereo" channel of PCM data and the second "stereo" channel silent.

For the reference, the same LPC data streams are run through the MAME TMS5220.c driver and the same type of debugging information is captured in the same format as for the VHDL testbench. A simple file compare can then be used to highlight differences/errors/mismatches in the debug logs between MAME and the VHDL implementation. 

At this point in time the simulation produces identical output with that from MAME and the debug logs match with MAME 99.99%, the only discrepancy is the very first excitation value at the start of each LPC stream, however in practice, this does not affect the final value of the PCM sample produced.
