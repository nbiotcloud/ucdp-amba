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
// Module:     ucdp_amba.ucdp_ahb2ahb_example_slv2slv_lrgp_minp_p
// Data Model: ucdp_amba.ucdp_ahb2ahb.UcdpAhb2ahbMod
//
//
// Converting Slave to Slave
//
// Signal    Src Tgt Conv
// hwrite     x   x  forward
// htrans     x   x  forward
// hsize      x   x  forward
// hresp      x   x  forward
// hsel       x   x  forward
// haddr      x   x  reduce
// hwdata     x   x  convert wide to narrow
// hrdata     x   x  convert narrow to wide
// hwstrb     x   -  ignore
// hburst     x   -  ignore
// hnonsec    x   -  ignore
// hmastlock  x   -  ignore
// hauser     -   -  n/a
// hwuser     -   -  n/a
// hruser     -   -  n/a
// hbuser     -   -  n/a
// hmaster    x   -  ignore
// hexcl      x   -  ignore
// hexokay    x   -  tie-off
// hready     x   x  forward
// hreadyout  x   x  forward
// hprot      x   -  ignore
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_ahb2ahb_example_slv2slv_lrgp_minp_p ( // ucdp_amba.ucdp_ahb2ahb.UcdpAhb2ahbMod
  // main_i
  input  logic         main_clk_i,
  input  logic         main_rst_an_i,       // Async Reset (Low-Active)
  // ahb_src_i: AHB Source
  input  logic         ahb_src_hsel_i,      // AHB Slave Select
  input  logic [35:0]  ahb_src_haddr_i,     // AHB Bus Address
  input  logic         ahb_src_hwrite_i,    // AHB Write Enable
  input  logic [1:0]   ahb_src_htrans_i,    // AHB Transfer Type
  input  logic [2:0]   ahb_src_hsize_i,     // AHB Size
  input  logic [2:0]   ahb_src_hburst_i,    // AHB Burst Type
  input  logic [6:0]   ahb_src_hprot_i,     // AHB Transfer Protection
  input  logic         ahb_src_hnonsec_i,   // AHB Secure Transfer
  input  logic         ahb_src_hmastlock_i, // AHB Locked Sequence Enable
  input  logic [127:0] ahb_src_hwdata_i,    // AHB Data
  input  logic [15:0]  ahb_src_hwstrb_i,    // AHB Write Strobe
  input  logic         ahb_src_hready_i,    // AHB Transfer Done to Slave
  input  logic         ahb_src_hexcl_i,     // AHB Exclusive Transfer
  input  logic [5:0]   ahb_src_hmaster_i,   // AHB Master ID
  output logic         ahb_src_hreadyout_o, // AHB Transfer Done from Slave
  output logic         ahb_src_hresp_o,     // AHB Response Error
  output logic         ahb_src_hexokay_o,   // AHB Exclusive Response
  output logic [127:0] ahb_src_hrdata_o,    // AHB Data
  // ahb_tgt_o: AHB Target
  output logic         ahb_tgt_hsel_o,      // AHB Slave Select
  output logic [31:0]  ahb_tgt_haddr_o,     // AHB Bus Address
  output logic         ahb_tgt_hwrite_o,    // AHB Write Enable
  output logic [1:0]   ahb_tgt_htrans_o,    // AHB Transfer Type
  output logic [2:0]   ahb_tgt_hsize_o,     // AHB Size
  output logic [31:0]  ahb_tgt_hwdata_o,    // AHB Data
  output logic         ahb_tgt_hready_o,    // AHB Transfer Done to Slave
  input  logic         ahb_tgt_hreadyout_i, // AHB Transfer Done from Slave
  input  logic         ahb_tgt_hresp_i,     // AHB Response Error
  input  logic [31:0]  ahb_tgt_hrdata_i     // AHB Data
);




  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  // ahb_trans
  localparam integer       ahb_trans_width_p   = 2;
  localparam logic   [1:0] ahb_trans_min_p     = 2'h0; // AHB Transfer Type
  localparam logic   [1:0] ahb_trans_max_p     = 2'h3; // AHB Transfer Type
  localparam logic   [1:0] ahb_trans_idle_e    = 2'h0;
  localparam logic   [1:0] ahb_trans_busy_e    = 2'h1;
  localparam logic   [1:0] ahb_trans_nonseq_e  = 2'h2;
  localparam logic   [1:0] ahb_trans_seq_e     = 2'h3;
  localparam logic   [1:0] ahb_trans_default_p = 2'h0; // AHB Transfer Type
  // ahb_burst
  localparam integer       ahb_burst_width_p   = 3;
  localparam logic   [2:0] ahb_burst_min_p     = 3'h0; // AHB Burst Type
  localparam logic   [2:0] ahb_burst_max_p     = 3'h7; // AHB Burst Type
  localparam logic   [2:0] ahb_burst_single_e  = 3'h0;
  localparam logic   [2:0] ahb_burst_incr_e    = 3'h1;
  localparam logic   [2:0] ahb_burst_wrap4_e   = 3'h2;
  localparam logic   [2:0] ahb_burst_incr4_e   = 3'h3;
  localparam logic   [2:0] ahb_burst_wrap8_e   = 3'h4;
  localparam logic   [2:0] ahb_burst_incr8_e   = 3'h5;
  localparam logic   [2:0] ahb_burst_wrap16_e  = 3'h6;
  localparam logic   [2:0] ahb_burst_incr16_e  = 3'h7;
  localparam logic   [2:0] ahb_burst_default_p = 3'h0; // AHB Burst Type



  // TODO: handle async


  // === standard forwarding ============
  assign ahb_tgt_htrans_o = ahb_src_htrans_i;
  assign ahb_tgt_hwrite_o = ahb_src_hwrite_i;
  assign ahb_tgt_hsize_o = ahb_src_hsize_i;
  assign ahb_src_hresp_o = ahb_tgt_hresp_i;

  // === haddr handling =================
  // ignoring MSBs of source
  assign ahb_tgt_haddr_o = ahb_src_haddr_i[31:0];


  // === hsel handling ==================
  assign ahb_tgt_hsel_o = ahb_src_hsel_i;

  // === hxdata handling ================
  // convert data from wide to narrow
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin: proc_addr_str
    logic [1:0] dmux_sel_r;

    if (main_rst_an_i == 1'b0) begin
      dmux_sel_r <= 2'h0;
    end else begin
      if ((ahb_src_htrans_i == ahb_trans_nonseq_e) || (ahb_src_htrans_i == ahb_trans_seq_e)) begin
        dmux_sel_r <= ahb_src_haddr_i[3:2];
      end
    end
  end

  always_comb begin: proc_data_mux
    case(dmux_sel_r)
      2'h3: begin
        ahb_tgt_hwdata_o = ahb_src_hwdata_i[127:96];
      end

      2'h2: begin
        ahb_tgt_hwdata_o = ahb_src_hwdata_i[95:64];
      end

      2'h1: begin
        ahb_tgt_hwdata_o = ahb_src_hwdata_i[63:32];
      end

      default: begin
        ahb_tgt_hwdata_o = ahb_src_hwdata_i[31:0];
      end
    endcase
  end

  assign ahb_src_hrdata_o = {4{ahb_tgt_hrdata_i}};


  // === hready handling ================
  assign ahb_tgt_hready_o = ahb_src_hready_i;
  assign ahb_src_hreadyout_o = ahb_tgt_hreadyout_i;





  // === hexokay handling ================
  assign ahb_src_hexokay_o = 1'b0;







endmodule // ucdp_ahb2ahb_example_slv2slv_lrgp_minp_p

`default_nettype wire
`end_keywords