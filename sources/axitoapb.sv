`timescale 1ns/1ps

module axitoapb(
    input clk, //positive edge triggered clock
    input reset, //asynchronous reset

    //AXI Write Addr
    input [1:0] awaddr, //AXI write address
    input awvalid, //AXI write address valid signal
    output reg awready, //AXI write ready signal

    //AXI Write Data
    input [3:0] wdata, //AXI write data
    input wvalid, //AXI write valid signal
    output reg wready, //AXI write ready signal

    //AXI Write Resp
    output reg bvalid, //AXI write response valid signal
    output reg bresp, //AXI write response
    input bready, //AXI write response ready signal

    //APB
    output reg [1:0] paddr, //APB address
    output reg pwrite, //APB write signal
    output reg [3:0] pwdata, //APB write data
    output reg psel, //APB select signal
    input pready //APB ready signal
);


endmodule
