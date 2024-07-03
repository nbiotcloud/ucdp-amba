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
Unified Chip Design Platform - AMBA - APB2MEM.
"""

import ucdp as u
from typing import ClassVar
from ucdp_glbl.mem import MemIoType
from . import types as t


class UcdpApb2memMod(u.ATailoredMod):
    """APB to MEMio Converter."""

    datawidth: int = 32
    """Data Width in Bits."""
    addrwidth: int = 12
    """Address Width in Bits."""
    proto: t.AmbaProto = t.AmbaProto()
    """AMBA Protocol Specifier."""

    filelists: ClassVar[u.ModFileLists] = (
        u.ModFileList(
            name="hdl",
            gen="full",
            filepaths=("$PRJROOT/{mod.topmodname}/{mod.modname}.sv"),
            template_filepaths=("ucdp_apb2mem.sv.mako", "sv.mako"),
        ),
    )

    def _build(self):
        self.add_port(t.ApbSlvType(proto=self.proto, addrwidth=self.addrwidth, datawidth=self.datawidth), "apb_slv_i", title="APB Slave Input")
        self.add_port(MemIoType(addrwidth=self.addrwidth-2, datawidth=self.datawidth, writable=True, err=True), "mem_o", title="Memory Interface")

    @staticmethod
    def build_top(**kwargs):
        """Build example top module and return it."""
        return UcdpApb2MemExampleMod()
    
class UcdpApb2MemExampleMod(u.AMod):
    """Example Converter."""

    def _build(self):
        UcdpApb2memMod(self, "u_a2m", datawidth=16, addrwidth=10)
