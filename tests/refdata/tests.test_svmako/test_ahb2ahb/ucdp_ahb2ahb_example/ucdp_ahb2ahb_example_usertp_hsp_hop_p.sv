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
// Module:     ucdp_amba.ucdp_ahb2ahb_example_usertp_hsp_hop_p
// Data Model: ucdp_amba.ucdp_ahb2ahb.UcdpAhb2ahbMod
//
//
// Converting Master to Master
//
// Signal    Src Tgt Conv
// hwrite     x   x  forward
// htrans     x   x  forward
// hsize      x   x  forward
// hresp      x   x  forward
// hsel       -   -  n/a
// haddr      x   x  forward
// hwdata     x   x  forward
// hrdata     x   x  forward
// hwstrb     -   -  n/a
// hburst     -   -  n/a
// hnonsec    -   -  n/a
// hmastlock  -   -  n/a
// hauser     x   x  expand by port
// hwuser     x   x  expand by port
// hruser     x   x  tie-off
// hbuser     x   x  tie-off
// hmaster    -   -  n/a
// hexcl      -   -  n/a
// hexokay    -   -  n/a
// hready     x   x  forward
// hreadyout  -   -  n/a
// hprot      -   -  n/a
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_ahb2ahb_example_usertp_hsp_hop_p ( // ucdp_amba.ucdp_ahb2ahb.UcdpAhb2ahbMod
  // ahb_src_i: AHB Source
  input  logic [1:0]  ahb_src_htrans_i, // AHB Transfer Type
  input  logic [31:0] ahb_src_haddr_i,  // AHB Bus Address
  input  logic [4:0]  ahb_src_hauser_i, // AHB Address User Channel
  input  logic [4:0]  ahb_src_hwuser_i, // AHB Write Data User Channel
  input  logic        ahb_src_hwrite_i, // AHB Write Enable
  input  logic [2:0]  ahb_src_hsize_i,  // AHB Size
  input  logic [31:0] ahb_src_hwdata_i, // AHB Data
  output logic        ahb_src_hready_o, // AHB Transfer Done
  output logic        ahb_src_hresp_o,  // AHB Response Error
  output logic [31:0] ahb_src_hrdata_o, // AHB Data
  output logic [4:0]  ahb_src_hruser_o, // AHB Read Data User Channel
  output logic [4:0]  ahb_src_hbuser_o, // AHB Read Response User Channel
  // ahb_tgt_o: AHB Target
  output logic [1:0]  ahb_tgt_htrans_o, // AHB Transfer Type
  output logic [31:0] ahb_tgt_haddr_o,  // AHB Bus Address
  output logic [5:0]  ahb_tgt_hauser_o, // AHB Address User Channel
  output logic [5:0]  ahb_tgt_hwuser_o, // AHB Write Data User Channel
  output logic        ahb_tgt_hwrite_o, // AHB Write Enable
  output logic [2:0]  ahb_tgt_hsize_o,  // AHB Size
  output logic [31:0] ahb_tgt_hwdata_o, // AHB Data
  input  logic        ahb_tgt_hready_i, // AHB Transfer Done
  input  logic        ahb_tgt_hresp_i,  // AHB Response Error
  input  logic [31:0] ahb_tgt_hrdata_i, // AHB Data
  input  logic [5:0]  ahb_tgt_hruser_i, // AHB Read Data User Channel
  input  logic [5:0]  ahb_tgt_hbuser_i, // AHB Read Response User Channel
  input  logic [0:0]  hauser_ext_i,     // Target HAUSER Extension
  input  logic [0:0]  hwuser_ext_i      // Target HWUSER Extension
);




  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  // ahb_trans
  localparam integer       ahb_trans_width_p    = 2;
  localparam logic   [1:0] ahb_trans_min_p      = 2'h0;  // AHB Transfer Type
  localparam logic   [1:0] ahb_trans_max_p      = 2'h3;  // AHB Transfer Type
  localparam logic   [1:0] ahb_trans_idle_e     = 2'h0;
  localparam logic   [1:0] ahb_trans_busy_e     = 2'h1;
  localparam logic   [1:0] ahb_trans_nonseq_e   = 2'h2;
  localparam logic   [1:0] ahb_trans_seq_e      = 2'h3;
  localparam logic   [1:0] ahb_trans_default_p  = 2'h0;  // AHB Transfer Type
  // ahb_burst
  localparam integer       ahb_burst_width_p    = 3;
  localparam logic   [2:0] ahb_burst_min_p      = 3'h0;  // AHB Burst Type
  localparam logic   [2:0] ahb_burst_max_p      = 3'h7;  // AHB Burst Type
  localparam logic   [2:0] ahb_burst_single_e   = 3'h0;
  localparam logic   [2:0] ahb_burst_incr_e     = 3'h1;
  localparam logic   [2:0] ahb_burst_wrap4_e    = 3'h2;
  localparam logic   [2:0] ahb_burst_incr4_e    = 3'h3;
  localparam logic   [2:0] ahb_burst_wrap8_e    = 3'h4;
  localparam logic   [2:0] ahb_burst_incr8_e    = 3'h5;
  localparam logic   [2:0] ahb_burst_wrap16_e   = 3'h6;
  localparam logic   [2:0] ahb_burst_incr16_e   = 3'h7;
  localparam logic   [2:0] ahb_burst_default_p  = 3'h0;  // AHB Burst Type
  // tgt_hruser
  localparam integer       tgt_hruser_width_p   = 6;
  localparam logic   [5:0] tgt_hruser_min_p     = 6'h00; // Another AHB User Type
  localparam logic   [5:0] tgt_hruser_max_p     = 6'h3F; // Another AHB User Type
  localparam logic   [5:0] tgt_hruser_audio_e   = 6'h00;
  localparam logic   [5:0] tgt_hruser_apps_e    = 6'h02;
  localparam logic   [5:0] tgt_hruser_comm_e    = 6'h05;
  localparam logic   [5:0] tgt_hruser_default_p = 6'h05; // Another AHB User Type
  // tgt_hbuser
  localparam integer       tgt_hbuser_width_p   = 6;
  localparam logic   [5:0] tgt_hbuser_min_p     = 6'h00; // Another AHB User Type
  localparam logic   [5:0] tgt_hbuser_max_p     = 6'h3F; // Another AHB User Type
  localparam logic   [5:0] tgt_hbuser_audio_e   = 6'h00;
  localparam logic   [5:0] tgt_hbuser_apps_e    = 6'h02;
  localparam logic   [5:0] tgt_hbuser_comm_e    = 6'h05;
  localparam logic   [5:0] tgt_hbuser_default_p = 6'h05; // Another AHB User Type



  // TODO: handle async


  // === standard forwarding ============
  assign ahb_tgt_htrans_o = ahb_src_htrans_i;
  assign ahb_tgt_hwrite_o = ahb_src_hwrite_i;
  assign ahb_tgt_hsize_o = ahb_src_hsize_i;
  assign ahb_src_hresp_o = ahb_tgt_hresp_i;

  // === haddr handling =================
  assign ahb_tgt_haddr_o = ahb_src_haddr_i;



  // === hxdata handling ================
  // just forward read/write data
  assign ahb_tgt_hwdata_o = ahb_src_hwdata_i;
  assign ahb_src_hrdata_o = ahb_tgt_hrdata_i;


  // === hready handling ================
  assign ahb_src_hready_o = ahb_tgt_hready_i;







  // === hauser handling =================
  assign ahb_tgt_hauser_o = {hauser_ext_i, ahb_src_hauser_i};

  // === hwuser handling =================
  assign ahb_tgt_hwuser_o = {hwuser_ext_i, ahb_src_hwuser_i};

  // === hruser handling =================
  assign ahb_src_hruser_o = 5'h01;

  // === hbuser handling =================
  assign ahb_src_hbuser_o = 5'h01;


endmodule // ucdp_ahb2ahb_example_usertp_hsp_hop_p

`default_nettype wire
`end_keywords