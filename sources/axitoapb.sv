`timescale 1ns/1ps

module axitoapb(
    input clk,
    input reset,

    //AXI Write Addr
    input [1:0] awaddr,
    input awvalid,
    output reg awready,

    //AXI Write Data
    input [3:0] wdata,
    input wvalid,
    input wlast,
    output reg wready,

    //AXI Write Resp
    output reg bvalid,
    output reg bresp,
    input bready,

    //AXI Read Addr
    // input araddr,
    // input arvalid
    // output arready,

    //AXI Read Data
    // output rdata,
    // output rvalid,
    // input rready,

    //APB
    output reg [1:0] paddr,
    output reg pwrite,
    output reg [3:0] pwdata,
    output reg psel,
    input pready
    // input prdata
);

    reg [3:0] data[5];
    reg [1:0] addr;
    reg [2:0] count;
    reg [2:0] rev_count;

    reg [3:0] data_q[5];
    reg [1:0] addr_q;
    reg [4:0] curr_state, next_state;
    reg [2:0] count_q;
    reg [2:0] rev_count_q;

    integer i;

    parameter IDLE = 5'b00001, WR_ADDR = 5'b00010, WR_DATA = 5'b00100, WR_RESP = 5'b01000, APB_WR = 5'b10000;

    always@(posedge clk) begin
        if (reset) begin
            curr_state <= IDLE;
            for (i = 0; i < 5; i++)
                data_q[i] <= 4'b0;
            addr_q <= 2'b0;
            count_q <= 0;
            rev_count_q <= 0;
        end
        else begin
            curr_state <= next_state;
            for (i = 0; i < 5; i++)
                data_q[i] <= data[i];
            addr_q <= addr;
            count_q <= count;
            rev_count_q <= rev_count;
        end
    end

    //FSM
    always @(*) begin
        count = count_q;
        case (curr_state) 
            IDLE: begin
                //control signals
                pwrite = 0;
                awready = 0;
                wready = 0;
                count = 0;
                rev_count = 0;
                //state update
                if (awvalid)
                    next_state = WR_ADDR;
                else
                    next_state = IDLE;
            end

            WR_ADDR: begin
                pwrite = 0;
                psel = 0;
                if (awvalid) begin
                    addr = awaddr;
                    awready = 1;
                    next_state = WR_DATA;
                end
                else begin
                    addr = addr_q;
                    awready = 0;
                    next_state = WR_ADDR;
                end
            end

            WR_DATA: begin
                pwrite = 0;
                psel = 0;
                awready = 0;
                if (wvalid) begin
                    count = count_q + 1;
                    data[count_q] = wdata;
                    wready = 1;
                    if (wlast)
                        next_state = WR_RESP;
                    else
                        next_state = WR_DATA;
                end
                else begin
                    //data[count_q] = data_q[count_q];
                    wready = 0;
                    next_state = WR_DATA;
                end
            end

            WR_RESP: begin
                pwrite = 0;
                psel = 0;
                awready = 0;
                wready = 0;
                bvalid = 1;
                if (bready) begin
                    bresp = 1;
                    next_state = APB_WR;
                end
                else begin
                    bresp = 0;
                    next_state = WR_RESP;
                end
            end

            APB_WR: begin
                if (pready) begin
                    rev_count = rev_count_q + 1;
                    paddr = addr_q + rev_count_q - 1;
                    pwdata = data_q[rev_count_q - 1];
                    psel = 1;
                    if ((count_q - rev_count_q) == 0) 
                        next_state = IDLE;
                    else
                        next_state = APB_WR;
                end
                else begin
                    next_state = APB_WR;
                end

            end
        endcase
    end



endmodule
