// Generated register-based fifo
// based on: https://nandland.com/register-based-fifo/
module fifo_regs_no_flags #(
    parameter g_WIDTH = 8,  // Width of the FIFO
    parameter g_DEPTH = 32  // Depth of the FIFO
)(
    input wire i_rst_sync,                // Synchronous reset
    input wire i_clk,                     // Clock signal

    // FIFO Write Interface
    input wire i_wr_en,                   // Write enable
    input wire [g_WIDTH-1:0] i_wr_data,   // Write data
    output wire o_full,                   // Full flag

    // FIFO Read Interface
    input wire i_rd_en,                   // Read enable
    output wire [g_WIDTH-1:0] o_rd_data,  // Read data
    output wire o_empty                   // Empty flag
);

    // Internal FIFO storage
    reg [g_WIDTH-1:0] r_FIFO_DATA [0:g_DEPTH-1];

    // Write and read pointers
    reg [$clog2(g_DEPTH)-1:0] r_WR_INDEX = 0;
    reg [$clog2(g_DEPTH)-1:0] r_RD_INDEX = 0;

    // FIFO count
    reg [$clog2(g_DEPTH):0] r_FIFO_COUNT = 0;

    // Full and empty flags
    wire w_FULL;
    wire w_EMPTY;

    // Write logic
    always @(posedge i_clk) begin
        if (i_rst_sync)
        begin
            r_FIFO_COUNT <= 0;
            r_WR_INDEX <= 0;
            r_RD_INDEX <= 0;
        end else begin
            // Update FIFO count
            if (i_wr_en && !i_rd_en) begin
                r_FIFO_COUNT <= r_FIFO_COUNT + 1;
            end else if (!i_wr_en && i_rd_en) begin
                r_FIFO_COUNT <= r_FIFO_COUNT - 1;
            end

            // Update write pointer
            if (i_wr_en && !w_FULL) begin
                r_FIFO_DATA[r_WR_INDEX] <= i_wr_data;
                if (r_WR_INDEX == g_DEPTH-1) begin
                    r_WR_INDEX <= 0;
                end else begin
                    r_WR_INDEX <= r_WR_INDEX + 1;
                end
            end

            // Update read pointer
            if (i_rd_en && !w_EMPTY) begin
                if (r_RD_INDEX == g_DEPTH-1) begin
                    r_RD_INDEX <= 0;
                end else begin
                    r_RD_INDEX <= r_RD_INDEX + 1;
                end
            end
        end
    end

    // Output read data
    assign o_rd_data = r_FIFO_DATA[r_RD_INDEX];

    // Full and empty flags
    assign w_FULL = (r_FIFO_COUNT == g_DEPTH);
    assign w_EMPTY = (r_FIFO_COUNT == 0);

    assign o_full = w_FULL;
    assign o_empty = w_EMPTY;

    // Assertions for simulation (not synthesizable)
    // synthesis translate_off
    always @(posedge i_clk) begin
        if (i_wr_en && w_FULL) begin
            $fatal("ASSERT FAILURE - FIFO IS FULL AND BEING WRITTEN");
        end
        if (i_rd_en && w_EMPTY) begin
            $fatal("ASSERT FAILURE - FIFO IS EMPTY AND BEING READ");
        end
    end
    // synthesis translate_on

endmodule