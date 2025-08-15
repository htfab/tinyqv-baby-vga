`default_nettype none

module pll #(
    parameter PREDIV=1,
    parameter MULT=8,
    parameter DIV=8
)(
    input  wire clk_in,
    input  wire reset,
    output wire clk_out,
    output wire locked
);

wire clk_pll_in, clk_pll_fb_in, clk_pll_out, clk_pll_fb_out;
wire _clk_pll_out1, _clk_pll_out2, _clk_pll_out3, _clk_pll_out4, _clk_pll_out5;
wire _pll_do, _pll_drdy;

IBUF ib(.I(clk_in), .O(clk_pll_in));
BUFG fb(.I(clk_pll_fb_out), .O(clk_pll_fb_in));
BUFG ob(.I(clk_pll_out), .O(clk_out));

PLLE2_ADV #(
    .BANDWIDTH            ("OPTIMIZED"),
    .COMPENSATION         ("ZHOLD"),
    .DIVCLK_DIVIDE        (PREDIV),
    .CLKFBOUT_MULT        (MULT),
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (DIV),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKIN1_PERIOD        (10.0)
) plle2(
    .CLKFBOUT            (clk_pll_fb_out),
    .CLKOUT0             (clk_pll_out),
    .CLKOUT1             (_clk_pll_out1),
    .CLKOUT2             (_clk_pll_out2),
    .CLKOUT3             (_clk_pll_out3),
    .CLKOUT4             (_clk_pll_out4),
    .CLKOUT5             (_clk_pll_out5),
    .CLKFBIN             (clk_pll_fb_in),
    .CLKIN1              (clk_pll_in),
    .CLKIN2              (1'b0),
    .CLKINSEL            (1'b1),
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (_pll_do),
    .DRDY                (_pll_drdy),
    .DWE                 (1'b0),
    .LOCKED              (locked),
    .PWRDWN              (1'b0),
    .RST                 (reset));

endmodule
