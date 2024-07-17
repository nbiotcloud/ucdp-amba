from enum import IntEnum
from typing import Iterable, List, Tuple

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

def _prep_addr_iter(addr:int, burst_length:int, size:SizeType, burst_type=BurstType) ->Tuple[int, int, int, int]:
    """Prepare Address Iterations."""
    match burst_type:
        case BurstType.INCR16 | BurstType.WRAP16:
            mask = (1<<(size+4))-1
            len = 16
        case BurstType.INCR8 | BurstType.WRAP8:
            mask = (1<<(size+3))-1
            len = 8
        case BurstType.INCR4 | BurstType.WRAP4:
            mask = (1<<(size+2))-1
            len = 4
        case BurstType.INCR:
            mask = -1
            len = burst_length
        case other:
            mask = -1
            len = 1
    base = addr & ~mask
    offs = addr & mask
    return (base, offs, mask, len)

def _check_bus_acc(data_width:int, addr:int, offs:int, size:SizeType, burst_type=BurstType) -> None:
    """Cehck AHB Bus Access."""

    if data_width < (8 << size):
        raise ValueError(f"Size argument {size!r} -> {8<<size} too big for data width of {data_width}!")
    if (addr & ((1 << size)-1)) != 0:
        raise ValueError(f"Address {addr:x} is not aligned to size argument {size!r}!")
    if (burst_type == BurstType.INCR16) or (burst_type == BurstType.INCR8) or (burst_type == BurstType.INCR4):
        if offs != 0:
            raise ValueError(f"Address {addr:x} is not aligned to BurstType {burst_type!r}!")


class SlaveFsmState(IntEnum):
    """Internal AHB Slave State."""

    IDLE = 0
    ACTIVE = 1


class AHBMasterDriver:
    """AHB Master bus driver."""

    def __init__(
        self, clk, rst_an, haddr, hwrite, hwdata, htrans, hburst, hsize, hprot, hrdata, hready, hresp, hsel=None
    ):
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
        self.data_width = len(hwdata)


    async def write(self, addr:int, data:int|Iterable, size:SizeType=SizeType.WORD,
                    burst_length:int=1, burst_type:BurstType=BurstType.SINGLE) -> None:
        """AHB Write (Burst)."""

        base, offs, mask, burst_length = _prep_addr_iter(addr=addr, burst_length=burst_length,
                                                         size=size, burst_type=burst_type)
        _check_bus_acc(data_width=self.data_width, addr=addr, offs=offs, size=size, burst_type=burst_type)

        if isinstance(data, int):
            data = iter((data, ))
        else:
            data = iter(data)
        shmsk = self.data_width - 1
        self.haddr.value = base + offs
        self.hwdata.value = 0
        self.hwrite.value = 1
        if self.hsel:
            self.hsel.value = 1
        self.htrans.value = TransType.NONSEQ
        self.hburst.value = burst_type
        self.hsize.value = size
        await RisingEdge(self.clk)
        for _ in range(burst_length - 1):
            self.htrans.value = TransType.SEQ
            self.hwdata.value = next(data) << ((offs<<3) & shmsk)
            offs = (offs + (1<<size)) & mask
            self.haddr.value = base + offs
            await RisingEdge(self.clk)
            while self.hready == 0:
                await RisingEdge(self.clk)
        if self.hsel:
            self.hsel.value = 0
        self.haddr.value = 0
        self.hwdata.value = next(data) << ((offs<<3) & shmsk)
        self.hwrite.value = 0
        self.htrans.value = TransType.IDLE
        self.hburst.value = BurstType.SINGLE
        self.hsize.value = SizeType.BYTE
        await RisingEdge(self.clk)
        while self.hready == 0:
            await RisingEdge(self.clk)
        self.hwdata.value = 0

    async def read(self, addr:int, burst_length:int=1, size:SizeType=SizeType.WORD, 
                   burst_type:BurstType=BurstType.SINGLE) ->Tuple[int]:
        """AHB Read (Burst)."""

        base, offs, mask, burst_length = _prep_addr_iter(addr=addr, burst_length=burst_length,
                                                         size=size, burst_type=burst_type)
        _check_bus_acc(data_width=self.data_width, addr=addr, offs=offs, size=size, burst_type=burst_type)

        rdata = []
        poffs = offs
        shmsk = self.data_width - 1
        szmsk = (1 << (8 << size)) - 1
        self.haddr.value = base + offs
        if self.hsel:
            self.hsel.value = 1
        self.hwrite.value = 0
        self.htrans.value = TransType.NONSEQ
        self.hburst.value = burst_type
        await RisingEdge(self.clk)

        for _ in range(burst_length - 1):
            self.htrans.value = TransType.SEQ
            offs = (offs + (1<<size)) & mask
            self.haddr.value = base + offs
            await RisingEdge(self.clk)
            while self.hready == 0:
                await RisingEdge(self.clk)
            rdata.append((self.hrdata.value.integer >> ((poffs<<3) & shmsk)) & szmsk)
            poffs = offs
        if self.hsel:
            self.hsel.value = 0
        self.haddr.value = 0
        self.htrans.value = TransType.IDLE
        await RisingEdge(self.clk)
        while self.hready == 0:
            await RisingEdge(self.clk)
        rdata.append((self.hrdata.value.integer >> ((poffs<<3) & shmsk)) & szmsk)
        return tuple(rdata)

    async def reset(self):
        if self.hsel:
            self.hsel.value = 0
        self.hwrite.value = 0
        self.hwdata.value = 0
        self.htrans.value = 0  # IDLE
        self.hburst.value = 0
        await RisingEdge(self.clk)
        if self.hsel:
            self.hsel.value = 1
        self.hwrite.value = 1
        self.hwdata.value = 0
        self.htrans.value = 2  # NONSEQ
        self.hburst.value = 0
        await RisingEdge(self.clk)
        if self.hsel:
            self.hsel.value = 0
        self.htrans.value = 0  # IDLE


