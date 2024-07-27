#
# MIT License
#
# Copyright (c) 2024 nbiotcloud
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

"""
Unified Chip Design Platform - AMBA - AHB2APB Tests.
"""

import logging
import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from tests.ahb_driver import AHBMasterDriver  #, BurstType, SizeType
from tests.apb_driver import APBSlaveDriver


# TODO put this is a generic tb lib
async def wait_clocks(clock, cycles):
    """Helper Function."""
    for _ in range(cycles):
        await RisingEdge(clock)

@cocotb.test()
async def ahb2apb_test(dut):
    """Main Test Loop."""
    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    hclk = dut.main_clk_i
    rst_an = dut.main_rst_an_i

    ahb_mst = AHBMasterDriver(
        name="ahb_mst",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        hsel=dut.ahb_slv_hsel_i,
        haddr=dut.ahb_slv_haddr_i,
        hwrite=dut.ahb_slv_hwrite_i,
        hwdata=dut.ahb_slv_hwdata_i,
        htrans=dut.ahb_slv_htrans_i,
        hburst=dut.ahb_slv_hburst_i,
        hsize=dut.ahb_slv_hsize_i,
        hprot=dut.ahb_slv_hprot_i,
        hrdata=dut.ahb_slv_hrdata_o,
        hready=dut.ahb_slv_hreadyout_o,  # special hready/hreadyout swap as the master is not on a ML
        hreadyout=dut.ahb_slv_hready_i,
        hresp=dut.ahb_slv_hresp_o,
    )

    foo_slv = APBSlaveDriver(
        name="slv_foo",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        paddr=dut.apb_slv_foo_paddr_o,
        pwrite=dut.apb_slv_foo_pwrite_o,
        pwdata=dut.apb_slv_foo_pwdata_o,
        penable=dut.apb_slv_foo_penable_o,
        psel=dut.apb_slv_foo_psel_o,
        prdata=dut.apb_slv_foo_prdata_i,
        pready=dut.apb_slv_foo_pready_i,
        pslverr=dut.apb_slv_foo_pslverr_i,
        pready_delay=0,
        size_bytes=4*1024,
        err_addr={"w":list(range(16)),
                  "r":list(range(0x20, 0x30)),
                  "rw":list(range(0x40, 0x50))}
    )

    bar_slv = APBSlaveDriver(
        name="slv_bar",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        paddr=dut.apb_slv_bar_paddr_o,
        pwrite=dut.apb_slv_bar_pwrite_o,
        pwdata=dut.apb_slv_bar_pwdata_o,
        penable=dut.apb_slv_bar_penable_o,
        psel=dut.apb_slv_bar_psel_o,
        prdata=dut.apb_slv_bar_prdata_i,
        pready=dut.apb_slv_bar_pready_i,
        pslverr=dut.apb_slv_bar_pslverr_i,
        pready_delay=0,
        size_bytes=1024,
    )

    baz_slv = APBSlaveDriver(
        name="slv_baz",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        paddr=dut.apb_slv_baz_paddr_o,
        pwrite=dut.apb_slv_baz_pwrite_o,
        pwdata=dut.apb_slv_baz_pwdata_o,
        penable=dut.apb_slv_baz_penable_o,
        psel=dut.apb_slv_baz_psel_o,
        prdata=dut.apb_slv_baz_prdata_i,
        pready=dut.apb_slv_baz_pready_i,
        pslverr=dut.apb_slv_baz_pslverr_i,
        pready_delay=0,
        size_bytes=13*1024,
    )

    cocotb.start_soon(Clock(hclk, period=10).start())

    cocotb.start_soon(foo_slv.run())
    cocotb.start_soon(bar_slv.run())
    cocotb.start_soon(baz_slv.run())

    # initial reset
    rst_an.value = 0
    await wait_clocks(hclk, 10)
    rst_an.value = 1
    await wait_clocks(hclk, 10)

    await ahb_mst.write(0x0000300, 0xBEEFBEEF)
    await wait_clocks(hclk, random.randint(1, 4))

    await ahb_mst.write(0x0001200, 0xAFFEAFFE)
    await wait_clocks(hclk, random.randint(1, 4))

    await ahb_mst.write(0x0004100, 0x76543210)
    await wait_clocks(hclk, random.randint(1, 4))

    await wait_clocks(hclk, 10)
    await ahb_mst.read(0x0000300)


    await wait_clocks(hclk, 10)
    await ahb_mst.write(0x0000008, 0xdead)
    await wait_clocks(hclk, 5)
    await ahb_mst.read(0x0000008)
    await wait_clocks(hclk, 5)
    await ahb_mst.read(0x0000024)

    await wait_clocks(hclk, 30)
