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
// Module:     ucdp_amba.ucdp_ahb2apb_example_ahb2apb_amba3_errirqfalse
// Data Model: ucdp_amba.ucdp_ahb2apb.UcdpAhb2apbMod
//
//
// Size: 12 KB
//
// | Addrspace | Type  | Base    | Size           | Attributes |
// | --------- | ----  | ----    | ----           | ---------- |
// | default   | Slave | +0x0    | 1024x32 (4 KB) | Sub        |
// | slv3      | Slave | +0x1000 | 1024x32 (4 KB) | Sub        |
// | slv5      | Slave | +0x2000 | 1024x32 (4 KB) | Sub        |
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_ahb2apb_example_ahb2apb_amba3_errirqfalse ( // ucdp_amba.ucdp_ahb2apb.UcdpAhb2apbMod
  // main_i
  input  logic        main_clk_i,
  input  logic        main_rst_an_i,             // Async Reset (Low-Active)
  // ahb_slv_i: AHB Slave
  input  logic        ahb_slv_hsel_i,            // AHB Slave Select
  input  logic [31:0] ahb_slv_haddr_i,           // AHB Bus Address
  input  logic        ahb_slv_hwrite_i,          // AHB Write Enable
  input  logic [1:0]  ahb_slv_htrans_i,          // AHB Transfer Type
  input  logic [2:0]  ahb_slv_hsize_i,           // AHB Size
  input  logic [2:0]  ahb_slv_hburst_i,          // AHB Burst Type
  input  logic [3:0]  ahb_slv_hprot_i,           // AHB Transfer Protection
  input  logic [31:0] ahb_slv_hwdata_i,          // AHB Data
  input  logic        ahb_slv_hready_i,          // AHB Transfer Done to Slave
  output logic        ahb_slv_hreadyout_o,       // AHB Transfer Done from Slave
  output logic        ahb_slv_hresp_o,           // AHB Response Error
  output logic [31:0] ahb_slv_hrdata_o,          // AHB Data
  // apb_slv_default_o: APB Slave 'default'
  output logic [11:0] apb_slv_default_paddr_o,   // APB Bus Address
  output logic        apb_slv_default_pwrite_o,  // APB Write Enable
  output logic [31:0] apb_slv_default_pwdata_o,  // APB Data
  output logic        apb_slv_default_penable_o, // APB Transfer Enable
  output logic        apb_slv_default_psel_o,    // APB Slave Select
  input  logic [31:0] apb_slv_default_prdata_i,  // APB Data
  input  logic        apb_slv_default_pslverr_i, // APB Response Error
  input  logic        apb_slv_default_pready_i,  // APB Transfer Done
  // apb_slv_slv3_o: APB Slave 'slv3'
  output logic [11:0] apb_slv_slv3_paddr_o,      // APB Bus Address
  output logic        apb_slv_slv3_pwrite_o,     // APB Write Enable
  output logic [31:0] apb_slv_slv3_pwdata_o,     // APB Data
  output logic        apb_slv_slv3_penable_o,    // APB Transfer Enable
  output logic        apb_slv_slv3_psel_o,       // APB Slave Select
  input  logic [31:0] apb_slv_slv3_prdata_i,     // APB Data
  input  logic        apb_slv_slv3_pslverr_i,    // APB Response Error
  input  logic        apb_slv_slv3_pready_i,     // APB Transfer Done
  // apb_slv_slv5_o: APB Slave 'slv5'
  output logic [11:0] apb_slv_slv5_paddr_o,      // APB Bus Address
  output logic [3:0]  apb_slv_slv5_pauser_o,     // Address User Channel
  output logic        apb_slv_slv5_pwrite_o,     // APB Write Enable
  output logic [31:0] apb_slv_slv5_pwdata_o,     // APB Data
  output logic        apb_slv_slv5_penable_o,    // APB Transfer Enable
  output logic        apb_slv_slv5_psel_o,       // APB Slave Select
  input  logic [31:0] apb_slv_slv5_prdata_i,     // APB Data
  input  logic        apb_slv_slv5_pslverr_i,    // APB Response Error
  input  logic        apb_slv_slv5_pready_i      // APB Transfer Done
);




  // ------------------------------------------------------
  //  Local Parameter
  // ------------------------------------------------------
  // ahb_trans
  localparam integer       ahb_trans_width_p      = 2;
  localparam logic   [1:0] ahb_trans_min_p        = 2'h0; // AHB Transfer Type
  localparam logic   [1:0] ahb_trans_max_p        = 2'h3; // AHB Transfer Type
  localparam logic   [1:0] ahb_trans_idle_e       = 2'h0;
  localparam logic   [1:0] ahb_trans_busy_e       = 2'h1;
  localparam logic   [1:0] ahb_trans_nonseq_e     = 2'h2;
  localparam logic   [1:0] ahb_trans_seq_e        = 2'h3;
  localparam logic   [1:0] ahb_trans_default_p    = 2'h0; // AHB Transfer Type
  // apb_ready
  localparam integer       apb_ready_width_p      = 1;
  localparam logic         apb_ready_min_p        = 1'b0; // APB Transfer Done
  localparam logic         apb_ready_max_p        = 1'b1; // APB Transfer Done
  localparam logic         apb_ready_busy_e       = 1'b0;
  localparam logic         apb_ready_done_e       = 1'b1;
  localparam logic         apb_ready_default_p    = 1'b1; // APB Transfer Done
  // apb_resp
  localparam integer       apb_resp_width_p       = 1;
  localparam logic         apb_resp_min_p         = 1'b0; // APB Response Error
  localparam logic         apb_resp_max_p         = 1'b1; // APB Response Error
  localparam logic         apb_resp_okay_e        = 1'b0;
  localparam logic         apb_resp_error_e       = 1'b1;
  localparam logic         apb_resp_default_p     = 1'b0; // APB Response Error
  // fsm
  localparam integer       fsm_width_p            = 3;
  localparam logic   [2:0] fsm_min_p              = 3'h0; // AHB to APB FSM Type
  localparam logic   [2:0] fsm_max_p              = 3'h7; // AHB to APB FSM Type
  localparam logic   [2:0] fsm_idle_st            = 3'h0;
  localparam logic   [2:0] fsm_apb_ctrl_st        = 3'h1;
  localparam logic   [2:0] fsm_apb_data_st        = 3'h3;
  localparam logic   [2:0] fsm_ahb_finish_st      = 3'h4;
  localparam logic   [2:0] fsm_ahb_err_st         = 3'h5;
  localparam logic   [2:0] fsm_ahb_busy_finish_st = 3'h6;
  localparam logic   [2:0] fsm_ahb_busy_err_st    = 3'h7;
  localparam logic   [2:0] fsm_default_p          = 3'h0; // AHB to APB FSM Type


  // ------------------------------------------------------
  //  Signals
  // ------------------------------------------------------
  logic        ahb_slv_sel_s;
  logic        valid_addr_s;
  logic [2:0]  fsm_r;             // AHB to APB FSM Type
  logic        hready_r;          // AHB Transfer Done
  logic        hresp_r;           // APB Response Error
  logic [11:0] paddr_r;           // APB Bus Address
  logic        pwrite_r;          // APB Write Enable
  logic [31:0] pwdata_s;          // APB Data
  logic [31:0] pwdata_r;          // APB Data
  logic [31:0] prdata_s;          // APB Data
  logic [31:0] prdata_r;          // APB Data
  logic        penable_r;         // APB Transfer Enable
  logic        pready_s;          // APB Transfer Done
  logic        pslverr_s;         // APB Response Error
  logic        apb_default_sel_s; // APB Slave Select
  logic        apb_default_sel_r; // APB Slave Select
  logic        apb_slv3_sel_s;    // APB Slave Select
  logic        apb_slv3_sel_r;    // APB Slave Select
  logic        apb_slv5_sel_s;    // APB Slave Select
  logic        apb_slv5_sel_r;    // APB Slave Select

  // ------------------------------------------------------
  // address decoding
  // ------------------------------------------------------
  always_comb begin: proc_addr_decaccess_proc
    ahb_slv_sel_s = ahb_slv_hsel_i & ahb_slv_hready_i;
    valid_addr_s = 1'b0;
    apb_default_sel_s = 1'b0;
    apb_slv3_sel_s = 1'b0;
    apb_slv5_sel_s = 1'b0;

    casez(ahb_slv_haddr_i[31:12])
      20'b00000000000000000000: begin // default
        valid_addr_s = 1'b1;
        apb_default_sel_s = 1'b1;
      end

      20'b00000000000000000001: begin // slv3
        valid_addr_s = 1'b1;
        apb_slv3_sel_s = 1'b1;
      end

      20'b00000000000000000010: begin // slv5
        valid_addr_s = 1'b1;
        apb_slv5_sel_s = 1'b1;
      end

      default: begin
        valid_addr_s = 1'b0;
      end
    endcase
  end


  // ------------------------------------------------------
  // slave input multiplexing
  // ------------------------------------------------------
  always_comb begin: proc_slave_mux
    pready_s = (apb_slv_default_pready_i & apb_default_sel_r) |
               (apb_slv_slv3_pready_i & apb_slv3_sel_r) |
               (apb_slv_slv5_pready_i & apb_slv5_sel_r);
    pslverr_s = (apb_slv_default_pslverr_i & apb_default_sel_r) |
                (apb_slv_slv3_pslverr_i & apb_slv3_sel_r) |
                (apb_slv_slv5_pslverr_i & apb_slv5_sel_r);
    prdata_s = (apb_slv_default_prdata_i & {32{apb_default_sel_r}}) |
               (apb_slv_slv3_prdata_i & {32{apb_slv3_sel_r}}) |
               (apb_slv_slv5_prdata_i & {32{apb_slv5_sel_r}});
  end

  // ------------------------------------------------------
  // FSM
  // ------------------------------------------------------
  always_ff @ (posedge main_clk_i or negedge main_rst_an_i) begin: proc_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_r <= fsm_idle_st;
      hready_r <= 1'b1;
      hresp_r <= apb_resp_okay_e;
      paddr_r <= 12'h000;
      pwrite_r <= 1'b0;
      pwdata_r <= 32'h00000000;
      penable_r <= 1'b0;
      apb_default_sel_r <= 1'b0;
      apb_slv3_sel_r <= 1'b0;
      apb_slv5_sel_r <= 1'b0;
      prdata_r <= 32'h00000000;
    end else begin
      case (fsm_r)
        fsm_idle_st: begin
          if ((ahb_slv_sel_s == 1'b1) && (ahb_slv_htrans_i != ahb_trans_idle_e)) begin
            hready_r <= 1'b0;
            if (valid_addr_s == 1'b1) begin
              paddr_r <= ahb_slv_haddr_i[11:0];
              pwrite_r <= ahb_slv_hwrite_i;
              apb_default_sel_r <= apb_default_sel_s;
              apb_slv3_sel_r <= apb_slv3_sel_s;
              apb_slv5_sel_r <= apb_slv5_sel_s;
              fsm_r <= fsm_apb_ctrl_st;
            end else begin
              hresp_r <= apb_resp_error_e;
              fsm_r <= fsm_ahb_err_st;
            end
          end
        end

        fsm_apb_ctrl_st: begin
          if (pwrite_r == 1'b1) begin
            pwdata_r <= ahb_slv_hwdata_i;
          end
          penable_r <= 1'b1;
          fsm_r <= fsm_apb_data_st;
        end

        fsm_apb_data_st: begin
          if (pready_s == 1'b1) begin
            penable_r <= 1'b0;
            apb_default_sel_r <= 1'b0;
            apb_slv3_sel_r <= 1'b0;
            apb_slv5_sel_r <= 1'b0;
            prdata_r <= prdata_s;
            if (ahb_slv_htrans_i == ahb_trans_busy_e) begin
              if (pslverr_s == 1'b0) begin
                fsm_r <= fsm_ahb_busy_finish_st;
              end else begin
                fsm_r <= fsm_ahb_busy_err_st;
              end
            end else begin
              if (pslverr_s == 1'b0) begin
                hready_r <= 1'b1;
                fsm_r <= fsm_ahb_finish_st;
              end else begin
                hresp_r <= apb_resp_error_e;
                fsm_r <= fsm_ahb_err_st;
              end
            end
          end
        end

        fsm_ahb_finish_st: begin
          if ((ahb_slv_sel_s == 1'b1) && (ahb_slv_htrans_i != ahb_trans_idle_e)) begin
            hready_r <= 1'b0;
            if (valid_addr_s == 1'b1) begin
              paddr_r <= ahb_slv_haddr_i[11:0];
              fsm_r <= fsm_apb_ctrl_st;
            end else begin
              fsm_r <= fsm_ahb_err_st;
            end
          end else begin
            fsm_r <= fsm_idle_st;
          end
        end

        fsm_ahb_err_st: begin
          hready_r <= 1'b1;
          fsm_r <= fsm_ahb_finish_st;
        end

        fsm_ahb_busy_finish_st: begin
          hresp_r <= apb_resp_okay_e;
          if (ahb_slv_htrans_i == ahb_trans_seq_e) begin
            hready_r <= 1'b1;
            fsm_r <= fsm_ahb_finish_st;
          end
        end

        fsm_ahb_busy_err_st: begin
          if (ahb_slv_htrans_i == ahb_trans_seq_e) begin
            hresp_r <= apb_resp_error_e;
            fsm_r <= fsm_ahb_err_st;
          end
        end

        default: begin
          hready_r <= 1'b1;
          fsm_r <= fsm_idle_st;
        end
      endcase
    end
  end


  // ------------------------------------------------------
  // output Assignments
  // ------------------------------------------------------
  assign ahb_slv_hreadyout_o = hready_r;
  assign ahb_slv_hresp_o = hresp_r;
  assign ahb_slv_hrdata_o = prdata_r;

  assign pwdata_s = (fsm_r == fsm_apb_ctrl_st) ? ahb_slv_hwdata_i : pwdata_r;

  // Slave 'default':
  assign apb_slv_default_paddr_o   = paddr_r[11:0];
  assign apb_slv_default_pwrite_o  = pwrite_r;
  assign apb_slv_default_pwdata_o  = pwdata_s;
  assign apb_slv_default_penable_o = penable_r;
  assign apb_slv_default_psel_o    = apb_default_sel_r;
  // Slave 'slv3':
  assign apb_slv_slv3_paddr_o      = paddr_r[11:0];
  assign apb_slv_slv3_pwrite_o     = pwrite_r;
  assign apb_slv_slv3_pwdata_o     = pwdata_s;
  assign apb_slv_slv3_penable_o    = penable_r;
  assign apb_slv_slv3_psel_o       = apb_slv3_sel_r;
  // Slave 'slv5':
  assign apb_slv_slv5_paddr_o      = paddr_r[11:0];
  assign apb_slv_slv5_pwrite_o     = pwrite_r;
  assign apb_slv_slv5_pwdata_o     = pwdata_s;
  assign apb_slv_slv5_penable_o    = penable_r;
  assign apb_slv_slv5_psel_o       = apb_slv5_sel_r;


endmodule // ucdp_ahb2apb_example_ahb2apb_amba3_errirqfalse

`default_nettype wire
`end_keywords
