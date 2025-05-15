// Gate-level netlist for complex_design using Sky130 cells

module complex_design (
  clk,
  rst,
  a,
  b,
  c,
  q_out
);

  // Port declarations
  input clk;
  input rst;
  input a;
  input b;
  input c;
  output q_out;

  // Internal wires
  wire a_i;
  wire b_i;
  wire c_i;
  wire clk_i;
  wire rst_i;
  wire rst_n; // Inverted reset for active-low reset pins
  wire ff1_q;
  wire and_out;
  wire or_out;
  wire buf_out;
  wire ff2_q;
  wire xor_out;
  wire not_out;
  wire ff3_q;
  wire q_out_i;

  // Input buffers
  sky130_fd_sc_hd__buf_1 U1 (.A(a), .X(a_i));
  sky130_fd_sc_hd__buf_1 U2 (.A(b), .X(b_i));
  sky130_fd_sc_hd__buf_1 U3 (.A(c), .X(c_i));
  sky130_fd_sc_hd__buf_1 U4 (.A(clk), .X(clk_i));
  sky130_fd_sc_hd__buf_1 U5 (.A(rst), .X(rst_i));
  
  // Create inverted reset (active-low)
  sky130_fd_sc_hd__inv_1 U_RST_INV (.A(rst_i), .Y(rst_n));

  // First flip-flop - using Sky130 DFF with reset
  sky130_fd_sc_hd__dfrtp_1 FF1_reg (
    .D(a_i),
    .CLK(clk_i),
    .RESET_B(rst_n), // Active-low reset
    .Q(ff1_q)
  );

  // Combinational logic stage 1
  sky130_fd_sc_hd__and2_1 U6 (.A(ff1_q), .B(b_i), .X(and_out));
  sky130_fd_sc_hd__or2_1 U7 (.A(and_out), .B(c_i), .X(or_out));
  
  // Buffer stage
  sky130_fd_sc_hd__buf_1 U8 (.A(or_out), .X(buf_out));

  // Second flip-flop
  sky130_fd_sc_hd__dfrtp_1 FF2_reg (
    .D(buf_out),
    .CLK(clk_i),
    .RESET_B(rst_n), // Active-low reset
    .Q(ff2_q)
  );

  // Additional combinational logic
  sky130_fd_sc_hd__xor2_1 U9 (.A(ff2_q), .B(a_i), .X(xor_out));
  sky130_fd_sc_hd__inv_1 U10 (.A(xor_out), .Y(not_out));

  // Third flip-flop
  sky130_fd_sc_hd__dfrtp_1 FF3_reg (
    .D(not_out),
    .CLK(clk_i),
    .RESET_B(rst_n), // Active-low reset
    .Q(ff3_q)
  );

  // Output assignment
  sky130_fd_sc_hd__buf_1 U11 (.A(ff3_q), .X(q_out_i));
  assign q_out = q_out_i;

endmodule
