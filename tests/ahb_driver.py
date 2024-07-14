from enum import IntEnum

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

    async def write(self, addr, data, size=SizeType.WORD, burst_length=1, burst_type=BurstType.SINGLE):
        self.haddr.value = addr
        self.hwdata.value = 0
        self.hwrite.value = 1
        if self.hsel:
            self.hsel.value = 1
        self.htrans.value = TransType.NONSEQ
        self.hburst.value = burst_type
        self.hsize.value = size
        await RisingEdge(self.clk)
        self.haddr.value = 0
        self.hwdata.value = data
        self.hwrite.value = 0
        self.htrans.value = TransType.IDLE
        # TODO wait for ready
        for _ in range(burst_length - 1):
            self.htrans.value = TransType.SEQ
            self.hwdata.value = data
            await RisingEdge(self.clk)
        if self.hsel:
            self.hsel.value = 0

    async def read(self, addr, burst_length=1, burst_type=BurstType.SINGLE):
        self.bus.value = addr
        await RisingEdge(self.clk)
        if self.hsel:
            self.hsel.value = 1
        self.hwrite.value = 0
        self.htrans.value = TransType.NONSEQ
        self.hburst.value = burst_type
        for _ in range(burst_length - 1):
            self.hsel.value = 1
            self.htrans.value = TransType.SEQ
            await RisingEdge(self.clk)
        if self.hsel:
            self.hsel.value = 0
        return self.hrdata.value

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


class AHBSlave:
    """Active AHB Slave that can respond to Master requests."""

    def __init__(self, dut, hready_delay=0):
        self.dut = dut
        self.mem = bytearray(1024)  # Initialize a 1KB memory
        self.hready_delay = hready_delay  # Delay for HREADY signal
        self.burst_count = 0  # Burst count for burst transactions

    async def read(self, addr, size):
        # Read data from memory
        data = bytearray()
        for i in range(size):
            data.append(self.mem[addr + i])
        return data

    async def write(self, addr, data):
        # Write data to memory
        for i, byte in enumerate(data):
            self.mem[addr + i] = byte

    async def run(self):
        while True:
            await RisingEdge(self.clk)
            # Check if there's an AHB request
            if self.dut.hsel.value and self.dut.hready.value:
                if self.dut.hwrite.value:
                    # Handle write request
                    if self.dut.hburst.value == 0:  # Single transfer
                        data = await self.dut.hwdata.read()
                        await self.write(self.dut.haddr.value, data)
                    else:  # Burst transfer
                        self.burst_count = 2 if self.dut.hburst.value == 2 else 1
                        data = await self.dut.hwdata.read()
                        await self.write(self.dut.haddr.value, data)
                        self.dut.haddr.value += 4  # Increment address for burst
                elif self.dut.hburst.value == 0:  # Single transfer
                    size = 2 if self.dut.hburst.value == 2 else 1
                    data = await self.read(self.dut.haddr.value, size)
                    await self.dut.hrdata.write(data)
                else:  # Burst transfer
                    size = 2 if self.dut.hburst.value == 2 else 1
                    data = await self.read(self.dut.haddr.value, size)
                    await self.dut.hrdata.write(data)
                    self.dut.haddr.value += 4  # Increment address for burst
                    self.burst_count -= 1
                    if self.burst_count == 0:
                        self.dut.hready.value = 1
                        self.dut.hresp.value = 0  # No error
                for _ in range(self.hready_delay):
                    await RisingEdge(self.clk)
            else:
                self.dut.hready.value = 0

    def set_hready_delay(self, delay):
        self.hready_delay = delay
