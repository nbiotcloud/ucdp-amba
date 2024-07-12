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
"""Simulate generated System Verilog using CocoTB."""

import os

import pytest
from cocotb_test.simulator import run

# fixed seed for reproduceability
SEED = 161411072024

if not os.getenv("SIM"):
    os.environ["SIM"] = "verilator"
if not os.getenv("COCOTB_REDUCED_LOG_FMT"):
    os.environ["COCOTB_REDUCED_LOG_FMT"] = "1"

# if FST is set in environment enable FST tracing, this is only availble if simulator is verilator
fst = ["--trace-fst", "--trace-structs"] if os.getenv("SIM") == "verilator" and os.getenv("FST") else []

prjroot = os.environ["PRJROOT"] = os.getenv("VIRTUAL_ENV", "") + "/../../"

ml_fl = [
    f"{prjroot}/tests/refdata/tests.test_svmako/test_ahb_ml/ucdp_ahb_ml_example/ucdp_ahb_ml_example_ml.sv",
]

apb2mem_fl = [
    f"{prjroot}/tests/refdata/tests.test_svmako/test_apb2mem/ucdp_apb2mem_example/ucdp_apb2mem_example_a2m.sv",
]

ahb2apb_fl = [
    f"{prjroot}/tests/refdata/tests.test_svmako/test_ahb2apb/ucdp_ahb2apb_exsample/ucdp_ahb2apb_example_ahb2apb_amba3_errirqfalse.sv",
    f"{prjroot}/tests/refdata/tests.test_svmako/test_ahb2apb/ucdp_ahb2apb_example/ucdp_ahb2apb_example_ahb2apb_amba3_errirqtrue.sv",
    f"{prjroot}/tests/refdata/tests.test_svmako/test_ahb2apb/ucdp_ahb2apb_example/ucdp_ahb2apb_example_ahb2apb_amba5_errirqfalse.sv",
    f"{prjroot}/tests/refdata/tests.test_svmako/test_ahb2apb/ucdp_ahb2apb_example/ucdp_ahb2apb_example_ahb2apb_amba5_errirqtrue.sv",
    f"{prjroot}/tests/refdata/tests.test_svmako/test_ahb2apb/ucdp_ahb2apb_example/ucdp_ahb2apb_example_odd.sv",
]

tests = [
    ("compile_test", "ucdp_ahb_ml_example_ml", ml_fl),
    ("compile_test", "ucdp_apb2mem_example_a2m", apb2mem_fl),
    ("compile_test", "ucdp_ahb2apb_example_ahb2apb_amba3_errirqfalse", ahb2apb_fl),
    ("compile_test", "ucdp_ahb2apb_example_ahb2apb_amba3_errirqtrue", ahb2apb_fl),
    ("compile_test", "ucdp_ahb2apb_example_ahb2apb_amba5_errirqfalse", ahb2apb_fl),
    ("compile_test", "ucdp_ahb2apb_example_odd", ahb2apb_fl),
    ("ahb_ml_test", "ucdp_ahb_ml_example_ml", ml_fl),
]


@pytest.mark.parametrize("test", tests, ids=[f"{t[1]}:{t[0]}" for t in tests])
def test_generic(test):
    """Generic, parametrized test runner."""
    # print(os.getcwd())
    # print(os.environ)
    top = test[1]
    run(
        verilog_sources=ml_fl,
        toplevel=top,
        module=test[0],
        python_search=[f"{prjroot}/tests/"],
        extra_args=[] + fst + ["-Wno-fatal"],
        sim_build=f"sim_build_{top}",
        workdir=f"sim_run_{top}_{test}",
        timescale="1ns/1ps",
        seed=SEED,
        gui=os.getenv("GUI", ""),
    )
