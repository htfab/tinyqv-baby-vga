`default_nettype none

module vga_timing (
    input wire clk,
    input wire rst_n,
    output reg [10:0] x,
    output reg [9:0] y,
    output reg hsync,
    output reg vsync,
    output wire blank
);

// 720p 60Hz CVT-RB (64 MHz pixel clock)
// restricted to 1025x513 area

`define H_FPORCH 1025
`define H_SYNC   1200
`define H_BPORCH 1232
`define H_NEXT   1439

`define V_FPORCH 513
`define V_SYNC   619
`define V_BPORCH 624
`define V_NEXT   740

always @(posedge clk) begin
    if (!rst_n) begin
        x <= 0;
        y <= 0;
        hsync <= 0;
        vsync <= 0;
    end else begin
        if (x == `H_NEXT) begin
            x <= 0;
        end else begin
            x <= x + 1;
        end
        if (x == `H_SYNC) begin
            if(y == `V_NEXT) begin
                y <= 0;
            end else begin
                y <= y + 1;
            end
        end
        hsync <= (x >= `H_SYNC && x < `H_BPORCH);
        vsync <= !(y >= `V_SYNC && y < `V_BPORCH);
    end
end

assign blank = (x >= `H_FPORCH || y >= `V_FPORCH);

endmodule