class AHBSlaveDriver:
    """Active AHB Slave that can respond to Master requests."""

    def __init__(self, clk, rst_an, haddr, hwrite, hwdata, htrans, hburst, hsize, hrdata, hready, hreadyout, hresp, hsel, hprot=None, hreadyout_delay=0, size_bytes=1024):
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
        self.hprot = hprot  # allowed to be None as it might not be present (e.g. Multilayer input)

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

    def read(self, addr, size):
        # number of bytes in this transfer according to transfer size 
        byte_cnt = 2**size
        # extract the data from the bus
        alignmask = byte_cnt-1
        lower_addrmask = (byte_cnt*2)-1
        lower_datamask = (byte_cnt*8)-1
        datashift_byte = addr.integer & lower_addrmask
        datashift_bit = datashift_byte * 8
        unaligned = alignmask & addr.integer
        if unaligned:
            raise ValueError(f"Address is unaligned for write with HSIZE of {size} at HADDR {addr}.")

        masked_addr = self.addrmask & addr.integer

        rdata = int.from_bytes(self.mem[masked_addr:masked_addr+byte_cnt]) << datashift_bit
        return rdata

    def write(self, addr, size, data):
        # number of bytes in this transfer according to transfer size 
        byte_cnt = 2**size
        # extract the data from the bus
        alignmask = byte_cnt-1
        lower_addrmask = (byte_cnt*2)-1
        lower_datamask = (byte_cnt*8)-1
        datashift_byte = addr.integer & lower_addrmask
        datashift_bit = datashift_byte * 8
        unaligned = alignmask & addr.integer
        if unaligned:
            raise ValueError(f"Address is unaligned for write with HSIZE of {size} at HADDR {addr}.")
        # TODO confirm alignment
        wdata = (data.integer >> datashift_bit) & lower_datamask

        masked_addr = self.addrmask & addr.integer
        print("==WRITE TRANSFER== DATA:", hex(data), "ADDR:", hex(masked_addr), "SIZE_BYTES:", byte_cnt)
        bytes = data.buff

        self.mem[masked_addr:masked_addr+byte_cnt] = bytes

    async def run(self):
        while True:
            self.hreadyout.value = 1
            self.hrdata.value = 0
            if not self.state:
                await RisingEdge(self.clk)
            # Check if there's an AHB request
            if self.hsel.value and self.htrans.value in (TransType.SEQ, TransType.NONSEQ):
                self.curr_addr = self.haddr.value
                self.curr_write = self.hwrite.value
                self.curr_size = self.hsize.value
                for _ in range(self.hreadyout_delay):  # delay the answer if configured
                    await RisingEdge(self.clk)
                    self.hreadyout.value = 0
                self.hreadyout.value = 1
                await RisingEdge(self.clk)
                if self.hsel.value and self.htrans.value in (TransType.SEQ, TransType.NONSEQ):
                    self.state = 1
                else:
                    self.state = 0
                self.curr_wdata = self.hwdata.value if self.curr_write else 0
                if self.curr_write:
                    # Handle write request
                    self.write(self.curr_addr, self.curr_size, self.curr_wdata)
                else:
                    # Handle read request
                    rdata = self.read(self.curr_addr, self.curr_size)
                    self.hrdata.value = rdata
                

    def set_hreadyout_delay(self, delay):
        self.hreadyout_delay = delay

    def set_data(self, data):
        self.mem = data