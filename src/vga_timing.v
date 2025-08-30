`default_nettype none

module vga_timing (
    input wire clk,
    input wire rst_n,
    input wire cli,
    input wire [3:0] pre_div,
    input wire [2:0] clk_div,
    input wire [2:0] pix_div,
    output wire [4:0] x_pos,
    output wire [3:0] y_pos,
    output reg hsync,
    output reg vsync,
    output wire blank,
    output reg [2:0] counter,
    output reg interrupt
);

// 640x480 60Hz CEA-861, nominally 25.175 MHz pixel clock
// but used with 2.5 clock ticks per pixel
// (clk running at 64 MHz corresponds to 25.6 MHz pixel clock)

`define H_FPORCH 40
`define H_SYNC   41
`define H_BPORCH 47
`define H_NEXT   49

`define V_ROLL   29
`define V_FPORCH (16 * 32)
`define V_SYNC   (16 * 32 + 10)
`define V_BPORCH (16 * 32 + 12)
`define V_NEXT   (17 * 32 + 14)

reg [5:0] x_clk_hi;
reg [2:0] x_clk_lo;
reg [4:0] x_pix_hi;
reg [2:0] x_pix_lo;
reg [3:0] x_pre_lo;
reg [4:0] y_hi;
reg [4:0] y_lo;

always @(posedge clk) begin
    if (!rst_n) begin
        x_clk_hi <= 0;
        x_clk_lo <= 0;
        x_pix_hi <= 0;
        x_pix_lo <= 0;
        x_pre_lo <= 0;
        y_hi <= 0;
        y_lo <= 0;
        hsync <= 0;
        vsync <= 0;
        counter <= 0;
        interrupt <= 0;
    end else begin
        counter <= counter + 1;
        if (x_pre_lo == pre_div) begin
            x_pre_lo <= 0;
            if (x_pix_lo == pix_div) begin
                x_pix_hi <= x_pix_hi + 1;
                x_pix_lo <= 0;
            end else begin
                x_pix_lo <= x_pix_lo + 1;
            end
            if (x_clk_lo == clk_div) begin
                if (x_clk_hi == `H_NEXT) begin
                    x_clk_hi <= 0;
                    x_clk_lo <= 0;
                    x_pix_hi <= 0;
                    x_pix_lo <= 0;
                end else begin
                    x_clk_hi <= x_clk_hi + 1;
                    x_clk_lo <= 0;
                end
                if (x_clk_hi == `H_SYNC) begin
                    if ({y_hi, y_lo} == `V_NEXT) begin
                        y_hi <= 0;
                        y_lo <= 0;
                        interrupt <= 0;
                    end else if (y_lo == `V_ROLL) begin
                        y_hi <= y_hi + 1;
                        y_lo <= 0;
                    end else begin
                        y_lo <= y_lo + 1;
                    end
                    if ({y_hi, y_lo} == `V_FPORCH) begin
                        interrupt <= 1;
                    end
                end
            end else begin
                x_clk_lo <= x_clk_lo + 1;
            end
        end else begin
            x_pre_lo <= x_pre_lo + 1;
        end
        hsync <= !(x_clk_hi >= `H_SYNC && x_clk_hi < `H_BPORCH);
        vsync <= !({y_hi, y_lo} >= `V_SYNC && {y_hi, y_lo} < `V_BPORCH);
        if (cli) interrupt <= 0;
    end
end

assign x_pos = x_pix_hi;
assign y_pos = y_hi[3:0];
assign blank = (x_clk_hi >= `H_FPORCH || {y_hi, y_lo} >= `V_FPORCH);

endmodule
