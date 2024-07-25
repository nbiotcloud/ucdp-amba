// =============================================================================
//
// THIS FILE IS GENERATED!!! DO NOT EDIT MANUALLY. CHANGES ARE LOST.
//
// =============================================================================
//
//  MIT License
//
//  Copyright (c) 2024 nbiotcloud
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
// =============================================================================
//
// Module:     ucdp_amba.ucdp_apb2mem_example_a2m
// Data Model: ucdp_amba.ucdp_apb2mem.UcdpApb2memMod
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_apb2mem_example_a2m ( // ucdp_amba.ucdp_apb2mem.UcdpApb2memMod
  // apb_slv_i: APB Slave
  input  logic [9:0]  apb_slv_paddr_i,   // APB Bus Address
  input  logic        apb_slv_pwrite_i,  // APB Write Enable
  input  logic [15:0] apb_slv_pwdata_i,  // APB Data
  input  logic        apb_slv_penable_i, // APB Transfer Enable
  input  logic        apb_slv_psel_i,    // APB Slave Select
  output logic [15:0] apb_slv_prdata_o,  // APB Data
  output logic        apb_slv_pslverr_o, // APB Response Error
  output logic        apb_slv_pready_o,  // APB Transfer Done
  // mem_o
  output logic        mem_ena_o,
  output logic [7:0]  mem_addr_o,
  output logic        mem_wena_o,
  output logic [15:0] mem_wdata_o,
  input  logic [15:0] mem_rdata_i,
  input  logic        mem_err_i
);


endmodule // ucdp_apb2mem_example_a2m

`default_nettype wire
`end_keywords
