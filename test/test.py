# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test

    #R-type (add)

    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 72
    dut._log.info(f"uio_out={dut.uio_out.value}")
    assert (dut.uio_out.value & 0b1111) == 0b0110

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

    #__________________________________________________________________________________

    #R-type (subtract)#

    dut.ui_in.value = 0
    dut.uio_in.value = 2

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 72
    assert dut.uio_out.value == 6

    #__________________________________________________________________________________

    #R-type (AND)#

    dut.ui_in.value = 0
    dut.uio_in.value = 4

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 72
    assert dut.uio_out.value == 0

    #__________________________________________________________________________________
    
    #R-type (OR)#

    dut.ui_in.value = 0
    dut.uio_in.value = 5

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 72
    assert dut.uio_out.value == 1

    #__________________________________________________________________________________

    #R-type (Set on Less Then)#

    dut.ui_in.value = 0
    dut.uio_in.value = 10

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 72
    assert dut.uio_out.value == 7

    #__________________________________________________________________________________

    #Load Word#

    dut.ui_in.value = 35
    dut.uio_in.value = 2

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 60
    assert dut.uio_out.value == 2

    #__________________________________________________________________________________

    #Store Word
    
    dut.ui_in.value = 43
    dut.uio_in.value = 2

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 34
    assert dut.uio_out.value == 2

    #__________________________________________________________________________________

    #Branch Equal
    
    dut.ui_in.value = 4
    dut.uio_in.value = 6

    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 1
    assert dut.uio_out.value == 6
