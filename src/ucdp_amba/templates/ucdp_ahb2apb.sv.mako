##
## MIT License
##
## Copyright (c) 2024 nbiotcloud
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.
##

<%!
import ucdp as u
import ucdpsv as usv
from aligntext import Align
from ucdp_glbl.addrslave import SlaveAddrspace
from icdutil import num


def decode_casex(decoding_slice: u.Slice, addrspace: SlaveAddrspace):
  size = addrspace.size >> decoding_slice.right
  base = addrspace.baseaddr >> decoding_slice.right
  masks = [f"{decoding_slice.width}'b{mask}" for mask in num.calc_addrwinmasks(base, size, decoding_slice.width, 'x')]
  return ", ".join(masks)

%>
<%inherit file="sv.mako"/>

<%def name="logic(indent=0, skip=None)">\
<%
  rslvr = usv.get_resolver(mod)
  nr_slv = len(mod.slaves)
  rng_bits = [num.calc_unsigned_width(aspc.size - 1) for aspc in mod.addrmap]
  dec_slice = u.Slice(left=mod.ahb_addrwidth-1, right=min(rng_bits))
  paddr_slice = u.Slice(width=max(rng_bits))

  ff_dly = f"#{rslvr.ff_dly} " if rslvr.ff_dly else ""
%>
${parent.logic(indent=indent, skip=skip)}\

  // ------------------------------------------------------
  // address decoding
  // ------------------------------------------------------
  always_comb begin: proc_addr_decaccess_proc
    valid_addr_s = 1'b0;
% for aspc in mod.addrmap:
    apb_${aspc.name}_sel_s = 1'b0;
% endfor

    casex(ahb_slv_haddr_i[${dec_slice}])
% for aspc in mod.addrmap:
      ${decode_casex(dec_slice, aspc)}: begin // ${aspc.name}
        valid_addr_s = 1'b1;
        apb_${aspc.name}_sel_s = 1'b1;
      end

% endfor
      default: begin
        valid_addr_s = 1'b0;
      end
    endcase
  end

<%
  rdy_terms = []
  err_terms = []
  dta_terms = []
  for aspc in mod.addrmap:
    rdy_terms.append(f"(apb_slv_{aspc.name}_pready_i & apb_{aspc.name}_sel_r)")
    err_terms.append(f"(apb_slv_{aspc.name}_pslverr_i & apb_{aspc.name}_sel_r)")
    dta_terms.append(f"(apb_slv_{aspc.name}_prdata_i & {{{mod.datawidth}{{apb_{aspc.name}_sel_r}}}})")
  rdy_terms = " |\n               ".join(rdy_terms)
  err_terms = " |\n                ".join(err_terms)
  dta_terms = " |\n               ".join(dta_terms)
%>
  // ------------------------------------------------------
  // slave input multiplexing
  // ------------------------------------------------------
  always_comb begin: proc_slave_mux
    pready_s = ${rdy_terms};
    pslverr_s = ${err_terms};
    prdata_s = ${dta_terms};
  end

  // ------------------------------------------------------
  // FSM
  // ------------------------------------------------------
  always_ff @ (posedge main_clk_i or negedge main_rst_an_i) begin: proc_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_r <= ${ff_dly}idle_st;
      hready_r <= ${ff_dly}1'b1;
      hresp_r <= ${ff_dly}apb_resp_okay_e;
      paddr_r <= ${ff_dly}${rslvr._get_uint_value(0, paddr_slice.width)};
      pwdata_r <= ${ff_dly}${rslvr._get_uint_value(0, mod.datawidth)};
      penable_r <= ${ff_dly}1'b0;
% for aspc in mod.addrmap:
      apb_${aspc.name}_sel_r <= ${ff_dly}1'b0;
