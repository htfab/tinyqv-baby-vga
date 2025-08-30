`default_nettype none

module fpga_top(
    input wire clk,
    input wire btnC,
    input wire btnU,
    input wire btnL,
    input wire btnR,
    input wire btnD,
    input wire [15:0] sw,
    input wire [7:4] JCin,
    output wire [15:0] led,
    output wire [7:0] JB,
    output wire [3:0] JCout,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire hsync,
    output wire vsync
);

reg rst_n;
wire clk_proj;
wire pll_locked;

pll #(
    // 64 MHz
    .PREDIV(5),
    .MULT(48),
    .DIV(15)

    // 25 MHz
    //.PREDIV(4),
    //.MULT(8),
    //.DIV(8)

    // 6.25 MHz
    //.PREDIV(16),
    //.MULT(8),
    //.DIV(8)
) i_pll (
    .clk_in(clk),
    .clk_out(clk_proj),
    .reset(btnU),
    .locked(pll_locked)
);

initial begin
    rst_n <= 0;
end

always @(posedge clk_proj) begin
    rst_n <= ~btnC;
end

wire [3:0] _uio_out_ignore;
wire [7:0] _uio_oe_ignore;
wire [15:0] debug;

tt_um_tqv_peripheral_harness peri (
    .ui_in(8'b0),
    .uo_out(JB),
    .uio_in({JCin, 4'b0}),
    .uio_out({_uio_out_ignore, JCout}),
    .uio_oe(_uio_oe_ignore),
    .ena(1'b1),
    .clk(clk_proj),
    .rst_n(rst_n)
    //.debug
);

assign vgaRed = {JB[0], JB[4], JB[0], JB[4]};
assign vgaGreen = {JB[1], JB[5], JB[1], JB[5]};
assign vgaBlue = {JB[2], JB[6], JB[2], JB[6]};
assign hsync = JB[7];
assign vsync = JB[3];
assign led = sw ^ {JB, JCin, JCout};
//assign led = sw ^ debug;

endmodule
