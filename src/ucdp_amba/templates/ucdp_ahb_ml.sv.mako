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
import ucdp_amba.types as t
from ucdp_glbl.addrslave import SlaveAddrspace
from ucdp_amba.ucdp_ahb_ml import Master, UcdpAhbMlMod
from collections.abc import Iterator
from aligntext import Align
from icdutil import num


def get_master_addrspaces(mod: UcdpAhbMlMod, mastername: str) -> Iterator[SlaveAddrspace]:
  for aspc in mod.addrmap:
    if aspc.slave.name in mod._master_slaves[mastername]:
      yield aspc

def get_slave_addrspaces(mod: UcdpAhbMlMod, slavename: str) -> Iterator[SlaveAddrspace]:
  for aspc in mod.addrmap:
    if aspc.slave.name == slavename:
      yield aspc

def decode_casez(decoding_slice: u.Slice, addrspaces: list[SlaveAddrspace]):
  allmasks = []
  for addrspace in addrspaces:
    size = addrspace.size >> decoding_slice.right
    base = addrspace.baseaddr >> decoding_slice.right
    masks = [f"{decoding_slice.width}'b{mask}" for mask in num.calc_addrwinmasks(base, size, decoding_slice.width, '?')]
    allmasks.extend(masks)
  return ", ".join(allmasks)

%>
<%inherit file="sv.mako"/>

<%def name="logic(indent=0, skip=None)">\
<%
  rslvr = usv.get_resolver(mod)
  dec_slices: dict[str, u.Slice] = {}
  num_masters = len(mod.masters)
  for master in mod.masters:
    rng_bits = [num.calc_lowest_bit_set(aspc.size) for aspc in get_master_addrspaces(mod, master.name)]
    dec_slices[master.name] = u.Slice(left=mod.addrwidth-1, right=min(rng_bits))

  ff_dly = f"#{rslvr.ff_dly} " if rslvr.ff_dly else ""
%>\

${parent.logic(indent=indent, skip=skip)}


  // ------------------------------------------------------
  // The Masters:
  // ------------------------------------------------------
% for master in mod.masters:
<%
  master_slaves = mod._master_slaves[master.name]
  num_slaves = len(master_slaves)
  if num_slaves == 1:
    sole_slv = master_slaves[0]
  xfers = Align(rtrim=True)
  xfers.set_separators(first=" "*4)
  xfers.add_row(f"mst_{master.name}_new_xfer_s", "=", f"(ahb_mst_{master.name}_htrans_i == ahb_trans_nonseq_e) ? 1'b1 : 1'b0;")
  xfers.add_row(f"mst_{master.name}_cont_xfer_s", "=", f"((ahb_mst_{master.name}_htrans_i == ahb_trans_busy_e) ||")
  xfers.add_row("", "", f" (ahb_mst_{master.name}_htrans_i == ahb_trans_seq_e)) ? 1'b1 : 1'b0;")
  xfers.add_row(f"mst_{master.name}_rqstate_s", "=", f"((fsm_{master.name}_r == fsm_idle_st) ||")
  xfers.add_row("", "", f" (fsm_{master.name}_r == fsm_transfer_st) ||")
  xfers.add_row("", "", f" (fsm_{master.name}_r == fsm_transfer_finish_st) ||")
  xfers.add_row("", "", f" (fsm_{master.name}_r == fsm_error2_st)) ? 1'b1 : 1'b0;")
  reqkeep = Align(rtrim=True)
  reqkeep.set_separators(first=" "*4)
  for slavename in master_slaves:
    reqkeep.add_row(f"mst_{master.name}_{slavename}_req_s", "=", f"(mst_{master.name}_{slavename}_sel_s & mst_{master.name}_new_xfer_s & mst_{master.name}_rqstate_s) | mst_{master.name}_{slavename}_req_r;")
    if len(mod._slave_masters[slavename]) > 1:
      reqkeep.add_row(f"mst_{master.name}_{slavename}_keep_s", "=", f"mst_{master.name}_{slavename}_sel_s & mst_{master.name}_cont_xfer_s;")
  mst_dec_slice = dec_slices[master.name]