% endfor
      prdata_r <= ${ff_dly}${rslvr._get_uint_value(0, mod.datawidth)};

    end else begin
      case (fsm_r)
        idle_st: begin
          if (ahb_slv_htrans_i != ahb_trans_idle_e) begin
            hready_r <= ${ff_dly}1'b0;
            if (valid_addr_s == 1'b1) begin
              paddr_r <= ahb_slv_haddr_i[${paddr_slice}];
% for aspc in mod.addrmap:
              apb_${aspc.name}_sel_r <= ${ff_dly}apb_${aspc.name}_sel_s;
% endfor
              fsm_r <= ${ff_dly}apb_ctrl_st;
            end else begin
              hresp_r <= ${ff_dly}apb_resp_error_e;
              fsm_r <= ${ff_dly}ahb_err_st;
            end
          end
        end

        apb_ctrl_st: begin
          pwdata_r <= ${ff_dly}ahb_slv_hwdata_i;
          penable_r <= ${ff_dly}1'b1;
          fsm_r <= ${ff_dly}apb_data_st;
        end

        apb_data_st: begin
          if (pready_s == 1'b1) begin
            penable_r <= ${ff_dly}1'b0;
% for aspc in mod.addrmap:
            apb_${aspc.name}_sel_r <= ${ff_dly}1'b0;
% endfor
            prdata_r <= ${ff_dly}prdata_s;
            if (ahb_slv_htrans_i == ahb_trans_busy_e) begin
              if (pslverr_s == 1'b0) begin
                fsm_r <= ${ff_dly}ahb_busy_finish_st;
              end else begin
                fsm_r <= ${ff_dly}ahb_busy_err_st;
              end
            end else begin
              if (pslverr_s == 1'b0) begin
                hready_r <= ${ff_dly}1'b1;
                fsm_r <= ${ff_dly}ahb_finish_st;
              end else begin
                hresp_r <= ${ff_dly}apb_resp_error_e;
                fsm_r <= ${ff_dly}ahb_err_st;
              end
            end
          end
        end

        ahb_finish_st: begin
          if (ahb_slv_htrans_i != ahb_trans_idle_e) begin
            hready_r <= ${ff_dly}1'b0;
            if (valid_addr_s == 1'b1) begin
              paddr_r <= ahb_slv_haddr_i[${paddr_slice}];
              fsm_r <= ${ff_dly}apb_ctrl_st;
            end else begin
              fsm_r <= ${ff_dly}ahb_err_st;
            end
          end else begin
            fsm_r <= ${ff_dly}idle_st;
          end
        end

        ahb_err_st: begin
          hready_r <= ${ff_dly}1'b1;
          hresp_r <= ${ff_dly}apb_resp_okay_e;
          fsm_r <= ${ff_dly}ahb_finish_st;
        end

        ahb_busy_finish_st: begin
          if (ahb_slv_htrans_i == ahb_trans_seq_e) begin
            hready_r <= ${ff_dly}1'b1;
            fsm_r <= ${ff_dly}ahb_finish_st;
          end
        end

        ahb_busy_err_st: begin
          if (ahb_slv_htrans_i == ahb_trans_seq_e) begin
            hresp_r <= ${ff_dly}apb_resp_error_e;
            fsm_r <= ${ff_dly}ahb_err_st;
          end
        end

        default: begin
          hready_r <= ${ff_dly}1'b1;
          fsm_r <= ${ff_dly}idle_st;
        end
      endcase
    end
  end

<%
  outp_asgn = Align(rtrim=True)
  outp_asgn.set_separators(" = ", first="  assign ")
  for aspc in mod.addrmap:
    outp_asgn.add_spacer(f"  // Slave {aspc.name!r}:")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_paddr_o", f"paddr_r[{num.calc_unsigned_width(aspc.size - 1)-1}:0];")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_pwrite_o", "pwrite_r;")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_pwdata_o", "pwdata_s;")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_penable_o", "penable_r;")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_psel_o", f"apb_{aspc.name}_sel_r;")
%>
  // ------------------------------------------------------
  // output Assignments
  // ------------------------------------------------------
  assign pwdata_s = (fms_r == apb_ctrl_st) ? ahb_slv_hwdata_i : pwdata_r;

${outp_asgn.get()}

</%def>
