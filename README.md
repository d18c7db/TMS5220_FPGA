# VHDL model of TMS5220 voice synthesizer processor

## About
This implements the [TMS5220](https://github.com/d18c7db/TMS5220_FPGA/blob/master/doc/TMS5220.pdf) voice synthesizer processor (VSP), popular in many arcade games of the 80's. I had originally intended to follow the schematics in the patent [US4335277](https://github.com/d18c7db/TMS5220_FPGA/blob/master/doc/US4335277.pdf), however that proved to be far too complicated for me due to them not using standard TTL logic, but as the patent puts it: "The synthesizer is preferably implemented using pre-charged, conditional discharge type logic".  

## Implementation
It proved far easier in fact to base this entire implementation on the MAME source code for the `TMS5220.cpp` driver, and only refer to the patent for clarification where needed. I have great respect for the MAME contributors and they have already done all the heavy lifting in writing the `TMS5220.cpp` driver.  

The timeline of writing this was roughly this:  

First I needed a correctly working reference so I started with compiling a standalone version of the MAME TMS5220 driver and a main wrapper that feeds it with a LPC data stream borrowed from the [`BlueWizard`](https://github.com/patrick99e99/BlueWizard) project. This LPC data stream is 17 seconds long and speaks the phrase `"The machines were announced in Dec of 1978. And they actually begun shipping in 1979. The first time they were ever shown off was at the Winter Consumer Electronic Show or CES and that was in early Jan 1979."`  

The converted LPC data is written out as a PCM stream in a standard .wav wave file format which can be readily played on any platform. Additionally the program produces several hundreds of megabytes of text logging of all its internal states and flags and the values of all the matrix multiplication and interpolation filter as well as the final output sample. This logging when redirected to a file, is used as the "reference" for debugging the VHDL behaviour, for more detailed info see the `Testing` section below.  

I know the driver has its own debug logging that can be turned on with certain #defines but I chose to implement my own custom format debug output in fuction dump_int_state().  

All one needs to compile the MAME driver is a standard C++ compiler. On windows one could install a basic [MSYS2](https://www.msys2.org/) environment and use the "pacman" package manager to add the GNU G++ compiler.

On the VHDL side, I first started with the basics, implementing the internal chip timing signals, such as the four PHI phases, the T, IC and PC counters and the flags that indicate if the current cycle is A or B. These match page 5, Fig 5 of the patent [US4335277](https://github.com/d18c7db/TMS5220_FPGA/blob/master/doc/US4335277.pdf).  

The next phase was to implement the weird 16 byte FILO (First In Last Out) buffer which is written a byte at a time but the data is extracted 1, 3, 4, 5, or 6 bits at a time, depending on the LPC datastream parser state. After some design choice considerations I decided on a simple 128 bit shift register with a single tracking pointer which tracks the "total free bits in FILO". When a byte is added to the FILO, it is added in reverse bit order (to facilitate the bit extraction later) and the pointer is adjusted accordingly. If there is no space in the FILO the data written is lost, because this means the user is writing data to the chip ignoring the FILO buffer flags and Ready status. When bits are extracted from the FILO, the pointer is adjusted and the 128 bit register shifted accordingly, so new data is always inserted at one end of the FILO and bits are extracted from the other end while the FILO is shifted so the empty (spare) FILO bits are always on the "write" side.  

Once the FILO was debugged the FILO flags "Buffer Low" and "Buffer Empty" for an external processor could be implemented as well as IRQ and the `Ready` output status pin. The command processing was added next, which only responds to commands NOP, "Speak External" and "Reset". This means that this TMS5220 implementation can only make speech if an LPC data stream is written to it by an external processor. Therefore commands "Load Address", "Read Byte", "Read and Branch" and "Speak" are not implemented.  

*The Voice Synthesis Memory (VSM) interface is NOT implemented so speech stored in an external TMS6100 ROM can not be processed*  

The "variable frame rate" of the [TMS5220C](https://github.com/d18c7db/TMS5220_FPGA/blob/master/doc/TMC5220C84.pdf) is not implemented so this model behaves like a [TMS5220](https://github.com/d18c7db/TMS5220_FPGA/blob/master/doc/TMS5220.pdf) in terms of LPC stream processing, however when both WS and RS pins are low, the datasheet states that the TMS5220 state is undefined, whereas for the TMS5220C chip, it is a reset condition. I chose to implement that state as chip reset similar to TMS5220C.  

Once the flags, FILO, command processing and LPC bit stream parsing was fully debugged against the MAME reference, the next stage was to write up the parameter interpolator and verify its consistency against MAME as well. The math is done using signed integer arithmetic which results in identical math results with the MAME reference.  

Finally the last step was to implement the lattice filter which is the very last component needed to produce speech data samples. While MAME implements the filter function in a straightforward algorithmic manner as an unrolled loop, the FPGA implementation has to be serialized to prevent all values being calculated at once before the result of the previous stage has been calculated. This is a perfect illustration of the difference between a CPU which operates sequentially and a FPGA which operates in "parallel" on every clock. By breaking out the lattice filter execution into discrete sequential time periods I was able to obtain a perfect match with the MAME reference.  

## Testing
While initially the test consisted of only the "CES" phrase as mentioned above, the testing was expanded to contain many more LPC samples by including all 280+ sounds from the Atari game Gauntlet and Gauntlet II for a total of over 5 minutes worth of total output sound. The LPC data for all the sounds is streamed sequentially to the VHDL model by the testbench and log data of all internal states is written to a file in iseconfig/build/sim.log during a simulation run while also in the same directory a sound.raw file is created with RAW sample data in signed 32bit little endian format. This can be imported in Audacity via File, Import, Raw with parameters "Signed 32 bit PCM" "Little Endian" "1 Chan Mono" "8000 sample rate". After importing, the sound volume is very low due to the fact that only the lower 12 bits out of 32 are used by the samples, so select all the sound and choose menu options Effect, Normalize to 0.0dB then the sound can be heard.

For the reference, the same LPC data streams are run through the MAME TMS5220.c driver and the same type of debugging information is captured in the same format as for the VHDL testbench. Then a simple file compare can be used to highlight differences/errors/mismatches in the debug logs between MAME and the VHDL implementation. 

At this point in time the simulation produces identical output with that from MAME and the debug logs match with MAME 99.99%, the only discrepancy is the very first excitation value at the start of each LPC stream, however in practice, this does not affect the final value of the PCM sample produced.