%>\
  // Master '${master.name}' Logic
  always_comb begin: proc_${master.name}_logic
${xfers.get()}

    // Address Decoding
    mst_${master.name}_addr_err_s = 1'b0;
%   for slavename in master_slaves:
    mst_${master.name}_${slavename}_sel_s = 1'b0;
%   endfor

    casez (ahb_mst_${master.name}_haddr_i[${mst_dec_slice}])
%   for slavename in master_slaves:
      ${decode_casez(mst_dec_slice, get_slave_addrspaces(mod, slavename))}: begin // ${slavename}
        mst_${master.name}_${slavename}_sel_s = 1'b1;
      end

%   endfor
      default: begin
        mst_${master.name}_addr_err_s = mst_${master.name}_new_xfer_s;
      end
    endcase

${reqkeep.get()}

    // Grant Combination
<%
    mst_gnt = [f"slv_{slave}_{master.name}_gnt_s" for slave in master_slaves]
    indent = 7 + len(f"mst_{master.name}_gnt_s")
    mst_gnt = (" |\n" + " "*indent).join(mst_gnt)
%>\
    mst_${master.name}_gnt_s = ${mst_gnt};
  end

  // FSM for Master '${master.name}'
  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin: proc_${master.name}_fsm
    if (main_rst_an_i == 1'b0) begin
      fsm_${master.name}_r <= ${ff_dly}fsm_idle_st;
%   for slavename in master_slaves:
      mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}1'b0;
