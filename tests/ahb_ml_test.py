import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from ahb_driver import AHBMasterDriver

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
        hclk,
        rst_an,
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


    hclk_proc = cocotb.start_soon(Clock(hclk, period=10).start())
    
    # initial reset
    rst_an.value = 0
    await wait_clocks(hclk, 10)
    rst_an.value = 1
    await wait_clocks(hclk, 10)

    await ext_mst.write(0xF0000000, 0xAFFEAFFE)
