import cocotb
from cocotb.triggers import Timer

async def generate_clock(dut):
    """Generate clock pulses."""
    for cycle in range(1000):
        dut.clk.value = 0
        await Timer(5, unit="ns")
        dut.clk.value = 1
        await Timer(5, unit="ns")

@cocotb.test()
async def test_1(dut):
    await cocotb.start(generate_clock(dut))
    print("AXI Write Transaction")
    await Timer(5, unit="ns")  
    dut.reset.value = 1
    dut.awvalid.value = 0
    dut.wvalid.value = 0
    dut.bready.value = 0
    dut.pready.value = 0
    await Timer(15, unit="ns")
    dut.reset.value = 0
    await Timer(20, unit="ns")
    dut.awvalid.value = 1
    dut.awaddr.value = 1
    await Timer(20, unit="ns")  
    dut.awvalid.value = 0
    await Timer(10, unit="ns")  
    dut.wvalid.value = 1
    dut.wdata.value = 10
    await Timer(20, unit="ns")  
    dut.bready.value = 1
    await Timer(40, unit="ns")  
    dut.pready.value = 1
    # await Timer(40, unit="ns")  
    # dut.pready.value = 0
    dut._log.info("APB address = %d, pwdata = %d",
                  dut.paddr.value, dut.pwdata.value)
    assert dut.paddr.value == 1, "APB address is not correct"   
    assert dut.pwdata.value == 10, "APB write data is not correct"  

@cocotb.test()
async def test_2(dut):
    """Test """
    await cocotb.start(generate_clock(dut))
    print("AXI Write Transaction")
    await Timer(5, unit="ns")  
    dut.reset.value = 1
    dut.awvalid.value = 0
    dut.wvalid.value = 0
    dut.bready.value = 0
    dut.pready.value = 0
    await Timer(15, unit="ns")
    dut.reset.value = 0
    await Timer(20, unit="ns")
    dut.awvalid.value = 1
    dut.awaddr.value = 1
    dut.wvalid.value = 1
    await Timer(10, unit="ns")
    dut.wvalid.value = 1
    await Timer(10, unit="ns")  
    dut.awvalid.value = 0
    dut.wvalid.value = 0
    await Timer(10, unit="ns")  
    dut.wvalid.value = 1
    dut.wdata.value = 10
    await Timer(20, unit="ns")  
    dut.bready.value = 1
    await Timer(40, unit="ns")  
    dut.pready.value = 1
    # await Timer(40, unit="ns")  
    # dut.pready.value = 0
    dut._log.info("APB address = %d, pwdata = %d",
                  dut.paddr.value, dut.pwdata.value)
    assert dut.paddr.value == 1, "APB address is not correct"   
    assert dut.pwdata.value == 10, "APB write data is not correct"  
     
def test_axitoapbrunner():
    import os
    from pathlib import Path
    from cocotb_tools.runner import get_runner
    
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    
    # RTL source file
    sources = [
        proj_path / "sources/axitoapb.sv"
    ]
    
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="axitoapb",
        always=True,
    )
    
    runner.test(hdl_toplevel="axitoapb", test_module="test_axitoapb_hidden")
