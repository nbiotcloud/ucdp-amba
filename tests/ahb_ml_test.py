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
Unified Chip Design Platform - AMBA - AHB Tests.
"""

import logging
import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Combine, RisingEdge

from tests.ahb_driver import AHBMasterDriver, AHBSlaveDriver, BurstType, SizeType


def _calc_wbytes(size: SizeType, wdata: list[int]) -> list[int]:
    """Calculate Reference Write Data in Bytes."""
    wbytes = []
    for wd in wdata:
        w = wd
        for _ in range(1 << size):
            wbytes.append(w & 0xFF)
            w = w >> 8
    return wbytes


def _calc_rbytes(size: SizeType, rdata: list[int]) -> list[int]:
    """Calculate Read Data in Bytes."""
    rbytes = []
    for rd in rdata:
        r = rd
        for _ in range(1 << size):
            rbytes.append(r & 0xFF)
            r = r >> 8
    return rbytes


# TODO put this is a generic tb lib
async def wait_clocks(clock, cycles):
    """Helper Function."""
    for _ in range(cycles):
        await RisingEdge(clock)


@cocotb.test()
async def ahb_ml_test(dut):
    """Main Test Loop."""
    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    hclk = dut.main_clk_i
    rst_an = dut.main_rst_an_i

    ext_mst = AHBMasterDriver(
        name="ext_mst",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        haddr=dut.ahb_mst_ext_haddr_i,
        hwrite=dut.ahb_mst_ext_hwrite_i,
        hwdata=dut.ahb_mst_ext_hwdata_i,
        htrans=dut.ahb_mst_ext_htrans_i,
        hburst=dut.ahb_mst_ext_hburst_i,
        hsize=dut.ahb_mst_ext_hsize_i,
        hprot=dut.ahb_mst_ext_hprot_i,
        hrdata=dut.ahb_mst_ext_hrdata_o,
        hready=dut.ahb_mst_ext_hready_o,
        hresp=dut.ahb_mst_ext_hresp_o,
        hsel=None,
    )

    dsp_mst = AHBMasterDriver(
        name="dsp_mst",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        haddr=dut.ahb_mst_dsp_haddr_i,
        hwrite=dut.ahb_mst_dsp_hwrite_i,
        hwdata=dut.ahb_mst_dsp_hwdata_i,
        htrans=dut.ahb_mst_dsp_htrans_i,
        hburst=dut.ahb_mst_dsp_hburst_i,
        hsize=dut.ahb_mst_dsp_hsize_i,
        hprot=dut.ahb_mst_dsp_hprot_i,
        hrdata=dut.ahb_mst_dsp_hrdata_o,
        hready=dut.ahb_mst_dsp_hready_o,
        hresp=dut.ahb_mst_dsp_hresp_o,
        hsel=None,
    )

    ram_slv = AHBSlaveDriver(
        name="ram_slv",
        log_level=logging.INFO,
        clk=hclk,
        rst_an=rst_an,
        hsel=dut.ahb_slv_ram_hsel_o,
        haddr=dut.ahb_slv_ram_haddr_o,
        hwrite=dut.ahb_slv_ram_hwrite_o,
        htrans=dut.ahb_slv_ram_htrans_o,
        hsize=dut.ahb_slv_ram_hsize_o,
        hburst=dut.ahb_slv_ram_hburst_o,
        hprot=dut.ahb_slv_ram_hprot_o,
        hwdata=dut.ahb_slv_ram_hwdata_o,
        hready=dut.ahb_slv_ram_hready_o,
        hreadyout=dut.ahb_slv_ram_hreadyout_i,
        hresp=dut.ahb_slv_ram_hresp_i,
        hrdata=dut.ahb_slv_ram_hrdata_i,
    )

    cocotb.start_soon(Clock(hclk, period=10).start())

    cocotb.start_soon(ram_slv.run())

    # initial reset
    rst_an.value = 0
    await wait_clocks(hclk, 10)
    rst_an.value = 1
    await wait_clocks(hclk, 10)

    # await dsp_mst.write(0xF0000100, 0xBEEFBEEF)
    # await wait_clocks(hclk, 5)

    ext_wr = cocotb.start_soon(ext_mst.write(0xF0000300, 0x76543210))
    dsp_wr = cocotb.start_soon(
        dsp_mst.write(0xF0000316, (0x11, 0x22, 0x33, 0x44), burst_type=BurstType.WRAP4, size=SizeType.HALFWORD)
    )
    await Combine(ext_wr, dsp_wr)
    await wait_clocks(hclk, 5)
    # ram_slv.log_data()

    # ext_wr = cocotb.start_soon(ext_mst.write(0xF0000000, 0x76543210))
    # dsp_wr = cocotb.start_soon(
    #     dsp_mst.write(0xF0000016, (0x11, 0x22, 0x33, 0x44), burst_type=BurstType.WRAP4, size=SizeType.HALFWORD)
    # )
    # await Combine(ext_wr, dsp_wr)

    # await wait_clocks(hclk, 5)
    # rdata = await ext_mst.read(0xF0000000, burst_type=BurstType.INCR8, size=SizeType.BYTE)
    # print("MST EXT rdata:", [hex(data) for data in rdata])
    # await wait_clocks(hclk, 5)

    mem = bytearray(1024)
    btypes = (
        BurstType.SINGLE,
        BurstType.WRAP4,
        BurstType.INCR4,
        BurstType.WRAP8,
        BurstType.INCR8,
        BurstType.WRAP16,
        BurstType.INCR16,
    )
    sizes = (SizeType.BYTE, SizeType.HALFWORD, SizeType.WORD)
    for w in range(20):
        btype = random.choice(btypes)
        size = random.choice(sizes)
        if btype == BurstType.SINGLE:
            blen = 1
            imask = (1 << size) - 1
            mmask = 1
        else:
            blen = 2 << (btype >> 1)
            mmask = imask = (4 << (((btype - 2) >> 1) + size)) - 1
        offs = random.randint(0, 511) & ~((1 << size) - 1)  # make it size aligned

        if btype in (BurstType.INCR16, BurstType.INCR8, BurstType.INCR4):
            offs &= ~mmask  # make it burst aligned
        smax = (1 << (1 << (size + 3))) - 1  # max value according to size
        memimg = bytearray(blen << size)
        # print("BOZO2", blen, size, hex(offs), hex(imask))
        if random.randint(0, 1):
            wdata = [random.randint(1, smax) for i in range(blen)]
            for i in range(blen << size):
                memimg[(offs + i) & imask] = _calc_wbytes(size, wdata)[i]

            mem[(offs & ~mmask) : (offs & ~mmask) + (blen << size)] = memimg
            log.info(
                f"=MST WRITE TRANSFER= offs:{hex(offs)}; burst:{btype.name}; size:{size.name}; "
                f"wdata:{[hex(w) for w in wdata]}"
            )
            # print("BOZO-W", size, hex(offs), hex(offs & ~mmask), [hex(w) for w in wdata],
            #       "\n", [hex(w) for w in _calc_wbytes(size, wdata)],
            #       "\n", [hex(w) for w in memimg],
            #       "\n", [hex(b) for b in mem[(offs & ~mmask):(offs & ~mmask)+(blen << size)]])
            await ext_mst.write(0xF0000000 + offs, wdata, burst_type=btype, size=size)
        else:
            rdata = await ext_mst.read(0xF0000000 + offs, burst_type=btype, size=size)

            for i in range(blen << size):
                memimg[(offs + i) & imask] = _calc_rbytes(size, rdata)[i]

            cmp = mem[(offs & ~mmask) : (offs & ~mmask) + (blen << size)] == memimg
            print(
                "BOZO-R",
                size,
                hex(offs),
                hex(offs & ~mmask),
                [hex(r) for r in rdata],
                "\n",
                [hex(b) for b in _calc_rbytes(size, rdata)],
                "\n",
                [hex(b) for b in memimg],
                "\n",
                [hex(b) for b in mem[(offs & ~mmask) : (offs & ~mmask) + (blen << size)]],
            )
            if not cmp:
                raise ValueError("Compare mismatch")
        await wait_clocks(hclk, 2)

    await wait_clocks(hclk, 30)
