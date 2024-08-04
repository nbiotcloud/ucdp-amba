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
Unified Chip Design Platform - AMBA - AHB Drivers.
"""

from collections.abc import Iterable
from enum import IntEnum
from logging import getLogger
from typing import Literal

from cocotb.handle import SimHandle
from cocotb.triggers import RisingEdge


class BurstType(IntEnum):
    """HBURST encoding as per AHB spec."""

    SINGLE = 0  # Single transfer
    INCR = 1  # Unknown length burst
    WRAP4 = 2  # Four-beat wrap burst
    INCR4 = 3  # Four-beat incrementing burst
    WRAP8 = 4  # Eight-beat wrap burst
    INCR8 = 5  # Eight-beat incrementing burst
    WRAP16 = 6  # Sixteen-beat wrap burst
    INCR16 = 7  # Sixteen-beat incrementing burst


class TransType(IntEnum):
    """HTRANS encoding as per AHB spec."""

    IDLE = 0  # No transfer
    BUSY = 1  # Busy transfer
    NONSEQ = 2  # Non-sequential transfer
    SEQ = 3  # Sequential transfer


class SizeType(IntEnum):
    """HSIZE encoding as per AHB spec."""

    BYTE = 0  # 8-bit
    HALFWORD = 1  # 16-bit
    WORD = 2  # 32-bit
    DOUBLEWORD = 3  # 64-bit
    WORD4 = 4  # 128-bit
    WORD8 = 5  # 256-bit
    WORD16 = 6  # 512-bit
    WORD32 = 7  # 1024-bit


def _prep_addr_iter(addr: int, burst_length: int, size: SizeType, burst_type=BurstType) -> tuple[int, int, int, int]:
    """Prepare Address Iterations."""
    match burst_type:
        case BurstType.INCR16 | BurstType.WRAP16:
            mask = (1 << (size + 4)) - 1
            len = 16
        case BurstType.INCR8 | BurstType.WRAP8:
            mask = (1 << (size + 3)) - 1
            len = 8
        case BurstType.INCR4 | BurstType.WRAP4:
            mask = (1 << (size + 2)) - 1
            len = 4
        case BurstType.INCR:
            mask = -1
            len = burst_length
        case BurstType.SINGLE:
            mask = -1
            len = 1
    base = addr & ~mask
    offs = addr & mask
    return (base, offs, mask, len)


def _check_bus_acc(data_width: int, addr: int, offs: int, size: SizeType, burst_type=BurstType) -> None:
    """Check AHB Bus Access."""
    assert data_width >= (8 << size), f"Size argument {size!r} -> {8<<size} too big for data width of {data_width}!"
    assert (addr & ((1 << size) - 1)) == 0, f"Address {addr:x} is not aligned to size argument {size!r}!"
    assert (burst_type not in (BurstType.INCR16, BurstType.INCR8, BurstType.INCR4)) or (
        offs == 0
    ), f"Address {addr:x} is not aligned to BurstType {burst_type!r} at size {size!r}!"


class SlaveFsmState(IntEnum):
    """Internal AHB Slave State."""

    IDLE = 0
    ACTIVE = 1


class AHBMasterDriver:
    """AHB Master bus driver."""

    def __init__(
        self,
        name: str,
        clk: SimHandle,
        rst_an: SimHandle,
        haddr: SimHandle,
        hwrite: SimHandle,
        hwdata: SimHandle,
        htrans: SimHandle,
        hburst: SimHandle,
        hsize: SimHandle,
        hprot: SimHandle,
        hrdata: SimHandle,
        hready: SimHandle,
        hresp: SimHandle,
        hsel: SimHandle = None,
        hreadyout: SimHandle = None,
        log_level: int | None = None,
    ):
        self.name = name
        self.clk = clk
        self.rst_an = rst_an
        self.haddr = haddr
        self.hwrite = hwrite
        self.hwdata = hwdata
        self.htrans = htrans
        self.hburst = hburst
        self.hsize = hsize
        self.hprot = hprot
        self.hrdata = hrdata
        self.hready = hready
        self.hresp = hresp
        self.hsel = hsel  # allowed to be None as it might not be present (e.g. Multilayer input)
        self.hreadyout = hreadyout  # allowed to be None as it might not be present (e.g. Multilayer input)
        self.data_width = len(hwdata)

        self.logger = getLogger(name)
        if log_level is not None:  # important explicit check for None as 0 would be a valid value
            self.logger.setLevel(log_level)

    async def write(  # noqa: C901
        self,
        addr: int,
        data: int | Iterable,
        size: SizeType = SizeType.WORD,
        burst_length: int = 1,
        burst_type: BurstType = BurstType.SINGLE,
    ) -> bool:
        """AHB Write (Burst)."""
        base, offs, mask, burst_length = _prep_addr_iter(
            addr=addr, burst_length=burst_length, size=size, burst_type=burst_type
        )
        _check_bus_acc(data_width=self.data_width, addr=addr, offs=offs, size=size, burst_type=burst_type)

        err_resp = False
        if isinstance(data, int):
            log_data = [data]
            data = iter((data,))
        else:
            log_data = list(data)
            data = iter(data)
        shift_mask = self.data_width - 1
        self.haddr.value = base + offs
        self.hwdata.value = 0xDEADDEAD
        self.hwrite.value = 1
        if self.hsel:
            self.hsel.value = 1
        if self.hreadyout:
            self.hreadyout.value = 1
        self.htrans.value = TransType.NONSEQ
        self.hburst.value = burst_type
        self.hsize.value = size
        await RisingEdge(self.clk)
        if self.hreadyout:
            self.hreadyout = self.hready
        for _ in range(burst_length - 1):
            self.htrans.value = TransType.SEQ
            self.hwdata.value = next(data) << ((offs << 3) & shift_mask)
            offs = (offs + (1 << size)) & mask
            self.haddr.value = base + offs
            await RisingEdge(self.clk)
            while self.hready == 0:
                await RisingEdge(self.clk)
            if self.hresp.value:
                err_resp = True
        if self.hsel:
            self.hsel.value = 0
        self.haddr.value = 0
        self.hwdata.value = next(data) << ((offs << 3) & shift_mask)
        self.hwrite.value = 0
        self.htrans.value = TransType.IDLE
        self.hburst.value = BurstType.SINGLE
        self.hsize.value = SizeType.BYTE
        await RisingEdge(self.clk)
        if self.hreadyout:
            self.hreadyout = self.hready
        while self.hready == 0:
            await RisingEdge(self.clk)
        if self.hresp.value:
            err_resp = True
        self.hwdata.value = 0xDEADDEAD
        self._info_log(
            rw="WRITE",
            addr=addr,
            burst_type=burst_type,
            burst_length=burst_length,
            size=size,
            data=log_data,
            err_resp=err_resp,
        )
        return err_resp

    async def read(
        self, addr: int, burst_length: int = 1, size: SizeType = SizeType.WORD, burst_type: BurstType = BurstType.SINGLE
    ) -> tuple[bool, tuple[int]]:
        """AHB Read (Burst)."""
        base, offs, mask, burst_length = _prep_addr_iter(
            addr=addr, burst_length=burst_length, size=size, burst_type=burst_type
        )
        _check_bus_acc(data_width=self.data_width, addr=addr, offs=offs, size=size, burst_type=burst_type)

        rdata = []
        err_resp = False
        poffs = offs
        shift_mask = self.data_width - 1
        szmsk = (1 << (8 << size)) - 1
        self.haddr.value = base + offs
        if self.hsel:
            self.hsel.value = 1
        self.hwrite.value = 0
        self.htrans.value = TransType.NONSEQ
        self.hburst.value = burst_type
        self.hsize.value = size
        await RisingEdge(self.clk)

        for _ in range(burst_length - 1):
            self.htrans.value = TransType.SEQ
            offs = (offs + (1 << size)) & mask
            self.haddr.value = base + offs
            await RisingEdge(self.clk)
            while self.hready == 0:
                await RisingEdge(self.clk)
            rdata.append((self.hrdata.value.integer >> ((poffs << 3) & shift_mask)) & szmsk)
            if self.hresp.value:
                err_resp = True
            poffs = offs
        if self.hsel:
            self.hsel.value = 0
        self.haddr.value = 0
        self.htrans.value = TransType.IDLE
        self.hsize.value = SizeType.BYTE
        await RisingEdge(self.clk)
        while self.hready == 0:
            await RisingEdge(self.clk)
        rdata.append((self.hrdata.value.integer >> ((poffs << 3) & shift_mask)) & szmsk)
        if self.hresp.value:
            err_resp = True
        self._info_log(
            rw="READ",
            addr=addr,
            burst_type=burst_type,
            burst_length=burst_length,
            size=size,
            data=rdata,
            err_resp=err_resp,
        )
        return (err_resp, tuple(rdata))

    async def reset(self):
        """Reset AHB Master."""
        if self.hsel:
            self.hsel.value = 0
        self.hwrite.value = 0
        self.hwdata.value = 0
        self.htrans.value = 0  # IDLE
        self.hburst.value = 0
        self.hprot.value = 0

    def _info_log(
        self, rw: str, addr: int, burst_type: BurstType, burst_length: int, size: SizeType, data: list, err_resp: bool
    ) -> None:
        """Handle Master Logging."""
        if burst_type == BurstType.INCR:
            blenstr = f" burst length: {burst_length}"
        else:
            blenstr = ""
        err = " ERROR RESP" if err_resp else ""
        self.logger.info(
            f"=MST {rw}{err}= address: {hex(addr)} data: [{','.join(f"0x{x:0{2<<size}X}" for x in data)}] "
            f"size: {size.name} burst: {burst_type.name}{blenstr}"
        )


class AHBSlaveDriver:
    """Active AHB Slave that can respond to Master requests."""

    def __init__(
        self,
        name: str,
        clk: SimHandle,
        rst_an: SimHandle,
        haddr: SimHandle,
        hwrite: SimHandle,
        hwdata: SimHandle,
        htrans: SimHandle,
        hburst: SimHandle,
        hsize: SimHandle,
        hrdata: SimHandle,
        hready: SimHandle,
        hreadyout: SimHandle,
        hresp: SimHandle,
        hsel: SimHandle,
        hprot: SimHandle = None,
        hreadyout_delay: int = 0,
        size_bytes: int = 1024,
        err_addr: dict[Literal["r", "w", "rw"], list[int]] | None = None,
        log_level: int | None = None,
    ):
        """AHB Slave Init."""
        self.name = name
        self.clk = clk
        self.rst_an = rst_an
        self.haddr = haddr
        self.hwrite = hwrite
        self.hwdata = hwdata
        self.htrans = htrans
        self.hburst = hburst
        self.hsize = hsize
        self.hrdata = hrdata
        self.hready = hready
        self.hreadyout = hreadyout
        self.hresp = hresp
        self.hsel = hsel
        self.hprot = hprot  # allowed to be None as it might not be present/unsupported by a slave
        self.data_width = len(hwdata)
        self.err_addr = err_addr

        self.logger = getLogger(name)
        if log_level is not None:  # important explicit check for None as 0 would be a valid value
            self.logger.setLevel(log_level)

        self.mem = bytearray(size_bytes)  # Initialize a 1KB memory
        self.hreadyout_delay = hreadyout_delay  # Delay for HREADYOUT signal to simulate longer access times
        self.addrmask = size_bytes - 1

        # state variables
        self.state = 0
        self.burst_count = 0  # Burst count for burst transactions
        self.curr_addr = None
        self.curr_wdata = None
        self.curr_write = None
        self.curr_size = None

    def _read(self, addr: int, size: int) -> int:
        """AHB Read."""
        # number of bytes in this transfer according to transfer size
        byte_cnt = 2**size
        # extract the data from the bus
        alignmask = byte_cnt - 1
        shift_mask = self.data_width - 1
        datashift_bit = (addr.integer << 3) & shift_mask
        masked_addr = self.addrmask & addr.integer
        unaligned = alignmask & addr.integer
        assert not unaligned, f"Address is unaligned for read with HSIZE of {SizeType(size)!r} at HADDR {addr}."

        rdata = int.from_bytes(self.mem[masked_addr : masked_addr + byte_cnt], "little") << datashift_bit
        hexdata = f"0x{rdata:0{2<<size}X}"
        self.logger.info(f"=SLV READ= address: {hex(addr.integer)} data: {hexdata} size: {SizeType(size).name}")
        self.logger.debug(
            f"=SLV READ= alignment mask: {hex(alignmask)} "
            f"shift mask: {hex(shift_mask)} datashift in bits: {hex(datashift_bit)} "
            f"address (masked): {hex(masked_addr)} byte count: {byte_cnt}"
        )
        return rdata

    def _write(self, addr: int, size: int, data: int) -> None:
        """AHB Write."""
        # number of bytes in this transfer according to transfer size
        byte_cnt = 2**size
        shift_mask = self.data_width - 1
        # extract the data from the bus
        alignmask = byte_cnt - 1
        # lower_addrmask = (byte_cnt * 2) - 1
        lower_datamask = (2 ** (byte_cnt * 8)) - 1
        # datashift_byte = addr.integer & lower_addrmask
        # datashift_bit = datashift_byte * 8
        datashift_bit = (addr.integer << 3) & shift_mask
        unaligned = alignmask & addr.integer
        assert not unaligned, f"Address is unaligned for write with HSIZE of {size} at HADDR {addr}."

        wdata = (data.integer >> datashift_bit) & lower_datamask
        bytes = int.to_bytes(wdata, byte_cnt, "little")
        masked_addr = self.addrmask & addr.integer

        hexdata = f"0x{wdata:0{2<<size}X}"
        self.logger.info(f"=SLV WRITE= address: {hex(addr.integer)} data: {hexdata} size: {SizeType(size).name}")
        self.logger.debug(
            f"=SLV WRITE= alignment mask: {hex(alignmask)} shift mask: {hex(shift_mask)} "
            f"lower data mask {hex(lower_datamask)} datashift in bits: {hex(datashift_bit)} "
            f"address (masked): {hex(masked_addr)} byte count: {byte_cnt} "
            f"data (bytes): {','.join([hex(x) for x in bytes])} "
        )
        self.mem[masked_addr : masked_addr + byte_cnt] = bytes

    def _check_err_addr(self, haddr: int, hwrite: int) -> bool:
        """Check for Error Address."""
        if self.err_addr is None:
            return False
        if hwrite:
            if (haddr in self.err_addr.get("w", [])) or (haddr in self.err_addr.get("rw", [])):
                return True
        elif (haddr in self.err_addr.get("r", [])) or (haddr in self.err_addr.get("rw", [])):
            return True
        return False

    async def run(self):
        """Slave Main Loop."""
        self.hreadyout.value = 1
        self.hrdata.value = 0xDEADDEAD
        while True:
            await RisingEdge(self.clk)
            if self.state:
                for _ in range(self.hreadyout_delay):  # delay the answer if configured
                    await RisingEdge(self.clk)
                    self.hreadyout.value = 0
                self.hreadyout.value = 1
                self.curr_wdata = self.hwdata.value if self.curr_write else 0
                if self.curr_write:
                    # Handle write request
                    self._write(self.curr_addr, self.curr_size, self.curr_wdata)
            # Check if there's an AHB request
            if self.hsel.value and self.htrans.value in (TransType.SEQ, TransType.NONSEQ):
                self.curr_addr = self.haddr.value
                self.curr_write = self.hwrite.value
                self.curr_size = self.hsize.value
                self.state = 1
            else:
                self.state = 0
            if self.state and self._check_err_addr(self.curr_addr, self.curr_write):
                acc = "WRITE" if self.curr_write else "READ"
                self.logger.info(f"=SLV ERROR RESP for {acc}= address: {hex(self.curr_addr)}")
                self.state = 2
            if self.state and not self.curr_write:
                # Handle read request (need to apply read value for next cycle)
                rdata = self._read(self.curr_addr, self.curr_size)
                self.hrdata.value = rdata
            else:
                self.hrdata.value = 0xDEADBEEF  # BOZOjust temp for debugging

    def set_hreadyout_delay(self, delay):
        """Set hreadyout Delay."""
        self.hreadyout_delay = delay

    def set_data(self, data):
        """Preload Slave Memory."""
        self.mem = data

    def log_data(self, start_addr=0, end_addr=None, chunk_size=16):
        """Request logging of Slave Memory content."""
        if end_addr is None:
            end_addr = len(self.mem) - 1
        elif end_addr > len(self.mem) - 1:
            self.logger.error(
                f"=MEMORY CONTENTS= Provided end_addr {hex(end_addr)} to log_data is beyond size of slave memory."
            )
            return
        for i in range(start_addr, end_addr + 1, chunk_size):
            numlen = len(f"{end_addr:X}")
            chunk = ",".join(f"0x{x:02X}" for x in self.mem[i : min(i + chunk_size, end_addr + 1)])
            self.logger.info(f"=MEMORY CONTENTS= 0x{i:0{numlen}X}-0x{i+chunk_size-1:0{numlen}X} [{chunk}]")
