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
// Module:     ucdp_amba.ucdp_ahb_ml_example_ml
// Data Model: ucdp_amba.ucdp_ahb_ml.UcdpAhbMlMod
//
//
//  Master > Slave    ram    periph    misc
// ----------------  -----  --------  ------
//       ext           X                X
//       dsp           X       X
//
//
// Size: 3.75 GB
//
// | Addrspace | Type     | Base       | Size                    | Attributes |
// | --------- | ----     | ----       | ----                    | ---------- |
// | reserved0 | Reserved | 0x0        | 536870912x32 (2 GB)     |            |
// | misc      | Slave    | 0x80000000 | 5888x32 (23 KB)         |            |
// | reserved1 | Reserved | 0x80005C00 | 469756160x32 (1.75 GB)  |            |
// | ram       | Slave    | 0xF0000000 | 16384x32 (64 KB)        |            |
// | periph    | Slave    | 0xF0010000 | 16384x32 (64 KB)        |            |
// | misc      | Slave    | 0xF0020000 | 8192x32 (32 KB)         |            |
// | reserved2 | Reserved | 0xF0028000 | 67067904x32 (255.84 MB) |            |
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none

module ucdp_ahb_ml_example_ml ( // ucdp_amba.ucdp_ahb_ml.UcdpAhbMlMod
  // main_i
  input  wire         main_clk_i,
  input  wire         main_rst_an_i,              // Async Reset (Low-Active)
  // ahb_mst_ext_i: AHB Input 'ext'
  input  wire  [1:0]  ahb_mst_ext_htrans_i,       // AHB Transfer Type
  input  wire  [31:0] ahb_mst_ext_haddr_i,        // AHB Bus Address
  input  wire         ahb_mst_ext_hwrite_i,       // AHB Write Enable
  input  wire  [2:0]  ahb_mst_ext_hsize_i,        // AHB Size
  input  wire  [2:0]  ahb_mst_ext_hburst_i,       // AHB Burst Type
  input  wire  [3:0]  ahb_mst_ext_hprot_i,        // AHB Transfer Protection
  input  wire  [31:0] ahb_mst_ext_hwdata_i,       // AHB Data
  output logic        ahb_mst_ext_hready_o,       // AHB Transfer Done
  output logic        ahb_mst_ext_hresp_o,        // AHB Response Error
  output logic [31:0] ahb_mst_ext_hrdata_o,       // AHB Data
  // ahb_mst_dsp_i: AHB Input 'dsp'
  input  wire  [1:0]  ahb_mst_dsp_htrans_i,       // AHB Transfer Type
  input  wire  [31:0] ahb_mst_dsp_haddr_i,        // AHB Bus Address
  input  wire         ahb_mst_dsp_hwrite_i,       // AHB Write Enable
  input  wire  [2:0]  ahb_mst_dsp_hsize_i,        // AHB Size
  input  wire  [2:0]  ahb_mst_dsp_hburst_i,       // AHB Burst Type
  input  wire  [3:0]  ahb_mst_dsp_hprot_i,        // AHB Transfer Protection
  input  wire  [31:0] ahb_mst_dsp_hwdata_i,       // AHB Data
  output logic        ahb_mst_dsp_hready_o,       // AHB Transfer Done
  output logic        ahb_mst_dsp_hresp_o,        // AHB Response Error
  output logic [31:0] ahb_mst_dsp_hrdata_o,       // AHB Data
  // ahb_slv_ram_o: AHB Output 'ram'
  output logic        ahb_slv_ram_hsel_o,         // AHB Slave Select
  output logic [31:0] ahb_slv_ram_haddr_o,        // AHB Bus Address
  output logic        ahb_slv_ram_hwrite_o,       // AHB Write Enable
  output logic [1:0]  ahb_slv_ram_htrans_o,       // AHB Transfer Type
  output logic [2:0]  ahb_slv_ram_hsize_o,        // AHB Size
  output logic [2:0]  ahb_slv_ram_hburst_o,       // AHB Burst Type
  output logic [3:0]  ahb_slv_ram_hprot_o,        // AHB Transfer Protection
  output logic [31:0] ahb_slv_ram_hwdata_o,       // AHB Data
  output logic        ahb_slv_ram_hready_o,       // AHB Transfer Done to Slave
  input  wire         ahb_slv_ram_hreadyout_i,    // AHB Transfer Done from Slave
  input  wire         ahb_slv_ram_hresp_i,        // AHB Response Error
  input  wire  [31:0] ahb_slv_ram_hrdata_i,       // AHB Data
  // ahb_slv_periph_o: AHB Output 'periph'
  output logic        ahb_slv_periph_hsel_o,      // AHB Slave Select
  output logic [31:0] ahb_slv_periph_haddr_o,     // AHB Bus Address
  output logic        ahb_slv_periph_hwrite_o,    // AHB Write Enable
  output logic [1:0]  ahb_slv_periph_htrans_o,    // AHB Transfer Type
  output logic [2:0]  ahb_slv_periph_hsize_o,     // AHB Size
  output logic [2:0]  ahb_slv_periph_hburst_o,    // AHB Burst Type
  output logic [3:0]  ahb_slv_periph_hprot_o,     // AHB Transfer Protection
  output logic [31:0] ahb_slv_periph_hwdata_o,    // AHB Data
  output logic        ahb_slv_periph_hready_o,    // AHB Transfer Done to Slave
  input  wire         ahb_slv_periph_hreadyout_i, // AHB Transfer Done from Slave
  input  wire         ahb_slv_periph_hresp_i,     // AHB Response Error
  input  wire  [31:0] ahb_slv_periph_hrdata_i,    // AHB Data
  // ahb_slv_misc_o: AHB Output 'misc'
  output logic        ahb_slv_misc_hsel_o,        // AHB Slave Select
  output logic [31:0] ahb_slv_misc_haddr_o,       // AHB Bus Address
  output logic        ahb_slv_misc_hwrite_o,      // AHB Write Enable
  output logic [1:0]  ahb_slv_misc_htrans_o,      // AHB Transfer Type
  output logic [2:0]  ahb_slv_misc_hsize_o,       // AHB Size
  output logic [2:0]  ahb_slv_misc_hburst_o,      // AHB Burst Type
  output logic [3:0]  ahb_slv_misc_hprot_o,       // AHB Transfer Protection
  output logic [31:0] ahb_slv_misc_hwdata_o,      // AHB Data
  output logic        ahb_slv_misc_hready_o,      // AHB Transfer Done to Slave
  input  wire         ahb_slv_misc_hreadyout_i,   // AHB Transfer Done from Slave
  input  wire         ahb_slv_misc_hresp_i,       // AHB Response Error
  input  wire  [31:0] ahb_slv_misc_hrdata_i       // AHB Data
);




  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  // ahb_trans
  localparam integer       ahb_trans_width_p      = 2;
  localparam         [1:0] ahb_trans_min_p        = 2'h0; // AHB Transfer Type
  localparam         [1:0] ahb_trans_max_p        = 2'h3; // AHB Transfer Type
  localparam         [1:0] ahb_trans_idle_e       = 2'h0;
  localparam         [1:0] ahb_trans_busy_e       = 2'h1;
  localparam         [1:0] ahb_trans_nonseq_e     = 2'h2;
  localparam         [1:0] ahb_trans_seq_e        = 2'h3;
  localparam         [1:0] ahb_trans_default_p    = 2'h0; // AHB Transfer Type
  // ahb_resp
  localparam integer       ahb_resp_width_p       = 1;
  localparam               ahb_resp_min_p         = 1'b0; // AHB Response Error
  localparam               ahb_resp_max_p         = 1'b1; // AHB Response Error
  localparam               ahb_resp_okay_e        = 1'b0;
  localparam               ahb_resp_error_e       = 1'b1;
  localparam               ahb_resp_default_p     = 1'b0; // AHB Response Error
  // ahb_size
  localparam integer       ahb_size_width_p       = 3;
  localparam         [2:0] ahb_size_min_p         = 3'h0; // AHB Size
  localparam         [2:0] ahb_size_max_p         = 3'h7; // AHB Size
  localparam         [2:0] ahb_size_byte_e        = 3'h0;
  localparam         [2:0] ahb_size_halfword_e    = 3'h1;
  localparam         [2:0] ahb_size_word_e        = 3'h2;
  localparam         [2:0] ahb_size_doubleword_e  = 3'h3;
  localparam         [2:0] ahb_size_default_p     = 3'h0; // AHB Size
  // ahb_burst
  localparam integer       ahb_burst_width_p      = 3;
  localparam         [2:0] ahb_burst_min_p        = 3'h0; // AHB Burst Type
  localparam         [2:0] ahb_burst_max_p        = 3'h7; // AHB Burst Type
  localparam         [2:0] ahb_burst_single_e     = 3'h0;
  localparam         [2:0] ahb_burst_incr_e       = 3'h1;
  localparam         [2:0] ahb_burst_wrap4_e      = 3'h2;
  localparam         [2:0] ahb_burst_incr4_e      = 3'h3;
  localparam         [2:0] ahb_burst_wrap8_e      = 3'h4;
  localparam         [2:0] ahb_burst_incr8_e      = 3'h5;
  localparam         [2:0] ahb_burst_wrap16_e     = 3'h6;
  localparam         [2:0] ahb_burst_incr16_e     = 3'h7;
  localparam         [2:0] ahb_burst_default_p    = 3'h0; // AHB Burst Type
  // ahb_write
  localparam integer       ahb_write_width_p      = 1;
  localparam               ahb_write_min_p        = 1'b0; // AHB Write Enable
  localparam               ahb_write_max_p        = 1'b1; // AHB Write Enable
  localparam               ahb_write_read_e       = 1'b0;
  localparam               ahb_write_write_e      = 1'b1;
  localparam               ahb_write_default_p    = 1'b0; // AHB Write Enable
  // fsm
  localparam integer       fsm_width_p            = 3;
  localparam         [2:0] fsm_min_p              = 3'h0; // AHB ML FSM Type
  localparam         [2:0] fsm_max_p              = 3'h7; // AHB ML FSM Type
  localparam         [2:0] fsm_idle_st            = 3'h0;
  localparam         [2:0] fsm_transfer_st        = 3'h1;
  localparam         [2:0] fsm_transfer_finish_st = 3'h2;
  localparam         [2:0] fsm_transfer_wait_st   = 3'h3;
  localparam         [2:0] fsm_error0_st          = 3'h4;
  localparam         [2:0] fsm_error1_st          = 3'h5;
  localparam         [2:0] fsm_error2_st          = 3'h6;
  localparam         [2:0] fsm_default_p          = 3'h0; // AHB ML FSM Type


  // ------------------------------------------------------
  //  Signals
  // ------------------------------------------------------
  logic [2:0]  fsm_ext_r;            // Master 'ext' FSM
  logic        mst_ext_new_xfer_s;
  logic        mst_ext_cont_xfer_s;
  logic        mst_ext_hready_s;
  logic        mst_ext_rqstate_s;
  logic        mst_ext_addr_err_s;
  logic        mst_ext_ram_sel_s;
  logic        mst_ext_ram_req_r;
  logic        mst_ext_ram_gnt_r;
  logic        mst_ext_misc_sel_s;
  logic        mst_ext_misc_req_r;
  logic        mst_ext_misc_gnt_r;
  logic        mst_ext_gnt_s;
  logic [1:0]  mst_ext_htrans_s;     // AHB Transfer Type
  logic [1:0]  mst_ext_htrans_r;     // AHB Transfer Type
  logic [31:0] mst_ext_haddr_s;      // AHB Bus Address
  logic [31:0] mst_ext_haddr_r;      // AHB Bus Address
  logic        mst_ext_hwrite_s;     // AHB Write Enable
  logic        mst_ext_hwrite_r;     // AHB Write Enable
  logic [2:0]  mst_ext_hsize_s;      // AHB Size
  logic [2:0]  mst_ext_hsize_r;      // AHB Size
  logic [2:0]  mst_ext_hburst_s;     // AHB Burst Type
  logic [2:0]  mst_ext_hburst_r;     // AHB Burst Type
  logic [3:0]  mst_ext_hprot_s;      // AHB Transfer Protection
  logic [3:0]  mst_ext_hprot_r;      // AHB Transfer Protection
  logic [2:0]  fsm_dsp_r;            // Master 'dsp' FSM
  logic        mst_dsp_new_xfer_s;
  logic        mst_dsp_cont_xfer_s;
  logic        mst_dsp_hready_s;
  logic        mst_dsp_rqstate_s;
  logic        mst_dsp_addr_err_s;
  logic        mst_dsp_ram_sel_s;
  logic        mst_dsp_ram_req_r;
  logic        mst_dsp_ram_gnt_r;
  logic        mst_dsp_periph_sel_s;
  logic        mst_dsp_periph_req_r;
  logic        mst_dsp_periph_gnt_r;
  logic        mst_dsp_gnt_s;
  logic [1:0]  mst_dsp_htrans_s;     // AHB Transfer Type
  logic [1:0]  mst_dsp_htrans_r;     // AHB Transfer Type
  logic [31:0] mst_dsp_haddr_s;      // AHB Bus Address
  logic [31:0] mst_dsp_haddr_r;      // AHB Bus Address
  logic        mst_dsp_hwrite_s;     // AHB Write Enable
  logic        mst_dsp_hwrite_r;     // AHB Write Enable
  logic [2:0]  mst_dsp_hsize_s;      // AHB Size
  logic [2:0]  mst_dsp_hsize_r;      // AHB Size
  logic [2:0]  mst_dsp_hburst_s;     // AHB Burst Type
  logic [2:0]  mst_dsp_hburst_r;     // AHB Burst Type
  logic [3:0]  mst_dsp_hprot_s;      // AHB Transfer Protection
  logic [3:0]  mst_dsp_hprot_r;      // AHB Transfer Protection
  logic        mst_ext_ram_req_s;
  logic        mst_ext_ram_keep_s;
  logic        slv_ram_ext_gnt_r;
  logic        slv_ram_ext_gnt_s;
  logic        slv_ram_ext_sel_s;
  logic        mst_dsp_ram_req_s;
  logic        mst_dsp_ram_keep_s;
  logic        slv_ram_dsp_gnt_r;
  logic        slv_ram_dsp_gnt_s;
  logic        slv_ram_dsp_sel_s;
  logic        mst_dsp_periph_req_s;
  logic        slv_periph_dsp_gnt_s;
  logic        slv_periph_dsp_sel_s;
  logic        mst_ext_misc_req_s;
  logic        slv_misc_ext_gnt_s;
  logic        slv_misc_ext_sel_s;



  // ------------------------------------------------------
  // The Masters:
  // ------------------------------------------------------
  // Master 'ext' Logic
  always_comb begin: proc_ext_logic
    mst_ext_new_xfer_s  = (ahb_mst_ext_htrans_i == ahb_trans_nonseq_e) ? 1'b1 : 1'b0;
    mst_ext_cont_xfer_s = ((ahb_mst_ext_htrans_i == ahb_trans_busy_e) ||
                           (ahb_mst_ext_htrans_i == ahb_trans_seq_e)) ? 1'b1 : 1'b0;
    mst_ext_rqstate_s   = ((fsm_ext_r == fsm_idle_st) ||
                           (fsm_ext_r == fsm_transfer_st) ||
                           (fsm_ext_r == fsm_transfer_finish_st) ||
                           (fsm_ext_r == fsm_error2_st)) ? 1'b1 : 1'b0;

    // Address Decoding
    mst_ext_addr_err_s = 1'b0;
    mst_ext_ram_sel_s = 1'b0;
    mst_ext_misc_sel_s = 1'b0;

    casez (ahb_mst_ext_haddr_i[31:10])
      22'b1111000000000000??????: begin // ram
        mst_ext_ram_sel_s = 1'b1;
      end

      22'b100000000000000000????, 22'b10000000000000000100??, 22'b100000000000000001010?, 22'b1000000000000000010110, 22'b11110000000000100?????: begin // misc
        mst_ext_misc_sel_s = 1'b1;
      end

      default: begin
        mst_ext_addr_err_s = mst_ext_new_xfer_s;
      end
    endcase

    mst_ext_ram_req_s  = (mst_ext_ram_sel_s & mst_ext_new_xfer_s & mst_ext_rqstate_s) | mst_ext_ram_req_r;
    mst_ext_ram_keep_s = mst_ext_ram_sel_s & mst_ext_cont_xfer_s;
    mst_ext_misc_req_s = (mst_ext_misc_sel_s & mst_ext_new_xfer_s & mst_ext_rqstate_s) | mst_ext_misc_req_r;

    // Grant Combination
    mst_ext_gnt_s = slv_ram_ext_gnt_s |
                    slv_misc_ext_gnt_s;
  end

  // FSM for Master 'ext'
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin: proc_ext_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_ext_r <= fsm_idle_st;
      mst_ext_ram_gnt_r <= 1'b0;
      mst_ext_misc_gnt_r <= 1'b0;
    end else begin
      case (fsm_ext_r)
        fsm_idle_st: begin
          if (mst_ext_new_xfer_s == 1'b1) begin
            if (mst_ext_addr_err_s == 1'b1) begin
              fsm_ext_r <= fsm_error1_st;
            end else if (mst_ext_gnt_s == 1'b1) begin
              mst_ext_ram_req_r <= 1'b0;
              mst_ext_misc_req_r <= 1'b0;
              fsm_ext_r <= fsm_transfer_st;
            end else begin
              mst_ext_ram_req_r <= mst_ext_ram_sel_s;
              mst_ext_misc_req_r <= mst_ext_misc_sel_s;
              fsm_ext_r <= fsm_transfer_wait_st;
            end
            mst_ext_ram_gnt_r <= slv_ram_ext_gnt_s;
            mst_ext_misc_gnt_r <= slv_misc_ext_gnt_s;
          end
        end

        fsm_error0_st: begin
          if (mst_ext_hready_s == 1'b1) begin
            fsm_ext_r <= fsm_error1_st;
          end
        end

        fsm_error1_st: begin
          fsm_ext_r <= fsm_error2_st;
        end

        fsm_error2_st: begin
          if (mst_ext_new_xfer_s == 1'b1) begin
            if (mst_ext_addr_err_s == 1'b1) begin
              fsm_ext_r <= fsm_error1_st;
            end else if (mst_ext_gnt_s == 1'b1) begin
              mst_ext_ram_req_r <= 1'b0;
              mst_ext_misc_req_r <= 1'b0;
              fsm_ext_r <= fsm_transfer_st;
            end else begin
              mst_ext_ram_req_r <= mst_ext_ram_sel_s;
              mst_ext_misc_req_r <= mst_ext_misc_sel_s;
              fsm_ext_r <= fsm_transfer_wait_st;
            end
            mst_ext_ram_gnt_r <= slv_ram_ext_gnt_s;
            mst_ext_misc_gnt_r <= slv_misc_ext_gnt_s;
          end else begin
            fsm_ext_r <= fsm_idle_st;
          end
        end

        fsm_transfer_st: begin
          if ((ahb_mst_ext_htrans_i == ahb_trans_seq_e) ||
              (ahb_mst_ext_htrans_i == ahb_trans_busy_e)) begin
            fsm_ext_r <= fsm_transfer_st;
          end else begin
            if (ahb_mst_ext_htrans_i == ahb_trans_idle_e) begin
              if (mst_ext_hready_s == 1'b0) begin
                fsm_ext_r <= fsm_transfer_finish_st;
              end else begin
                mst_ext_ram_gnt_r <= 1'b0;
                mst_ext_misc_gnt_r <= 1'b0;
                fsm_ext_r <= fsm_idle_st;
              end
            end else begin // ((ahb_mst_ext_htrans_i == ahb_trans_nonseq_e)
              if (mst_ext_addr_err_s == 1'b1) begin
                if (mst_ext_hready_s == 1'b0) begin
                  fsm_ext_r <= fsm_error0_st;
                end else begin
                  fsm_ext_r <= fsm_error1_st;
                end
              end else if (mst_ext_gnt_s == 1'b1) begin
                mst_ext_ram_req_r <= 1'b0;
                mst_ext_misc_req_r <= 1'b0;
                fsm_ext_r <= fsm_transfer_st;
              end else begin
                mst_ext_ram_req_r <= mst_ext_ram_sel_s;
                mst_ext_misc_req_r <= mst_ext_misc_sel_s;
                fsm_ext_r <= fsm_transfer_wait_st;
              end
              mst_ext_ram_gnt_r <= slv_ram_ext_gnt_s;
              mst_ext_misc_gnt_r <= slv_misc_ext_gnt_s;
            end
          end
        end

        fsm_transfer_wait_st: begin
          if (mst_ext_gnt_s == 1'b1) begin
            mst_ext_ram_req_r <= 1'b0;
            mst_ext_misc_req_r <= 1'b0;
            mst_ext_ram_gnt_r <= slv_ram_ext_gnt_s;
            mst_ext_misc_gnt_r <= slv_misc_ext_gnt_s;
            fsm_ext_r <= fsm_transfer_st;
          end
        end

        fsm_transfer_finish_st: begin
          if (mst_ext_hready_s == 1'b1) begin
            if (mst_ext_new_xfer_s == 1'b1) begin
              if (mst_ext_addr_err_s == 1'b1) begin
                fsm_ext_r <= fsm_error1_st;
              end else if (mst_ext_gnt_s == 1'b1) begin
                mst_ext_ram_req_r <= 1'b0;
                mst_ext_misc_req_r <= 1'b0;
                fsm_ext_r <= fsm_transfer_st;
              end else begin
                mst_ext_ram_req_r <= mst_ext_ram_sel_s;
                mst_ext_misc_req_r <= mst_ext_misc_sel_s;
                fsm_ext_r <= fsm_transfer_wait_st;
              end
              mst_ext_ram_gnt_r <= slv_ram_ext_gnt_s;
              mst_ext_misc_gnt_r <= slv_misc_ext_gnt_s;
            end else begin
              mst_ext_ram_gnt_r <= 1'b0;
              mst_ext_misc_gnt_r <= 1'b0;
              fsm_ext_r <= fsm_idle_st;
            end
          end
        end

        default: begin
          mst_ext_ram_gnt_r <= 1'b0;
          mst_ext_ram_req_r <= 1'b0;
          mst_ext_misc_gnt_r <= 1'b0;
          mst_ext_misc_req_r <= 1'b0;
          fsm_ext_r <= fsm_idle_st;
        end
      endcase
    end

    if ((mst_ext_new_xfer_s == 1'b1) && (mst_ext_gnt_s == 1'b0) && (mst_ext_rqstate_s == 1'b1)) begin
      mst_ext_haddr_r  <= ahb_mst_ext_haddr_i;
      mst_ext_htrans_r <= ahb_mst_ext_htrans_i;
      mst_ext_hburst_r <= ahb_mst_ext_hburst_i;
      mst_ext_hsize_r  <= ahb_mst_ext_hsize_i;
      mst_ext_hwrite_r <= ahb_mst_ext_hwrite_i;
      mst_ext_hprot_r  <= ahb_mst_ext_hprot_i;
    end
  end

  // Master 'ext' Mux
  always_comb begin: proc_ext_mux
    if (fsm_ext_r == fsm_transfer_wait_st) begin
      mst_ext_haddr_s  = mst_ext_haddr_r;
      mst_ext_hwrite_s = mst_ext_hwrite_r;
      mst_ext_hburst_s = mst_ext_hburst_r;
      mst_ext_hsize_s  = mst_ext_hsize_r;
      mst_ext_htrans_s = mst_ext_htrans_r;
      mst_ext_hprot_s  = mst_ext_hprot_r;
    end else begin
      mst_ext_haddr_s  = ahb_mst_ext_haddr_i;
      mst_ext_hwrite_s = ahb_mst_ext_hwrite_i;
      mst_ext_hburst_s = ahb_mst_ext_hburst_i;
      mst_ext_hsize_s  = ahb_mst_ext_hsize_i;
      mst_ext_htrans_s = ahb_mst_ext_htrans_i;
      mst_ext_hprot_s  = ahb_mst_ext_hprot_i;
    end

    mst_ext_hready_s = (ahb_slv_ram_hreadyout_i & mst_ext_ram_gnt_r) |
                       (ahb_slv_misc_hreadyout_i & mst_ext_misc_gnt_r) |
                       ~(|{mst_ext_ram_gnt_r, mst_ext_misc_gnt_r});

    case (fsm_ext_r)
      fsm_transfer_wait_st: begin
        ahb_mst_ext_hrdata_o = 32'h00000000;
        ahb_mst_ext_hready_o = 1'b0;
        ahb_mst_ext_hresp_o  = ahb_resp_okay_e;
      end

      fsm_error1_st: begin
        ahb_mst_ext_hrdata_o = 32'h00000000;
        ahb_mst_ext_hready_o = 1'b0;
        ahb_mst_ext_hresp_o  = ahb_resp_error_e;
      end

      fsm_error2_st: begin
        ahb_mst_ext_hrdata_o = 32'h00000000;
        ahb_mst_ext_hready_o = 1'b1;
        ahb_mst_ext_hresp_o  = ahb_resp_error_e;
      end

      fsm_error0_st, fsm_transfer_st: begin
        case ({mst_ext_ram_gnt_r, mst_ext_misc_gnt_r})
          2'b01: begin
            ahb_mst_ext_hrdata_o = ahb_slv_misc_hrdata_i;
            ahb_mst_ext_hready_o = ahb_slv_misc_hreadyout_i;
            ahb_mst_ext_hresp_o = ahb_slv_misc_hresp_i;
          end

          2'b10: begin
            ahb_mst_ext_hrdata_o = ahb_slv_ram_hrdata_i;
            ahb_mst_ext_hready_o = ahb_slv_ram_hreadyout_i;
            ahb_mst_ext_hresp_o = ahb_slv_ram_hresp_i;
          end

          default: begin
            ahb_mst_ext_hrdata_o = 32'h00000000;
            ahb_mst_ext_hready_o = 1'b1;
            ahb_mst_ext_hresp_o  = ahb_resp_okay_e;
          end
        endcase
      end

      fsm_transfer_finish_st: begin
        case ({mst_ext_ram_gnt_r, mst_ext_misc_gnt_r})
          2'b01: begin
            ahb_mst_ext_hrdata_o = ahb_slv_misc_hrdata_i;
            ahb_mst_ext_hready_o = ahb_slv_misc_hreadyout_i;
            ahb_mst_ext_hresp_o = ahb_slv_misc_hresp_i;
          end

          2'b10: begin
            ahb_mst_ext_hrdata_o = ahb_slv_ram_hrdata_i;
            ahb_mst_ext_hready_o = ahb_slv_ram_hreadyout_i;
            ahb_mst_ext_hresp_o = ahb_slv_ram_hresp_i;
          end

          default: begin
            ahb_mst_ext_hrdata_o = 32'h00000000;
            ahb_mst_ext_hready_o = 1'b1;
            ahb_mst_ext_hresp_o  = ahb_resp_okay_e;
          end
        endcase
      end

      default: begin
        ahb_mst_ext_hrdata_o = 32'h00000000;
        ahb_mst_ext_hready_o = 1'b1;
        ahb_mst_ext_hresp_o  = ahb_resp_okay_e;
      end
    endcase
  end

  // Master 'dsp' Logic
  always_comb begin: proc_dsp_logic
    mst_dsp_new_xfer_s  = (ahb_mst_dsp_htrans_i == ahb_trans_nonseq_e) ? 1'b1 : 1'b0;
    mst_dsp_cont_xfer_s = ((ahb_mst_dsp_htrans_i == ahb_trans_busy_e) ||
                           (ahb_mst_dsp_htrans_i == ahb_trans_seq_e)) ? 1'b1 : 1'b0;
    mst_dsp_rqstate_s   = ((fsm_dsp_r == fsm_idle_st) ||
                           (fsm_dsp_r == fsm_transfer_st) ||
                           (fsm_dsp_r == fsm_transfer_finish_st) ||
                           (fsm_dsp_r == fsm_error2_st)) ? 1'b1 : 1'b0;

    // Address Decoding
    mst_dsp_addr_err_s = 1'b0;
    mst_dsp_ram_sel_s = 1'b0;
    mst_dsp_periph_sel_s = 1'b0;

    casez (ahb_mst_dsp_haddr_i[31:16])
      16'b1111000000000000: begin // ram
        mst_dsp_ram_sel_s = 1'b1;
      end

      16'b1111000000000001: begin // periph
        mst_dsp_periph_sel_s = 1'b1;
      end

      default: begin
        mst_dsp_addr_err_s = mst_dsp_new_xfer_s;
      end
    endcase

    mst_dsp_ram_req_s    = (mst_dsp_ram_sel_s & mst_dsp_new_xfer_s & mst_dsp_rqstate_s) | mst_dsp_ram_req_r;
    mst_dsp_ram_keep_s   = mst_dsp_ram_sel_s & mst_dsp_cont_xfer_s;
    mst_dsp_periph_req_s = (mst_dsp_periph_sel_s & mst_dsp_new_xfer_s & mst_dsp_rqstate_s) | mst_dsp_periph_req_r;

    // Grant Combination
    mst_dsp_gnt_s = slv_ram_dsp_gnt_s |
                    slv_periph_dsp_gnt_s;
  end

  // FSM for Master 'dsp'
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin: proc_dsp_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_dsp_r <= fsm_idle_st;
      mst_dsp_ram_gnt_r <= 1'b0;
      mst_dsp_periph_gnt_r <= 1'b0;
    end else begin
      case (fsm_dsp_r)
        fsm_idle_st: begin
          if (mst_dsp_new_xfer_s == 1'b1) begin
            if (mst_dsp_addr_err_s == 1'b1) begin
              fsm_dsp_r <= fsm_error1_st;
            end else if (mst_dsp_gnt_s == 1'b1) begin
              mst_dsp_ram_req_r <= 1'b0;
              mst_dsp_periph_req_r <= 1'b0;
              fsm_dsp_r <= fsm_transfer_st;
            end else begin
              mst_dsp_ram_req_r <= mst_dsp_ram_sel_s;
              mst_dsp_periph_req_r <= mst_dsp_periph_sel_s;
              fsm_dsp_r <= fsm_transfer_wait_st;
            end
            mst_dsp_ram_gnt_r <= slv_ram_dsp_gnt_s;
            mst_dsp_periph_gnt_r <= slv_periph_dsp_gnt_s;
          end
        end

        fsm_error0_st: begin
          if (mst_dsp_hready_s == 1'b1) begin
            fsm_dsp_r <= fsm_error1_st;
          end
        end

        fsm_error1_st: begin
          fsm_dsp_r <= fsm_error2_st;
        end

        fsm_error2_st: begin
          if (mst_dsp_new_xfer_s == 1'b1) begin
            if (mst_dsp_addr_err_s == 1'b1) begin
              fsm_dsp_r <= fsm_error1_st;
            end else if (mst_dsp_gnt_s == 1'b1) begin
              mst_dsp_ram_req_r <= 1'b0;
              mst_dsp_periph_req_r <= 1'b0;
              fsm_dsp_r <= fsm_transfer_st;
            end else begin
              mst_dsp_ram_req_r <= mst_dsp_ram_sel_s;
              mst_dsp_periph_req_r <= mst_dsp_periph_sel_s;
              fsm_dsp_r <= fsm_transfer_wait_st;
            end
            mst_dsp_ram_gnt_r <= slv_ram_dsp_gnt_s;
            mst_dsp_periph_gnt_r <= slv_periph_dsp_gnt_s;
          end else begin
            fsm_dsp_r <= fsm_idle_st;
          end
        end

        fsm_transfer_st: begin
          if ((ahb_mst_dsp_htrans_i == ahb_trans_seq_e) ||
              (ahb_mst_dsp_htrans_i == ahb_trans_busy_e)) begin
            fsm_dsp_r <= fsm_transfer_st;
          end else begin
            if (ahb_mst_dsp_htrans_i == ahb_trans_idle_e) begin
              if (mst_dsp_hready_s == 1'b0) begin
                fsm_dsp_r <= fsm_transfer_finish_st;
              end else begin
                mst_dsp_ram_gnt_r <= 1'b0;
                mst_dsp_periph_gnt_r <= 1'b0;
                fsm_dsp_r <= fsm_idle_st;
              end
            end else begin // ((ahb_mst_dsp_htrans_i == ahb_trans_nonseq_e)
              if (mst_dsp_addr_err_s == 1'b1) begin
                if (mst_dsp_hready_s == 1'b0) begin
                  fsm_dsp_r <= fsm_error0_st;
                end else begin
                  fsm_dsp_r <= fsm_error1_st;
                end
              end else if (mst_dsp_gnt_s == 1'b1) begin
                mst_dsp_ram_req_r <= 1'b0;
                mst_dsp_periph_req_r <= 1'b0;
                fsm_dsp_r <= fsm_transfer_st;
              end else begin
                mst_dsp_ram_req_r <= mst_dsp_ram_sel_s;
                mst_dsp_periph_req_r <= mst_dsp_periph_sel_s;
                fsm_dsp_r <= fsm_transfer_wait_st;
              end
              mst_dsp_ram_gnt_r <= slv_ram_dsp_gnt_s;
              mst_dsp_periph_gnt_r <= slv_periph_dsp_gnt_s;
            end
          end
        end

        fsm_transfer_wait_st: begin
          if (mst_dsp_gnt_s == 1'b1) begin
            mst_dsp_ram_req_r <= 1'b0;
            mst_dsp_periph_req_r <= 1'b0;
            mst_dsp_ram_gnt_r <= slv_ram_dsp_gnt_s;
            mst_dsp_periph_gnt_r <= slv_periph_dsp_gnt_s;
            fsm_dsp_r <= fsm_transfer_st;
          end
        end

        fsm_transfer_finish_st: begin
          if (mst_dsp_hready_s == 1'b1) begin
            if (mst_dsp_new_xfer_s == 1'b1) begin
              if (mst_dsp_addr_err_s == 1'b1) begin
                fsm_dsp_r <= fsm_error1_st;
              end else if (mst_dsp_gnt_s == 1'b1) begin
                mst_dsp_ram_req_r <= 1'b0;
                mst_dsp_periph_req_r <= 1'b0;
                fsm_dsp_r <= fsm_transfer_st;
              end else begin
                mst_dsp_ram_req_r <= mst_dsp_ram_sel_s;
                mst_dsp_periph_req_r <= mst_dsp_periph_sel_s;
                fsm_dsp_r <= fsm_transfer_wait_st;
              end
              mst_dsp_ram_gnt_r <= slv_ram_dsp_gnt_s;
              mst_dsp_periph_gnt_r <= slv_periph_dsp_gnt_s;
            end else begin
              mst_dsp_ram_gnt_r <= 1'b0;
              mst_dsp_periph_gnt_r <= 1'b0;
              fsm_dsp_r <= fsm_idle_st;
            end
          end
        end

        default: begin
          mst_dsp_ram_gnt_r <= 1'b0;
          mst_dsp_ram_req_r <= 1'b0;
          mst_dsp_periph_gnt_r <= 1'b0;
          mst_dsp_periph_req_r <= 1'b0;
          fsm_dsp_r <= fsm_idle_st;
        end
      endcase
    end

    if ((mst_dsp_new_xfer_s == 1'b1) && (mst_dsp_gnt_s == 1'b0) && (mst_dsp_rqstate_s == 1'b1)) begin
      mst_dsp_haddr_r  <= ahb_mst_dsp_haddr_i;
      mst_dsp_htrans_r <= ahb_mst_dsp_htrans_i;
      mst_dsp_hburst_r <= ahb_mst_dsp_hburst_i;
      mst_dsp_hsize_r  <= ahb_mst_dsp_hsize_i;
      mst_dsp_hwrite_r <= ahb_mst_dsp_hwrite_i;
      mst_dsp_hprot_r  <= ahb_mst_dsp_hprot_i;
    end
  end

  // Master 'dsp' Mux
  always_comb begin: proc_dsp_mux
    if (fsm_dsp_r == fsm_transfer_wait_st) begin
      mst_dsp_haddr_s  = mst_dsp_haddr_r;
      mst_dsp_hwrite_s = mst_dsp_hwrite_r;
      mst_dsp_hburst_s = mst_dsp_hburst_r;
      mst_dsp_hsize_s  = mst_dsp_hsize_r;
      mst_dsp_htrans_s = mst_dsp_htrans_r;
      mst_dsp_hprot_s  = mst_dsp_hprot_r;
    end else begin
      mst_dsp_haddr_s  = ahb_mst_dsp_haddr_i;
      mst_dsp_hwrite_s = ahb_mst_dsp_hwrite_i;
      mst_dsp_hburst_s = ahb_mst_dsp_hburst_i;
      mst_dsp_hsize_s  = ahb_mst_dsp_hsize_i;
      mst_dsp_htrans_s = ahb_mst_dsp_htrans_i;
      mst_dsp_hprot_s  = ahb_mst_dsp_hprot_i;
    end

    mst_dsp_hready_s = (ahb_slv_ram_hreadyout_i & mst_dsp_ram_gnt_r) |
                       (ahb_slv_periph_hreadyout_i & mst_dsp_periph_gnt_r) |
                       ~(|{mst_dsp_ram_gnt_r, mst_dsp_periph_gnt_r});

    case (fsm_dsp_r)
      fsm_transfer_wait_st: begin
        ahb_mst_dsp_hrdata_o = 32'h00000000;
        ahb_mst_dsp_hready_o = 1'b0;
        ahb_mst_dsp_hresp_o  = ahb_resp_okay_e;
      end

      fsm_error1_st: begin
        ahb_mst_dsp_hrdata_o = 32'h00000000;
        ahb_mst_dsp_hready_o = 1'b0;
        ahb_mst_dsp_hresp_o  = ahb_resp_error_e;
      end

      fsm_error2_st: begin
        ahb_mst_dsp_hrdata_o = 32'h00000000;
        ahb_mst_dsp_hready_o = 1'b1;
        ahb_mst_dsp_hresp_o  = ahb_resp_error_e;
      end

      fsm_error0_st, fsm_transfer_st: begin
        case ({mst_dsp_ram_gnt_r, mst_dsp_periph_gnt_r})
          2'b01: begin
            ahb_mst_dsp_hrdata_o = ahb_slv_periph_hrdata_i;
            ahb_mst_dsp_hready_o = ahb_slv_periph_hreadyout_i;
            ahb_mst_dsp_hresp_o = ahb_slv_periph_hresp_i;
          end

          2'b10: begin
            ahb_mst_dsp_hrdata_o = ahb_slv_ram_hrdata_i;
            ahb_mst_dsp_hready_o = ahb_slv_ram_hreadyout_i;
            ahb_mst_dsp_hresp_o = ahb_slv_ram_hresp_i;
          end

          default: begin
            ahb_mst_dsp_hrdata_o = 32'h00000000;
            ahb_mst_dsp_hready_o = 1'b1;
            ahb_mst_dsp_hresp_o  = ahb_resp_okay_e;
          end
        endcase
      end

      fsm_transfer_finish_st: begin
        case ({mst_dsp_ram_gnt_r, mst_dsp_periph_gnt_r})
          2'b01: begin
            ahb_mst_dsp_hrdata_o = ahb_slv_periph_hrdata_i;
            ahb_mst_dsp_hready_o = ahb_slv_periph_hreadyout_i;
            ahb_mst_dsp_hresp_o = ahb_slv_periph_hresp_i;
          end

          2'b10: begin
            ahb_mst_dsp_hrdata_o = ahb_slv_ram_hrdata_i;
            ahb_mst_dsp_hready_o = ahb_slv_ram_hreadyout_i;
            ahb_mst_dsp_hresp_o = ahb_slv_ram_hresp_i;
          end

          default: begin
            ahb_mst_dsp_hrdata_o = 32'h00000000;
            ahb_mst_dsp_hready_o = 1'b1;
            ahb_mst_dsp_hresp_o  = ahb_resp_okay_e;
          end
        endcase
      end

      default: begin
        ahb_mst_dsp_hrdata_o = 32'h00000000;
        ahb_mst_dsp_hready_o = 1'b1;
        ahb_mst_dsp_hresp_o  = ahb_resp_okay_e;
      end
    endcase
  end



  // ------------------------------------------------------
  // The Slaves:
  // ------------------------------------------------------
  // // Slave 'ram' round-robin arbiter
  always_comb begin: proc_ram_rr_arb
    integer i;
    logic found_s;
    logic [1:0] slv_req_s;
    logic [1:0] prev_grant_s;
    logic [1:0] next_grant_s;
    logic arb_en_s;

    slv_req_s = {mst_ext_ram_req_s, mst_dsp_ram_req_s};
    prev_grant_s = {slv_ram_ext_gnt_r, slv_ram_dsp_gnt_r};
    arb_en_s = ~(mst_ext_ram_keep_s | mst_dsp_ram_keep_s);

    next_grant_s = {prev_grant_s[0:0], prev_grant_s[1]}; // 1st candidate is old grant rotated 1 left
    found_s = 1'b0;
    for (i=0; i<2; i=i+1) begin
      if (found_s == 1'b0) begin
        if ((slv_req_s & next_grant_s) != 2'd0) begin
          found_s = 1'b1;
        end else begin
          next_grant_s = {next_grant_s[0:0], next_grant_s[1]}; // rotate 1 left
        end
      end
    end

    {slv_ram_ext_gnt_s, slv_ram_dsp_gnt_s} = slv_req_s & next_grant_s & {2{(ahb_slv_ram_hreadyout_i & arb_en_s)}};
  end


  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin: proc_ram_gnt
    if (main_rst_an_i == 1'b0) begin
      slv_ram_ext_gnt_r <= 1'b1;  // initial pseudo-grant
      slv_ram_dsp_gnt_r <= 1'b0;
    end else begin
      if ({slv_ram_ext_gnt_s, slv_ram_dsp_gnt_s} != 2'd0) begin
        slv_ram_ext_gnt_r <= slv_ram_ext_gnt_s;
        slv_ram_dsp_gnt_r <= slv_ram_dsp_gnt_s;
      end
    end
  end


  // Slave 'ram' multiplexer
  always_comb begin: proc_ram_mux
      slv_ram_ext_sel_s = slv_ram_ext_gnt_s |
                          (mst_ext_ram_keep_s & mst_ext_ram_gnt_r);
      slv_ram_dsp_sel_s = slv_ram_dsp_gnt_s |
                          (mst_dsp_ram_keep_s & mst_dsp_ram_gnt_r);

    ahb_slv_ram_hsel_o = |{slv_ram_ext_sel_s, slv_ram_dsp_sel_s};

    case ({slv_ram_ext_sel_s, slv_ram_dsp_sel_s})  // address phase signals
      2'b01: begin
        ahb_slv_ram_haddr_o  = mst_dsp_haddr_s;
        ahb_slv_ram_hwrite_o = mst_dsp_hwrite_s;
        ahb_slv_ram_hburst_o = mst_dsp_hburst_s;
        ahb_slv_ram_hsize_o  = mst_dsp_hsize_s;
        ahb_slv_ram_htrans_o = mst_dsp_htrans_s;
        ahb_slv_ram_hprot_o  = mst_dsp_hprot_s;
        ahb_slv_ram_hready_o = mst_dsp_hready_s;
      end

      2'b10: begin
        ahb_slv_ram_haddr_o  = mst_ext_haddr_s;
        ahb_slv_ram_hwrite_o = mst_ext_hwrite_s;
        ahb_slv_ram_hburst_o = mst_ext_hburst_s;
        ahb_slv_ram_hsize_o  = mst_ext_hsize_s;
        ahb_slv_ram_htrans_o = mst_ext_htrans_s;
        ahb_slv_ram_hprot_o  = mst_ext_hprot_s;
        ahb_slv_ram_hready_o = mst_ext_hready_s;
      end

      default: begin
        ahb_slv_ram_haddr_o  = 32'h00000000;
        ahb_slv_ram_hwrite_o = ahb_write_read_e;
        ahb_slv_ram_hburst_o = ahb_burst_single_e;
        ahb_slv_ram_hsize_o  = ahb_size_word_e;
        ahb_slv_ram_htrans_o = ahb_trans_idle_e;
        ahb_slv_ram_hprot_o  = 4'h0;
        ahb_slv_ram_hready_o = ahb_slv_ram_hreadyout_i;
      end
    endcase

    case ({mst_ext_ram_gnt_r, mst_dsp_ram_gnt_r})  // data phase signals
      2'b01: begin
        ahb_slv_ram_hwdata_o = ahb_mst_dsp_hwdata_i;
      end

      2'b10: begin
        ahb_slv_ram_hwdata_o = ahb_mst_ext_hwdata_i;
      end

      default: begin
        ahb_slv_ram_hwdata_o = 32'h00000000;
      end
    endcase
  end

  // Slave 'periph': no arbitration necessary
  always_comb begin: proc_periph_asgn
    slv_periph_dsp_gnt_s = mst_dsp_periph_req_s;

    ahb_slv_periph_hsel_o     = mst_dsp_periph_req_s;  // address phase signals
    if (mst_dsp_periph_sel_s == 1'b1) begin
      ahb_slv_periph_haddr_o  = ahb_mst_dsp_haddr_i;
      ahb_slv_periph_hwrite_o = ahb_mst_dsp_hwrite_i;
      ahb_slv_periph_hburst_o = ahb_mst_dsp_hburst_i;
      ahb_slv_periph_hsize_o  = ahb_mst_dsp_hsize_i;
      ahb_slv_periph_htrans_o = ahb_mst_dsp_htrans_i;
      ahb_slv_periph_hprot_o  = ahb_mst_dsp_hprot_i;
      ahb_slv_periph_hready_o = mst_dsp_hready_s;
    end else begin
      ahb_slv_periph_haddr_o  = 32'h00000000;
      ahb_slv_periph_hwrite_o = ahb_write_read_e;
      ahb_slv_periph_hburst_o = ahb_burst_single_e;
      ahb_slv_periph_hsize_o  = ahb_size_word_e;
      ahb_slv_periph_htrans_o = ahb_trans_idle_e;
      ahb_slv_periph_hprot_o  = 4'h0;
      ahb_slv_periph_hready_o = ahb_slv_periph_hreadyout_i;
    end

    if (mst_dsp_periph_gnt_r == 1'b1) begin  // data phase signals
      ahb_slv_periph_hwdata_o = ahb_mst_dsp_hwdata_i;
    end else begin
      ahb_slv_periph_hwdata_o = 32'h00000000;
    end
  end

  // Slave 'misc': no arbitration necessary
  always_comb begin: proc_misc_asgn
    slv_misc_ext_gnt_s = mst_ext_misc_req_s;

    ahb_slv_misc_hsel_o     = mst_ext_misc_req_s;  // address phase signals
    if (mst_ext_misc_sel_s == 1'b1) begin
      ahb_slv_misc_haddr_o  = ahb_mst_ext_haddr_i;
      ahb_slv_misc_hwrite_o = ahb_mst_ext_hwrite_i;
      ahb_slv_misc_hburst_o = ahb_mst_ext_hburst_i;
      ahb_slv_misc_hsize_o  = ahb_mst_ext_hsize_i;
      ahb_slv_misc_htrans_o = ahb_mst_ext_htrans_i;
      ahb_slv_misc_hprot_o  = ahb_mst_ext_hprot_i;
      ahb_slv_misc_hready_o = mst_ext_hready_s;
    end else begin
      ahb_slv_misc_haddr_o  = 32'h00000000;
      ahb_slv_misc_hwrite_o = ahb_write_read_e;
      ahb_slv_misc_hburst_o = ahb_burst_single_e;
      ahb_slv_misc_hsize_o  = ahb_size_word_e;
      ahb_slv_misc_htrans_o = ahb_trans_idle_e;
      ahb_slv_misc_hprot_o  = 4'h0;
      ahb_slv_misc_hready_o = ahb_slv_misc_hreadyout_i;
    end

    if (mst_ext_misc_gnt_r == 1'b1) begin  // data phase signals
      ahb_slv_misc_hwdata_o = ahb_mst_ext_hwdata_i;
    end else begin
      ahb_slv_misc_hwdata_o = 32'h00000000;
    end
  end


endmodule // ucdp_ahb_ml_example_ml

`default_nettype wire
`end_keywords