%   endfor
    end else begin
      case (fsm_${master.name}_r)
        fsm_idle_st: begin
          if (mst_${master.name}_new_xfer_s == 1'b1) begin
            if (mst_${master.name}_addr_err_s == 1'b1) begin
              fsm_${master.name}_r <= ${ff_dly}fsm_error1_st;
            end else if (mst_${master.name}_gnt_s == 1'b1) begin
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_req_r <= ${ff_dly}1'b0;
%   endfor
              fsm_${master.name}_r <= ${ff_dly}fsm_transfer_st;
            end else begin
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_req_r <= ${ff_dly}mst_${master.name}_${slavename}_sel_s;
%   endfor
              fsm_${master.name}_r <= ${ff_dly}fsm_transfer_wait_st;
            end
%   for slavename in master_slaves:
            mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}slv_${slavename}_${master.name}_gnt_s;
%   endfor
          end
        end

        fsm_error0_st: begin
          if (mst_${master.name}_hready_s == 1'b1) begin
            fsm_${master.name}_r <= ${ff_dly}fsm_error1_st;
          end
        end

        fsm_error1_st: begin
          fsm_${master.name}_r <= ${ff_dly}fsm_error2_st;
        end

        fsm_error2_st: begin
          if (mst_${master.name}_new_xfer_s == 1'b1) begin
            if (mst_${master.name}_addr_err_s == 1'b1) begin
              fsm_${master.name}_r <= ${ff_dly}fsm_error1_st;
            end else if (mst_${master.name}_gnt_s == 1'b1) begin
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_req_r <= ${ff_dly}1'b0;
%   endfor
              fsm_${master.name}_r <= ${ff_dly}fsm_transfer_st;
            end else begin
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_req_r <= ${ff_dly}mst_${master.name}_${slavename}_sel_s;
%   endfor
              fsm_${master.name}_r <= ${ff_dly}fsm_transfer_wait_st;
            end
%   for slavename in master_slaves:
            mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}slv_${slavename}_${master.name}_gnt_s;
%   endfor
          end else begin
            fsm_${master.name}_r <= ${ff_dly}fsm_idle_st;
          end
        end

        fsm_transfer_st: begin
          if ((ahb_mst_${master.name}_htrans_i == ahb_trans_seq_e) ||
              (ahb_mst_${master.name}_htrans_i == ahb_trans_busy_e)) begin
            fsm_${master.name}_r <= ${ff_dly}fsm_transfer_st;
          end else begin
            if (ahb_mst_${master.name}_htrans_i == ahb_trans_idle_e) begin
              if (mst_${master.name}_hready_s == 1'b0) begin
                fsm_${master.name}_r <= ${ff_dly}fsm_transfer_finish_st;
              end else begin
%   for slavename in master_slaves:
                mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}1'b0;
%   endfor
                fsm_${master.name}_r <= ${ff_dly}fsm_idle_st;
              end
            end else begin // ((ahb_mst_${master.name}_htrans_i == ahb_trans_nonseq_e)
              if (mst_${master.name}_addr_err_s == 1'b1) begin
                if (mst_${master.name}_hready_s == 1'b0) begin
                  fsm_${master.name}_r <= ${ff_dly}fsm_error0_st;
                end else begin
                  fsm_${master.name}_r <= ${ff_dly}fsm_error1_st;
                end
              end else if (mst_${master.name}_gnt_s == 1'b1) begin
%   for slavename in master_slaves:
                mst_${master.name}_${slavename}_req_r <= ${ff_dly}1'b0;
%   endfor
                fsm_${master.name}_r <= ${ff_dly}fsm_transfer_st;
              end else begin
%   for slavename in master_slaves:
                mst_${master.name}_${slavename}_req_r <= ${ff_dly}mst_${master.name}_${slavename}_sel_s;
%   endfor
                fsm_${master.name}_r <= ${ff_dly}fsm_transfer_wait_st;
              end
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}slv_${slavename}_${master.name}_gnt_s;
%   endfor
            end
          end
        end

        fsm_transfer_wait_st: begin
          if (mst_${master.name}_gnt_s == 1'b1) begin
%   for slavename in master_slaves:
            mst_${master.name}_${slavename}_req_r <= ${ff_dly}1'b0;
%   endfor
%   for slavename in master_slaves:
            mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}slv_${slavename}_${master.name}_gnt_s;
%   endfor
            fsm_${master.name}_r <= ${ff_dly}fsm_transfer_st;
          end
        end

        fsm_transfer_finish_st: begin
          if (mst_${master.name}_hready_s == 1'b1) begin
            if (mst_${master.name}_new_xfer_s == 1'b1) begin
              if (mst_${master.name}_addr_err_s == 1'b1) begin
                fsm_${master.name}_r <= ${ff_dly}fsm_error1_st;
              end else if (mst_${master.name}_gnt_s == 1'b1) begin
%   for slavename in master_slaves:
                mst_${master.name}_${slavename}_req_r <= ${ff_dly}1'b0;
%   endfor
                fsm_${master.name}_r <= ${ff_dly}fsm_transfer_st;
              end else begin
%   for slavename in master_slaves:
                mst_${master.name}_${slavename}_req_r <= ${ff_dly}mst_${master.name}_${slavename}_sel_s;
%   endfor
                fsm_${master.name}_r <= ${ff_dly}fsm_transfer_wait_st;
              end
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}slv_${slavename}_${master.name}_gnt_s;
%   endfor
            end else begin
%   for slavename in master_slaves:
              mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}1'b0;
%   endfor
              fsm_${master.name}_r <= ${ff_dly}fsm_idle_st;
            end
          end
        end

        default: begin
%   for slavename in master_slaves:
          mst_${master.name}_${slavename}_gnt_r <= ${ff_dly}1'b0;
          mst_${master.name}_${slavename}_req_r <= ${ff_dly}1'b0;
%   endfor
          fsm_${master.name}_r <= ${ff_dly}fsm_idle_st;
        end
      endcase
    end

    if ((mst_${master.name}_new_xfer_s == 1'b1) && (mst_${master.name}_gnt_s == 1'b0) && (mst_${master.name}_rqstate_s == 1'b1)) begin
      mst_${master.name}_haddr_r  <= ${ff_dly}ahb_mst_${master.name}_haddr_i;
      mst_${master.name}_htrans_r <= ${ff_dly}ahb_mst_${master.name}_htrans_i;
      mst_${master.name}_hburst_r <= ${ff_dly}ahb_mst_${master.name}_hburst_i;
      mst_${master.name}_hsize_r  <= ${ff_dly}ahb_mst_${master.name}_hsize_i;
      mst_${master.name}_hwrite_r <= ${ff_dly}ahb_mst_${master.name}_hwrite_i;
%   if master.proto.hprottype:
      mst_${master.name}_hprot_r  <= ${ff_dly}ahb_mst_${master.name}_hprot_i;
%   endif
%   if master.proto.ausertype:
      mst_${master.name}_hauser_r <= ${ff_dly}ahb_mst_${master.name}_hauser_i;
%   endif
    end
  end

<%
  mux_cond = [f"mst_{master.name}_{slave}_gnt_r" for slave in master_slaves]
  mux_cond = ', '.join(mux_cond)
  hrdy = [f"(ahb_slv_{slave}_hreadyout_i & mst_{master.name}_{slave}_gnt_r)" for slave in master_slaves]
  if num_slaves == 1:
    hrdy.append(f"~{mux_cond}")
  else:
    hrdy.append(f"~(|{{{mux_cond}}})")
  indent = 6 + len(f"mst_${master.name}_hready_s")
  jor = " |\n" + " "*indent
  hrdy = jor.join(hrdy)
%>\
  // Master '${master.name}' Mux
  always_comb begin: proc_${master.name}_mux
    if (fsm_${master.name}_r == fsm_transfer_wait_st) begin
      mst_${master.name}_haddr_s  = mst_${master.name}_haddr_r;
%   if master.proto.ausertype:
      mst_${master.name}_hauser_s = mst_${master.name}_hauser_r;
%   endif
      mst_${master.name}_hwrite_s = mst_${master.name}_hwrite_r;
      mst_${master.name}_hburst_s = mst_${master.name}_hburst_r;
      mst_${master.name}_hsize_s  = mst_${master.name}_hsize_r;
      mst_${master.name}_htrans_s = mst_${master.name}_htrans_r;
%   if master.proto.hprottype:
      mst_${master.name}_hprot_s  = mst_${master.name}_hprot_r;
%   endif
    end else begin
      mst_${master.name}_haddr_s  = ahb_mst_${master.name}_haddr_i;
%   if master.proto.ausertype:
      mst_${master.name}_hauser_s = ahb_mst_${master.name}_hauser_i;
%   endif
      mst_${master.name}_hwrite_s = ahb_mst_${master.name}_hwrite_i;
      mst_${master.name}_hburst_s = ahb_mst_${master.name}_hburst_i;
      mst_${master.name}_hsize_s  = ahb_mst_${master.name}_hsize_i;
      mst_${master.name}_htrans_s = ahb_mst_${master.name}_htrans_i;
%   if master.proto.hprottype:
      mst_${master.name}_hprot_s  = ahb_mst_${master.name}_hprot_i;
%   endif
    end

    mst_${master.name}_hready_s = ${hrdy};

    case (fsm_${master.name}_r)
      fsm_transfer_wait_st: begin
        ahb_mst_${master.name}_hrdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
        ahb_mst_${master.name}_hready_o = 1'b0;
        ahb_mst_${master.name}_hresp_o  = ahb_resp_okay_e;
      end

      fsm_error1_st: begin
        ahb_mst_${master.name}_hrdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
        ahb_mst_${master.name}_hready_o = 1'b0;
        ahb_mst_${master.name}_hresp_o  = ahb_resp_error_e;
      end

      fsm_error2_st: begin
        ahb_mst_${master.name}_hrdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
        ahb_mst_${master.name}_hready_o = 1'b1;
        ahb_mst_${master.name}_hresp_o  = ahb_resp_error_e;
      end

      fsm_error0_st, fsm_transfer_st: begin
%   if num_slaves == 1:
        ahb_mst_${master.name}_hrdata_o = ahb_slv_${sole_slv}_hrdata_i;
        ahb_mst_${master.name}_hready_o = ahb_slv_${sole_slv}_hreadyout_i;
        ahb_mst_${master.name}_hresp_o = ahb_slv_${sole_slv}_hresp_i;
%   else:
        case ({${mux_cond}})
%     for idx, slave in enumerate(reversed(master_slaves)):
          ${num_slaves}'b${f"{1<<idx:0{num_slaves}b}"}: begin
            ahb_mst_${master.name}_hrdata_o = ahb_slv_${slave}_hrdata_i;
            ahb_mst_${master.name}_hready_o = ahb_slv_${slave}_hreadyout_i;
            ahb_mst_${master.name}_hresp_o = ahb_slv_${slave}_hresp_i;
          end

%     endfor
          default: begin
            ahb_mst_${master.name}_hrdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
            ahb_mst_${master.name}_hready_o = 1'b1;
            ahb_mst_${master.name}_hresp_o  = ahb_resp_okay_e;
          end
        endcase
%   endif
      end

      fsm_transfer_finish_st: begin
%   if num_slaves == 1:
        ahb_mst_${master.name}_hrdata_o = ahb_slv_${sole_slv}_hrdata_i;
        ahb_mst_${master.name}_hready_o = ahb_slv_${sole_slv}_hreadyout_i;
        ahb_mst_${master.name}_hresp_o = ahb_slv_${sole_slv}_hresp_i;
%   else:
        case ({${mux_cond}})
%     for idx, slave in enumerate(reversed(master_slaves)):
          ${num_slaves}'b${f"{1<<idx:0{num_slaves}b}"}: begin
            ahb_mst_${master.name}_hrdata_o = ahb_slv_${slave}_hrdata_i;
            ahb_mst_${master.name}_hready_o = ahb_slv_${slave}_hreadyout_i;
            ahb_mst_${master.name}_hresp_o = ahb_slv_${slave}_hresp_i;
          end

%     endfor
          default: begin
            ahb_mst_${master.name}_hrdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
            ahb_mst_${master.name}_hready_o = 1'b1;
            ahb_mst_${master.name}_hresp_o  = ahb_resp_okay_e;
          end
        endcase
%   endif
      end

      default: begin
        ahb_mst_${master.name}_hrdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
        ahb_mst_${master.name}_hready_o = 1'b1;
        ahb_mst_${master.name}_hresp_o  = ahb_resp_okay_e;
      end
    endcase
  end

% endfor


  // ------------------------------------------------------
  // The Slaves:
  // ------------------------------------------------------
% for slave in mod.slaves:
<%
  slave_masters = mod._slave_masters[slave.name]
  slave_port = mod.ports[f"ahb_slv_{slave.name}_o"]
  num_masters = len(slave_masters)
  if num_masters == 1:
    sole_mst = slave_masters[0]
  slv_req = [f"mst_{master}_{slave.name}_req_s" for master in slave_masters]
  slv_req = ", ".join(slv_req)
%>\
%   if num_masters == 1:
  // Slave '${slave.name}': no arbitration necessary
  always_comb begin: proc_${slave.name}_asgn
    slv_${slave.name}_${sole_mst}_gnt_s = mst_${sole_mst}_${slave.name}_req_s;

    ahb_slv_${slave.name}_hsel_o     = ${slv_req};  // address phase signals
    if (mst_${sole_mst}_${slave.name}_sel_s == 1'b1) begin
      ahb_slv_${slave.name}_haddr_o  = ahb_mst_${sole_mst}_haddr_i;
%      if slave_port.type_.proto.ausertype:
      ahb_slv_${slave.name}_hauser_o = ahb_mst_${sole_mst}_hauser_i;
%      endif
      ahb_slv_${slave.name}_hwrite_o = ahb_mst_${sole_mst}_hwrite_i;
      ahb_slv_${slave.name}_hburst_o = ahb_mst_${sole_mst}_hburst_i;
      ahb_slv_${slave.name}_hsize_o  = ahb_mst_${sole_mst}_hsize_i;
      ahb_slv_${slave.name}_htrans_o = ahb_mst_${sole_mst}_htrans_i;
%      if slave_port.type_.proto.hprottype:
      ahb_slv_${slave.name}_hprot_o  = ahb_mst_${sole_mst}_hprot_i;
%      endif
      ahb_slv_${slave.name}_hready_o = mst_${sole_mst}_hready_s;
    end else begin
      ahb_slv_${slave.name}_haddr_o  = ${rslvr._get_uint_value(0, mod.addrwidth)};
      ahb_slv_${slave.name}_hwrite_o = ahb_write_read_e;
      ahb_slv_${slave.name}_hburst_o = ahb_burst_single_e;
      ahb_slv_${slave.name}_hsize_o  = ahb_size_word_e;
      ahb_slv_${slave.name}_htrans_o = ahb_trans_idle_e;
%     if slave.proto.hprottype:
      ahb_slv_${slave.name}_hprot_o  = ${rslvr.get_default(slave.proto.hprottype)};
%     endif
%     if slave.proto.ausertype:
      ahb_slv_${slave.name}_hauser_o = ${rslvr.get_default(slave.proto.ausertype)};
%     endif
      ahb_slv_${slave.name}_hready_o = ahb_slv_${slave.name}_hreadyout_i;
    end

    if (mst_${sole_mst}_${slave.name}_gnt_r == 1'b1) begin  // data phase signals
      ahb_slv_${slave.name}_hwdata_o = ahb_mst_${sole_mst}_hwdata_i;
    end else begin
      ahb_slv_${slave.name}_hwdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
    end
  end

%   else:
<%
  slv_gnt = [f"slv_{slave.name}_{master}_gnt_s" for master in slave_masters]
  slv_gnt = ", ".join(slv_gnt)
  prev_gnt = [f"slv_{slave.name}_{master}_gnt_r" for master in slave_masters]
  prev_gnt = ", ".join(prev_gnt)
  mst_sel = [f"mst_{master}_{slave.name}_gnt_r" for master in slave_masters]
  mst_sel = ", ".join(mst_sel)
  slv_keep = [f"mst_{master}_{slave.name}_keep_s" for master in slave_masters]
  slv_keep = " | ".join(slv_keep)
  slv_sel = Align(rtrim=True)
  slv_sel.set_separators(first=" "*6)
  for master in slave_masters:
    slv_sel.add_row(f"slv_{slave.name}_{master}_sel_s", "=", f"slv_{slave.name}_{master}_gnt_s |")
    slv_sel.add_row("", "", f"(mst_{master}_{slave.name}_keep_s & mst_{master}_{slave.name}_gnt_r);")
  slv_mux = [f"slv_{slave.name}_{master}_sel_s" for master in slave_masters]
  slv_mux = ", ".join(slv_mux)
%>\
  // // Slave '${slave.name}' round-robin arbiter
  always_comb begin: proc_${slave.name}_rr_arb
    integer i;
    logic found_s;
    logic [${num_masters-1}:0] slv_req_s;
    logic [${num_masters-1}:0] prev_grant_s;
    logic [${num_masters-1}:0] next_grant_s;
    logic arb_en_s;

    slv_req_s = {${slv_req}};
    prev_grant_s = {${prev_gnt}};
    arb_en_s = ~(${slv_keep});

    next_grant_s = {prev_grant_s[${num_masters-2}:0], prev_grant_s[${num_masters-1}]}; // 1st candidate is old grant rotated 1 left
    found_s = 1'b0;
    for (i=0; i<${num_masters}; i=i+1) begin
      if (found_s == 1'b0) begin
        if ((slv_req_s & next_grant_s) != ${num_masters}'d0) begin
          found_s = 1'b1;
        end else begin
          next_grant_s = {next_grant_s[${num_masters-2}:0], next_grant_s[${num_masters-1}]}; // rotate 1 left
        end
      end
    end

    {${slv_gnt}} = slv_req_s & next_grant_s & {${num_masters}{(ahb_slv_${slave.name}_hreadyout_i & arb_en_s)}};
  end


  always_ff @(posedge main_clk_i or negedge main_rst_an_i) begin: proc_${slave.name}_gnt
    if (main_rst_an_i == 1'b0) begin
%     for idx, master in enumerate(slave_masters):
      slv_${slave.name}_${master}_gnt_r <= ${ff_dly}1'b${'1' if not idx else '0'};${'  // initial pseudo-grant' if not idx else ''}
%     endfor
    end else begin
      if ({${slv_gnt}} != ${num_masters}'d0) begin
%     for master in slave_masters:
        slv_${slave.name}_${master}_gnt_r <= ${ff_dly}slv_${slave.name}_${master}_gnt_s;
%     endfor
      end
    end
  end


  // Slave '${slave.name}' multiplexer
  always_comb begin: proc_${slave.name}_mux
${slv_sel.get()}

    ahb_slv_${slave.name}_hsel_o = |{${slv_mux}};

    case ({${slv_mux}})  // address phase signals
%      for idx, master in enumerate(reversed(slave_masters)):
      ${num_masters}'b${f"{1<<idx:0{num_masters}b}"}: begin
        ahb_slv_${slave.name}_haddr_o  = mst_${master}_haddr_s;
%        if slave_port.type_.proto.ausertype:
        ahb_slv_${slave.name}_hauser_o = mst_${master}_hauser_s;
%        endif
        ahb_slv_${slave.name}_hwrite_o = mst_${master}_hwrite_s;
        ahb_slv_${slave.name}_hburst_o = mst_${master}_hburst_s;
        ahb_slv_${slave.name}_hsize_o  = mst_${master}_hsize_s;
        ahb_slv_${slave.name}_htrans_o = mst_${master}_htrans_s;
        ahb_slv_${slave.name}_hprot_o  = mst_${master}_hprot_s;
        ahb_slv_${slave.name}_hready_o = mst_${master}_hready_s;
      end

%      endfor
      default: begin
        ahb_slv_${slave.name}_haddr_o  = ${rslvr._get_uint_value(0, mod.addrwidth)};
        ahb_slv_${slave.name}_hwrite_o = ahb_write_read_e;
        ahb_slv_${slave.name}_hburst_o = ahb_burst_single_e;
        ahb_slv_${slave.name}_hsize_o  = ahb_size_word_e;
        ahb_slv_${slave.name}_htrans_o = ahb_trans_idle_e;
%     if slave.proto.hprottype:
        ahb_slv_${slave.name}_hprot_o  = ${rslvr.get_default(slave.proto.hprottype)};
%     endif
%     if slave.proto.ausertype:
        ahb_slv_${slave.name}_hauser_o = ${rslvr.get_default(slave.proto.ausertype)};
%     endif
        ahb_slv_${slave.name}_hready_o = ahb_slv_${slave.name}_hreadyout_i;
      end
    endcase

    case ({${mst_sel}})  // data phase signals
%     for idx, master in enumerate(reversed(slave_masters)):
      ${num_masters}'b${f"{1<<idx:0{num_masters}b}"}: begin
        ahb_slv_${slave.name}_hwdata_o = ahb_mst_${master}_hwdata_i;
      end

%     endfor
      default: begin
        ahb_slv_${slave.name}_hwdata_o = ${rslvr._get_uint_value(0, mod.datawidth)};
      end
    endcase
  end

%   endif
% endfor
</%def>
