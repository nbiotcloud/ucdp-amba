import cocotb
from ahb_driver import AHBMasterDriver, AHBSlaveDriver, BurstType, SizeType
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Combine


# TODO put this is a generic tb lib
async def wait_clocks(clock, cycles):
    for _ in range(cycles):
        await RisingEdge(clock)


@cocotb.test()
async def ahb_ml_test(dut):
    hclk = dut.main_clk_i
    rst_an = dut.main_rst_an_i

    ext_mst = AHBMasterDriver(
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

    hclk_proc = cocotb.start_soon(Clock(hclk, period=10).start())

    ram_slv_proc = cocotb.start_soon(ram_slv.run())

    # initial reset
    rst_an.value = 0
    dut.ahb_slv_ram_hrdata_i.value = 0x76543210
    await wait_clocks(hclk, 10)
    rst_an.value = 1
    await wait_clocks(hclk, 10)

    ext_wr = cocotb.start_soon(ext_mst.write(0xF0000000, 0xAFFEAFFE))
    dsp_wr = cocotb.start_soon(dsp_mst.write(0xF0000016, (0x11, 0x22, 0x33, 0x44),
                                             burst_type=BurstType.WRAP4, size=SizeType.HALFWORD))

    await Combine(ext_wr, dsp_wr)

    
    rdata = await ext_mst.read(0xF0000100, burst_type=BurstType.INCR8, size=SizeType.WORD)
    print("BOZO", [hex(data) for data in rdata])

    await wait_clocks(hclk, 30)
