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


def decode_casez(decoding_slice: u.Slice, addrspace: SlaveAddrspace):
  size = addrspace.size >> decoding_slice.right
  base = addrspace.baseaddr >> decoding_slice.right
  masks = [f"{decoding_slice.width}'b{mask}" for mask in num.calc_addrwinmasks(base, size, decoding_slice.width, '?')]
  return ", ".join(masks)

%>
<%inherit file="sv.mako"/>

<%def name="logic(indent=0, skip=None)">\
<%
  rslvr = usv.get_resolver(mod)
  nr_slv = len(mod.slaves)
  dec_bits = [num.calc_lowest_bit_set(aspc.size) for aspc in mod.addrmap]
  dec_slice = u.Slice(left=mod.ahb_addrwidth-1, right=min(dec_bits))
  rng_bits = [num.calc_unsigned_width(aspc.size - 1) for aspc in mod.addrmap]
  paddr_slice = u.Slice(width=max(rng_bits))

  ff_dly = f"#{rslvr.ff_dly} " if rslvr.ff_dly else ""
%>
${parent.logic(indent=indent, skip=skip)}\

  // ------------------------------------------------------
  // address decoding
  // ------------------------------------------------------
  always_comb begin: proc_xfer_dec_proc
    if ((ahb_slv_sel_s == 1'b1) &&
        ((ahb_slv_htrans_i == ahb_trans_nonseq_e) || (ahb_slv_htrans_i == ahb_trans_seq_e))) begin
      new_xfer_s = 1'b1;
    end else begin
      new_xfer_s = 1'b0;
    end
    ahb_slv_sel_s = ahb_slv_hsel_i & ahb_slv_hready_i;
    valid_addr_s = 1'b0;
% for aspc in mod.addrmap:
    apb_${aspc.name}_sel_s = 1'b0;
% endfor

    casez(ahb_slv_haddr_i[${dec_slice}])
% for aspc in mod.addrmap:
      ${decode_casez(dec_slice, aspc)}: begin // ${aspc.name}
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
  sels = [f"apb_{aspc.name}_sel_r" for aspc in mod.addrmap]
  if nr_slv > 1:
    selgrps = [" | ".join(sels[i:i+4]) for i in range(0, nr_slv, 4)]
    selgrps = " |\n                 ".join(selgrps)
    nosels = f"~({selgrps})"
  else:
    nosels = f"~{sels[0]}"
%>
  // ------------------------------------------------------
  // slave input multiplexing
  // ------------------------------------------------------
  always_comb begin: proc_slave_mux
    pready_s = ${rdy_terms};
% if mod.optbw:
    hready_s = hready_r & ((pready_s & ~pslverr_s) |
               ${nosels});
% endif
    pslverr_s = ${err_terms};
    prdata_s = ${dta_terms};
  end

  // ------------------------------------------------------
  // FSM
  // ------------------------------------------------------
  always_ff @ (posedge main_clk_i or negedge main_rst_an_i) begin: proc_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_r <= ${ff_dly}fsm_idle_st;
      hready_r <= ${ff_dly}1'b1;
% if not mod.errirq:
      hresp_r <= ${ff_dly}apb_resp_okay_e;
% endif
      paddr_r <= ${ff_dly}${rslvr._get_uint_value(0, paddr_slice.width)};
      pwrite_r <= ${ff_dly}1'b0;
      pwdata_r <= ${ff_dly}${rslvr._get_uint_value(0, mod.datawidth)};
      penable_r <= ${ff_dly}1'b0;
% for aspc in mod.addrmap:
      apb_${aspc.name}_sel_r <= ${ff_dly}1'b0;
% endfor
      prdata_r <= ${ff_dly}${rslvr._get_uint_value(0, mod.datawidth)};
% if mod.errirq:
      irq_r <= ${ff_dly}1'b0;
% endif
    end else begin
      case (fsm_r)
        fsm_idle_st: begin
          if (new_xfer_s == 1'b1) begin
            if (valid_addr_s == 1'b1) begin
              hready_r <= ${ff_dly}1'b0;
% if mod.errirq:
              irq_r <= ${ff_dly}1'b0;
% endif
              paddr_r <= ${ff_dly}ahb_slv_haddr_i[${paddr_slice}];
              pwrite_r <= ${ff_dly}ahb_slv_hwrite_i;
% for aspc in mod.addrmap:
              apb_${aspc.name}_sel_r <= ${ff_dly}apb_${aspc.name}_sel_s;
% endfor
              fsm_r <= ${ff_dly}fsm_apb_ctrl_st;
            end else begin
% if mod.errirq:
              irq_r <= ${ff_dly}1'b1;
% else:
              hresp_r <= ${ff_dly}apb_resp_error_e;
              fsm_r <= ${ff_dly}fsm_ahb_err_st;
% endif
            end
% if mod.errirq:
          end else begin
            irq_r <= ${ff_dly}1'b0;
% endif
          end
        end

        fsm_apb_ctrl_st: begin
          if (pwrite_r == 1'b1) begin
            pwdata_r <= ${ff_dly}ahb_slv_hwdata_i;
          end
          penable_r <= ${ff_dly}1'b1;
% if mod.optbw:
          hready_r <= ${ff_dly}1'b1;
% endif
          fsm_r <= ${ff_dly}fsm_apb_data_st;
        end

        fsm_apb_data_st: begin
          if (pready_s == 1'b1) begin
            penable_r <= ${ff_dly}1'b0;
% for aspc in mod.addrmap:
            apb_${aspc.name}_sel_r <= ${ff_dly}1'b0;
% endfor
            prdata_r <= ${ff_dly}prdata_s;
% if mod.errirq:
            hresp_r <= ${ff_dly}apb_resp_okay_e;
            hready_r <= ${ff_dly}1'b1;
            irq_r <= ${ff_dly}pslverr_s;
            fsm_r <= ${ff_dly}fsm_idle_st;
% else:
            if (pslverr_s == 1'b0) begin
              hready_r <= ${ff_dly}1'b1;
              hresp_r <= ${ff_dly}apb_resp_okay_e;
              fsm_r <= ${ff_dly}fsm_idle_st;
            end else begin
              hresp_r <= ${ff_dly}apb_resp_error_e;
              fsm_r <= ${ff_dly}fsm_ahb_err_st;
            end
% endif
          end
        end

% if not mod.errirq:
        fsm_ahb_err_st: begin
          hready_r <= ${ff_dly}1'b1;
          fsm_r <= ${ff_dly}fsm_idle_st;
        end
% endif

        default: begin
          hready_r <= ${ff_dly}1'b1;
% if not mod.errirq:
          hresp_r <= ${ff_dly}apb_resp_okay_e;
% endif
          pwrite_r <= ${ff_dly}1'b0;
          pwdata_r <= ${ff_dly}${rslvr._get_uint_value(0, mod.datawidth)};
          penable_r <= ${ff_dly}1'b0;
% for aspc in mod.addrmap:
          apb_${aspc.name}_sel_r <= ${ff_dly}1'b0;
% endfor
          fsm_r <= ${ff_dly}fsm_idle_st;
        end
      endcase
    end
  end

<%
  outp_asgn = Align(rtrim=True)
  outp_asgn.set_separators(" = ", first="  assign ")
  dzero = rslvr._get_uint_value(0, mod.datawidth)
  for aspc in mod.addrmap:
    asz = num.calc_unsigned_width(aspc.size - 1)
    azero = rslvr._get_uint_value(0, asz)
    outp_asgn.add_spacer(f"  // Slave {aspc.name!r}:")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_paddr_o", f"(apb_{aspc.name}_sel_r  == 1'b1) ? paddr_r[{asz-1}:0] : {azero};")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_pwrite_o", f"pwrite_r & apb_{aspc.name}_sel_r;")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_pwdata_o", f"(apb_{aspc.name}_sel_r  == 1'b1) ? pwdata_s : {dzero};")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_penable_o", f"penable_r & apb_{aspc.name}_sel_r;")
    outp_asgn.add_row(f"apb_slv_{aspc.name}_psel_o", f"apb_{aspc.name}_sel_r;")
%>
  // ------------------------------------------------------
  // output Assignments
  // ------------------------------------------------------
% if mod.optbw:
  assign ahb_slv_hreadyout_o = hready_s;
% else:
  assign ahb_slv_hreadyout_o = hready_r;
% endif
% if mod.errirq:
  assign ahb_slv_hresp_o = apb_resp_okay_e;
% else:
  assign ahb_slv_hresp_o = hresp_r;
% endif
  assign ahb_slv_hrdata_o = prdata_r;

  assign pwdata_s = (penable_r == 1'b1) ? pwdata_r : ahb_slv_hwdata_i;

${outp_asgn.get()}
% if mod.errirq:

  assign irq_o = irq_r;
% endif

</%def>
