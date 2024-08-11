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
// Module:     ucdp_amba.ucdp_ahb2apb_example_odd
// Data Model: ucdp_amba.ucdp_ahb2apb.UcdpAhb2apbMod
//
//
// Size: 29 KB
//
// | Addrspace | Type  | Base    | Size            | Attributes |
// | --------- | ----  | ----    | ----            | ---------- |
// | foo       | Slave | +0x0    | 1024x32 (4 KB)  | Sub        |
// | bar       | Slave | +0x1000 | 256x32 (1 KB)   | Sub        |
// | baz       | Slave | +0x4000 | 3328x32 (13 KB) | Sub        |
//
// =============================================================================

`begin_keywords "1800-2009"
`default_nettype none  // implicit wires are forbidden

module ucdp_ahb2apb_example_odd ( // ucdp_amba.ucdp_ahb2apb.UcdpAhb2apbMod
  // main_i
  input  logic        main_clk_i,
  input  logic        main_rst_an_i,         // Async Reset (Low-Active)
  // ahb_slv_i: AHB Slave
  input  logic        ahb_slv_hsel_i,        // AHB Slave Select
  input  logic [26:0] ahb_slv_haddr_i,       // AHB Bus Address
  input  logic [3:0]  ahb_slv_hauser_i,      // AHB Address User Channel
  input  logic        ahb_slv_hwrite_i,      // AHB Write Enable
  input  logic [1:0]  ahb_slv_htrans_i,      // AHB Transfer Type
  input  logic [2:0]  ahb_slv_hsize_i,       // AHB Size
  input  logic [2:0]  ahb_slv_hburst_i,      // AHB Burst Type
  input  logic [3:0]  ahb_slv_hprot_i,       // AHB Transfer Protection
  input  logic [31:0] ahb_slv_hwdata_i,      // AHB Data
  input  logic        ahb_slv_hready_i,      // AHB Transfer Done to Slave
  output logic        ahb_slv_hreadyout_o,   // AHB Transfer Done from Slave
  output logic        ahb_slv_hresp_o,       // AHB Response Error
  output logic [31:0] ahb_slv_hrdata_o,      // AHB Data
  // apb_slv_foo_o: APB Slave 'foo'
  output logic [11:0] apb_slv_foo_paddr_o,   // APB Bus Address
  output logic [3:0]  apb_slv_foo_pauser_o,  // APB Address User Channel
  output logic        apb_slv_foo_pwrite_o,  // APB Write Enable
  output logic [31:0] apb_slv_foo_pwdata_o,  // APB Data
  output logic        apb_slv_foo_penable_o, // APB Transfer Enable
  output logic        apb_slv_foo_psel_o,    // APB Slave Select
  input  logic [31:0] apb_slv_foo_prdata_i,  // APB Data
  input  logic        apb_slv_foo_pslverr_i, // APB Response Error
  input  logic        apb_slv_foo_pready_i,  // APB Transfer Done
  // apb_slv_bar_o: APB Slave 'bar'
  output logic [9:0]  apb_slv_bar_paddr_o,   // APB Bus Address
  output logic [3:0]  apb_slv_bar_pauser_o,  // APB Address User Channel
  output logic        apb_slv_bar_pwrite_o,  // APB Write Enable
  output logic [31:0] apb_slv_bar_pwdata_o,  // APB Data
  output logic [3:0]  apb_slv_bar_pstrb_o,   // APB Write Strobe
  output logic        apb_slv_bar_penable_o, // APB Transfer Enable
  output logic        apb_slv_bar_psel_o,    // APB Slave Select
  input  logic [31:0] apb_slv_bar_prdata_i,  // APB Data
  input  logic        apb_slv_bar_pslverr_i, // APB Response Error
  input  logic        apb_slv_bar_pready_i,  // APB Transfer Done
  // apb_slv_baz_o: APB Slave 'baz'
  output logic [13:0] apb_slv_baz_paddr_o,   // APB Bus Address
  output logic [3:0]  apb_slv_baz_pauser_o,  // APB Address User Channel
  output logic        apb_slv_baz_pwrite_o,  // APB Write Enable
  output logic [31:0] apb_slv_baz_pwdata_o,  // APB Data
  output logic        apb_slv_baz_penable_o, // APB Transfer Enable
  output logic        apb_slv_baz_psel_o,    // APB Slave Select
  input  logic [31:0] apb_slv_baz_prdata_i,  // APB Data
  input  logic        apb_slv_baz_pslverr_i, // APB Response Error
  input  logic        apb_slv_baz_pready_i   // APB Transfer Done
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
  // ahb_size
  localparam integer       ahb_size_width_p       = 3;
  localparam logic   [2:0] ahb_size_min_p         = 3'h0; // AHB Size
  localparam logic   [2:0] ahb_size_max_p         = 3'h7; // AHB Size
  localparam logic   [2:0] ahb_size_byte_e        = 3'h0;
  localparam logic   [2:0] ahb_size_halfword_e    = 3'h1;
  localparam logic   [2:0] ahb_size_word_e        = 3'h2;
  localparam logic   [2:0] ahb_size_doubleword_e  = 3'h3;
  localparam logic   [2:0] ahb_size_fourword_e    = 3'h4;
  localparam logic   [2:0] ahb_size_eightword_e   = 3'h5;
  localparam logic   [2:0] ahb_size_sixteenword_e = 3'h6;
  localparam logic   [2:0] ahb_size_kilobit_e     = 3'h7;
  localparam logic   [2:0] ahb_size_default_p     = 3'h0; // AHB Size
  // ahb_write
  localparam integer       ahb_write_width_p      = 1;
  localparam logic         ahb_write_min_p        = 1'b0; // AHB Write Enable
  localparam logic         ahb_write_max_p        = 1'b1; // AHB Write Enable
  localparam logic         ahb_write_read_e       = 1'b0;
  localparam logic         ahb_write_write_e      = 1'b1;
  localparam logic         ahb_write_default_p    = 1'b0; // AHB Write Enable
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
  localparam integer       fsm_width_p            = 2;
  localparam logic   [1:0] fsm_min_p              = 2'h0; // AHB to APB FSM Type
  localparam logic   [1:0] fsm_max_p              = 2'h3; // AHB to APB FSM Type
  localparam logic   [1:0] fsm_idle_st            = 2'h0;
  localparam logic   [1:0] fsm_apb_ctrl_st        = 2'h1;
  localparam logic   [1:0] fsm_apb_data_st        = 2'h2;
  localparam logic   [1:0] fsm_ahb_err_st         = 2'h3;
  localparam logic   [1:0] fsm_default_p          = 2'h0; // AHB to APB FSM Type


  // ------------------------------------------------------
  //  Signals
  // ------------------------------------------------------
  logic        new_xfer_s;
  logic        valid_addr_s;
  logic        ahb_slv_sel_s;
  logic [1:0]  fsm_r;         // AHB to APB FSM Type
  logic        hready_r;      // AHB Transfer Done
  logic [3:0]  hauser_r;      // AHB User Type
  logic        hready_s;      // AHB Transfer Done
  logic        hresp_r;       // APB Response Error
  logic [13:0] paddr_r;       // APB Bus Address
  logic        pwrite_r;      // APB Write Enable
  logic [3:0]  size_strb_s;   // APB Write Strobe
  logic [3:0]  pstrb_r;       // APB Write Strobe
  logic [31:0] pwdata_s;      // APB Data
  logic [31:0] pwdata_r;      // APB Data
  logic [31:0] prdata_s;      // APB Data
  logic [31:0] prdata_r;      // APB Data
  logic        penable_r;     // APB Transfer Enable
  logic        pready_s;      // APB Transfer Done
  logic        pslverr_s;     // APB Response Error
  logic        apb_foo_sel_s; // APB Slave Select
  logic        apb_foo_sel_r; // APB Slave Select
  logic        apb_bar_sel_s; // APB Slave Select
  logic        apb_bar_sel_r; // APB Slave Select
  logic        apb_baz_sel_s; // APB Slave Select
  logic        apb_baz_sel_r; // APB Slave Select

  // ------------------------------------------------------
  // transfer decoding
  // ------------------------------------------------------
  always_comb begin: proc_xfer_dec_proc
    ahb_slv_sel_s = ahb_slv_hsel_i & ahb_slv_hready_i;
    if ((ahb_slv_sel_s == 1'b1) &&
        ((ahb_slv_htrans_i == ahb_trans_nonseq_e) || (ahb_slv_htrans_i == ahb_trans_seq_e))) begin
      new_xfer_s = 1'b1;
    end else begin
      new_xfer_s = 1'b0;
    end
    valid_addr_s = 1'b0;
    apb_foo_sel_s = 1'b0;
    apb_bar_sel_s = 1'b0;
    apb_baz_sel_s = 1'b0;

    casez(ahb_slv_haddr_i[26:10])
      17'b000000000000000??: begin // foo
        valid_addr_s = 1'b1;
        apb_foo_sel_s = 1'b1;
      end

      17'b00000000000000100: begin // bar
        valid_addr_s = 1'b1;
        apb_bar_sel_s = 1'b1;
      end

      17'b00000000000010???, 17'b000000000000110??, 17'b00000000000011100: begin // baz
        valid_addr_s = 1'b1;
        apb_baz_sel_s = 1'b1;
      end

      default: begin
        valid_addr_s = 1'b0;
      end
    endcase

    case (ahb_slv_hsize_i)
      ahb_size_byte_e: begin
        case (ahb_slv_haddr_i[1:0])
          2'b11: begin
            size_strb_s = 4'b1000;
          end
          2'b10: begin
            size_strb_s = 4'b0100;
          end
          2'b01: begin
            size_strb_s = 4'b0010;
          end
          default: begin
            size_strb_s = 4'b0001;
          end
        endcase
      end

      ahb_size_halfword_e: begin
        size_strb_s = (ahb_slv_haddr_i[0] == 1'b1) ? 4'b1100 : 4'b0011;
      end

      default: begin
        size_strb_s = 4'b1111;
      end
    endcase
  end


  // ------------------------------------------------------
  // slave input multiplexing
  // ------------------------------------------------------
  always_comb begin: proc_slave_mux
    pready_s = (apb_slv_foo_pready_i & apb_foo_sel_r) |
               (apb_slv_bar_pready_i & apb_bar_sel_r) |
               (apb_slv_baz_pready_i & apb_baz_sel_r);
    pslverr_s = (apb_slv_foo_pslverr_i & apb_foo_sel_r) |
                (apb_slv_bar_pslverr_i & apb_bar_sel_r) |
                (apb_slv_baz_pslverr_i & apb_baz_sel_r);
    prdata_s = (apb_slv_foo_prdata_i & {32{(~pwrite_r & penable_r & apb_foo_sel_r)}}) |
               (apb_slv_bar_prdata_i & {32{(~pwrite_r & penable_r & apb_bar_sel_r)}}) |
               (apb_slv_baz_prdata_i & {32{(~pwrite_r & penable_r & apb_baz_sel_r)}});
    hready_s = hready_r & ((pready_s & ~pslverr_s) |
               ~(apb_foo_sel_r | apb_bar_sel_r | apb_baz_sel_r));
  end

  // ------------------------------------------------------
  // FSM
  // ------------------------------------------------------
  always_ff @ (posedge main_clk_i or negedge main_rst_an_i) begin: proc_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_r <= fsm_idle_st;
      hready_r <= 1'b1;
      hresp_r <= apb_resp_okay_e;
      hauser_r <= 4'h2;
      paddr_r <= 14'h0000;
      pwrite_r <= 1'b0;
      pwdata_r <= 32'h00000000;
      pstrb_r <= 4'h0;
      prdata_r <= 32'h00000000;
      penable_r <= 1'b0;
      apb_foo_sel_r <= 1'b0;
      apb_bar_sel_r <= 1'b0;
      apb_baz_sel_r <= 1'b0;
    end else begin
      case (fsm_r)
        fsm_idle_st: begin
          if (new_xfer_s == 1'b1) begin
            if (valid_addr_s == 1'b1) begin
              hready_r <= 1'b0;
              hauser_r <= ahb_slv_hauser_i;
              hresp_r <= apb_resp_okay_e;
              paddr_r <= ahb_slv_haddr_i[13:0];
              pwrite_r <= ahb_slv_hwrite_i;
              pstrb_r <= (ahb_slv_hwrite_i == ahb_write_write_e) ? size_strb_s : 4'h0;
              apb_foo_sel_r <= apb_foo_sel_s;
              apb_bar_sel_r <= apb_bar_sel_s;
              apb_baz_sel_r <= apb_baz_sel_s;
              fsm_r <= fsm_apb_ctrl_st;
            end else begin
              hresp_r <= apb_resp_error_e;
              fsm_r <= fsm_ahb_err_st;
            end
          end else begin
            hresp_r <= apb_resp_okay_e;
          end
        end

        fsm_apb_ctrl_st: begin
          if (pwrite_r == 1'b1) begin
            pwdata_r <= ahb_slv_hwdata_i;
          end
          penable_r <= 1'b1;
          hready_r <= 1'b1;
          fsm_r <= fsm_apb_data_st;
        end

        fsm_apb_data_st: begin
          if (pready_s == 1'b1) begin
            penable_r <= 1'b0;
            if (pslverr_s == 1'b1) begin
              hready_r <= 1'b0;
              hresp_r <= apb_resp_error_e;
              apb_foo_sel_r <= 1'b0;
              apb_bar_sel_r <= 1'b0;
              apb_baz_sel_r <= 1'b0;
              fsm_r <= fsm_ahb_err_st;
            end else if (new_xfer_s == 1'b1) begin
              hready_r <= 1'b0;
              if (valid_addr_s == 1'b1) begin
                hauser_r <= ahb_slv_hauser_i;
                paddr_r <= ahb_slv_haddr_i[13:0];
                pwrite_r <= ahb_slv_hwrite_i;
                pstrb_r <= (ahb_slv_hwrite_i == ahb_write_write_e) ? size_strb_s : 4'h0;
                apb_foo_sel_r <= apb_foo_sel_s;
                apb_bar_sel_r <= apb_bar_sel_s;
                apb_baz_sel_r <= apb_baz_sel_s;
                fsm_r <= fsm_apb_ctrl_st;
              end else begin
              pstrb_r <= 4'h0;
                apb_foo_sel_r <= 1'b0;
                apb_bar_sel_r <= 1'b0;
                apb_baz_sel_r <= 1'b0;
                hresp_r <= apb_resp_error_e;
                fsm_r <= fsm_ahb_err_st;
              end
            end else begin // no new xfer and no pslverr
              penable_r <= 1'b0;
              hready_r <= 1'b1;
              pwrite_r <= 1'b0;
              pstrb_r <= 4'h0;
              apb_foo_sel_r <= 1'b0;
              apb_bar_sel_r <= 1'b0;
              apb_baz_sel_r <= 1'b0;
              fsm_r <= fsm_idle_st;
            end
          end
        end

        fsm_ahb_err_st: begin
          hready_r <= 1'b1;
          fsm_r <= fsm_idle_st;
        end

        default: begin
          hready_r <= 1'b1;
          hresp_r <= apb_resp_okay_e;
          pwrite_r <= 1'b0;
          pstrb_r <= 4'h0;
          pwdata_r <= 32'h00000000;
          penable_r <= 1'b0;
          paddr_r <= 14'h0000;
          apb_foo_sel_r <= 1'b0;
          apb_bar_sel_r <= 1'b0;
          apb_baz_sel_r <= 1'b0;
          fsm_r <= fsm_idle_st;
        end
      endcase
    end
  end


  // ------------------------------------------------------
  // output Assignments
  // ------------------------------------------------------
  assign ahb_slv_hreadyout_o = hready_s;
  assign ahb_slv_hrdata_o = prdata_s;
  assign ahb_slv_hresp_o = hresp_r;

  assign pwdata_s = (penable_r == 1'b1) ? pwdata_r : ahb_slv_hwdata_i;

  // Slave 'foo':
  assign apb_slv_foo_paddr_o   = (apb_foo_sel_r  == 1'b1) ? paddr_r[11:0] : 12'h000;
  assign apb_slv_foo_pwrite_o  = pwrite_r & apb_foo_sel_r;
  assign apb_slv_foo_pwdata_o  = ((pwrite_r & apb_foo_sel_r)  == 1'b1) ? pwdata_s : 32'h00000000;
  assign apb_slv_foo_penable_o = penable_r & apb_foo_sel_r;
  assign apb_slv_foo_psel_o    = apb_foo_sel_r;
  assign apb_slv_foo_pauser_o  = hauser_r;
  // Slave 'bar':
  assign apb_slv_bar_paddr_o   = (apb_bar_sel_r  == 1'b1) ? paddr_r[9:0] : 10'h000;
  assign apb_slv_bar_pwrite_o  = pwrite_r & apb_bar_sel_r;
  assign apb_slv_bar_pwdata_o  = ((pwrite_r & apb_bar_sel_r)  == 1'b1) ? pwdata_s : 32'h00000000;
  assign apb_slv_bar_penable_o = penable_r & apb_bar_sel_r;
  assign apb_slv_bar_psel_o    = apb_bar_sel_r;
  assign apb_slv_bar_pstrb_o   = pstrb_r;
  assign apb_slv_bar_pauser_o  = hauser_r;
  // Slave 'baz':
  assign apb_slv_baz_paddr_o   = (apb_baz_sel_r  == 1'b1) ? paddr_r[13:0] : 14'h0000;
  assign apb_slv_baz_pwrite_o  = pwrite_r & apb_baz_sel_r;
  assign apb_slv_baz_pwdata_o  = ((pwrite_r & apb_baz_sel_r)  == 1'b1) ? pwdata_s : 32'h00000000;
  assign apb_slv_baz_penable_o = penable_r & apb_baz_sel_r;
  assign apb_slv_baz_psel_o    = apb_baz_sel_r;
  assign apb_slv_baz_pauser_o  = hauser_r;


endmodule // ucdp_ahb2apb_example_odd

`default_nettype wire
`end_keywords
