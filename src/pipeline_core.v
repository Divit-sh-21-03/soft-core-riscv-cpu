`timescale 1ns / 1ps

module pipeline_core(
    input clk,
    input rst,
    output reg [7:0] led
);




// Wire declarations
// IF stage
wire [31:0] pc_current, pc_next, pc_plus4;
wire [31:0] instruction_if;
wire PCWrite, IF_ID_Write;

// IF/ID pipeline register
wire [31:0] pc_id, instruction_id;

// ID stage
wire [4:0] rs1_id, rs2_id, rd_id;
wire [31:0] read_data1_id, read_data2_id, immediate_id;
wire [2:0] funct3_id;
wire funct7_id;
wire RegWrite_id, MemRead_id, MemWrite_id, Branch_id, ALUSrc_id, MemToReg_id;
wire [1:0] ALUOp_id;
wire Control_flush;

// ID/EX pipeline register
wire RegWrite_ex, MemRead_ex, MemWrite_ex, Branch_ex, ALUSrc_ex, MemToReg_ex;
wire [1:0] ALUOp_ex;
wire [31:0] pc_ex, read_data1_ex, read_data2_ex, immediate_ex, instruction_ex;
wire [4:0] rs1_ex, rs2_ex, rd_ex;
wire [2:0] funct3_ex;
wire funct7_ex;

// EX stage
wire [31:0] alu_input_a, alu_input_b, alu_result_ex;
wire [3:0] alu_control_sig;
wire zero_ex;
wire [1:0] ForwardA, ForwardB;
wire branch_taken;
wire [31:0] branch_target;

// EX/MEM pipeline register
wire RegWrite_mem, MemRead_mem, MemWrite_mem, MemToReg_mem;
wire [31:0] alu_result_mem, write_data_mem, instruction_mem;
wire [4:0] rd_mem;

// MEM stage
wire [31:0] mem_read_data;

// MEM/WB pipeline register
wire RegWrite_wb, MemToReg_wb;
wire [31:0] alu_result_wb, mem_data_wb, instruction_wb;
wire [4:0] rd_wb;

// WB stage
wire [31:0] write_back_data;

// ====== IF STAGE ======
assign pc_plus4 = pc_current + 4;
assign pc_next = branch_taken ? branch_target : pc_plus4;

program_counter PC(
    .clk(clk),
    .rst(rst),
    .PCWrite(PCWrite),
    .pc_next(pc_next),
    .pc_current(pc_current)
);

instruction_memory IMEM(
    .address(pc_current),
    .instruction(instruction_if)
);

// ====== IF/ID PIPELINE REGISTER ======
if_id_reg IF_ID(
    .clk(clk),
    .rst(rst),
    .IF_ID_Write(IF_ID_Write),
    .flush(branch_taken),
    .pc_in(pc_current),
    .instruction_in(instruction_if),
    .pc_out(pc_id),
    .instruction_out(instruction_id)
);

// ====== ID STAGE ======
assign rs1_id = instruction_id[19:15];
assign rs2_id = instruction_id[24:20];
assign rd_id = instruction_id[11:7];
assign funct3_id = instruction_id[14:12];
assign funct7_id = instruction_id[30];

control_unit CTRL(
    .opcode(instruction_id[6:0]),
    .RegWrite(RegWrite_id),
    .MemRead(MemRead_id),
    .MemWrite(MemWrite_id),
    .Branch(Branch_id),
    .ALUSrc(ALUSrc_id),
    .MemToReg(MemToReg_id),
    .ALUOp(ALUOp_id)
);

register_file RF(
    .clk(clk),
    .rst(rst),
    .read_addr1(rs1_id),
    .read_addr2(rs2_id),
    .write_addr(rd_wb),
    .write_data(write_back_data),
    .RegWrite(RegWrite_wb),
    .read_data1(read_data1_id),
    .read_data2(read_data2_id)
);

imm_gen IMM_GEN(
    .instruction(instruction_id),
    .immediate(immediate_id)
);

hazard_unit HAZARD(
    .rs1_id(rs1_id),
    .rs2_id(rs2_id),
    .rd_ex(rd_ex),
    .MemRead_ex(MemRead_ex),
    .branch_taken(branch_taken),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .Control_flush(Control_flush)
);

// ====== ID/EX PIPELINE REGISTER ======
id_ex_reg ID_EX(
    .clk(clk),
    .rst(rst),
    .flush(Control_flush),
    .RegWrite_in(Control_flush ? 1'b0 : RegWrite_id),
    .MemRead_in(Control_flush ? 1'b0 : MemRead_id),
    .MemWrite_in(Control_flush ? 1'b0 : MemWrite_id),
    .Branch_in(Control_flush ? 1'b0 : Branch_id),
    .ALUSrc_in(Control_flush ? 1'b0 : ALUSrc_id),
    .MemToReg_in(Control_flush ? 1'b0 : MemToReg_id),
    .ALUOp_in(Control_flush ? 2'b00 : ALUOp_id),
    .pc_in(pc_id),
    .read_data1_in(read_data1_id),
    .read_data2_in(read_data2_id),
    .immediate_in(immediate_id),
    .rs1_in(rs1_id),
    .rs2_in(rs2_id),
    .rd_in(rd_id),
    .funct3_in(funct3_id),
    .funct7_in(funct7_id),
    .instruction_in(instruction_id),
    .RegWrite_out(RegWrite_ex),
    .MemRead_out(MemRead_ex),
    .MemWrite_out(MemWrite_ex),
    .Branch_out(Branch_ex),
    .ALUSrc_out(ALUSrc_ex),
    .MemToReg_out(MemToReg_ex),
    .ALUOp_out(ALUOp_ex),
    .pc_out(pc_ex),
    .read_data1_out(read_data1_ex),
    .read_data2_out(read_data2_ex),
    .immediate_out(immediate_ex),
    .rs1_out(rs1_ex),
    .rs2_out(rs2_ex),
    .rd_out(rd_ex),
    .funct3_out(funct3_ex),
    .funct7_out(funct7_ex),
    .instruction_out(instruction_ex)
);

// ====== EX STAGE ======
forwarding_unit FORWARD(
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex),
    .rd_mem(rd_mem),
    .rd_wb(rd_wb),
    .RegWrite_mem(RegWrite_mem),
    .RegWrite_wb(RegWrite_wb),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

// Forward mux A
assign alu_input_a = (ForwardA == 2'b00) ? read_data1_ex :
                     (ForwardA == 2'b01) ? write_back_data :
                     (ForwardA == 2'b10) ? alu_result_mem : read_data1_ex;

// Forward mux B and ALUSrc mux
wire [31:0] forwarded_b = (ForwardB == 2'b00) ? read_data2_ex :
                          (ForwardB == 2'b01) ? write_back_data :
                          (ForwardB == 2'b10) ? alu_result_mem : read_data2_ex;

assign alu_input_b = ALUSrc_ex ? immediate_ex : forwarded_b;

alu_control ALU_CTRL(
    .ALUOp(ALUOp_ex),
    .funct3(funct3_ex),
    .funct7(funct7_ex),
    .alu_control_out(alu_control_sig)
);

alu ALU(
    .a(alu_input_a),
    .b(alu_input_b),
    .alu_control(alu_control_sig),
    .result(alu_result_ex),
    .zero(zero_ex)
);

// Branch logic
assign branch_taken = Branch_ex & zero_ex;
assign branch_target = pc_ex + immediate_ex;

// ====== EX/MEM PIPELINE REGISTER ======
ex_mem_reg EX_MEM(
    .clk(clk),
    .rst(rst),
    .RegWrite_in(RegWrite_ex),
    .MemRead_in(MemRead_ex),
    .MemWrite_in(MemWrite_ex),
    .MemToReg_in(MemToReg_ex),
    .alu_result_in(alu_result_ex),
    .write_data_in(forwarded_b),
    .rd_in(rd_ex),
    .instruction_in(instruction_ex),
    .RegWrite_out(RegWrite_mem),
    .MemRead_out(MemRead_mem),
    .MemWrite_out(MemWrite_mem),
    .MemToReg_out(MemToReg_mem),
    .alu_result_out(alu_result_mem),
    .write_data_out(write_data_mem),
    .rd_out(rd_mem),
    .instruction_out(instruction_mem)
);

// ====== MEM STAGE ======
data_memory DMEM(
    .clk(clk),
    .address(alu_result_mem),
    .write_data(write_data_mem),
    .MemRead(MemRead_mem),
    .MemWrite(MemWrite_mem),
    .read_data(mem_read_data)
);

// ====== MEM/WB PIPELINE REGISTER ======
mem_wb_reg MEM_WB(
    .clk(clk),
    .rst(rst),
    .RegWrite_in(RegWrite_mem),
    .MemToReg_in(MemToReg_mem),
    .alu_result_in(alu_result_mem),
    .mem_data_in(mem_read_data),
    .rd_in(rd_mem),
    .instruction_in(instruction_mem),
    .RegWrite_out(RegWrite_wb),
    .MemToReg_out(MemToReg_wb),
    .alu_result_out(alu_result_wb),
    .mem_data_out(mem_data_wb),
    .rd_out(rd_wb),
    .instruction_out(instruction_wb)
);

// ====== WB STAGE ======
assign write_back_data = MemToReg_wb ? mem_data_wb : alu_result_wb;

// ====== LED CONTROL LOGIC ======
reg [25:0] led_counter;
reg [2:0] instruction_type;
reg program_complete;

// Detect when program is complete (PC reaches end or stuck)
reg [31:0] prev_pc;
reg [3:0] stuck_counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        prev_pc <= 32'h0;
        stuck_counter <= 4'h0;
        program_complete <= 1'b0;
    end else begin
        if (pc_current == prev_pc && pc_current >= 32'h24) begin // PC 0x24 is after last instruction
            stuck_counter <= stuck_counter + 1;
            if (stuck_counter >= 4'hF)
                program_complete <= 1'b1;
        end else begin
            stuck_counter <= 4'h0;
        end
        prev_pc <= pc_current;
    end
end

// Instruction type encoding
always @(*) begin
    case (instruction_id[6:0])
        7'b0010011: instruction_type = 3'b001; // I-type (ADDI)
        7'b0110011: instruction_type = 3'b010; // R-type (ADD, SUB, AND)
        7'b0000011: instruction_type = 3'b011; // Load
        7'b0100011: instruction_type = 3'b100; // Store
        7'b1100011: instruction_type = 3'b101; // Branch
        default:    instruction_type = 3'b000; // NOP/Unknown
    endcase
end

// LED patterns based on processor state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        led <= 8'b00000000;
        led_counter <= 26'b0;
    end else begin
        led_counter <= led_counter + 1;
        
        if (program_complete) begin
            // Show completion pattern - all LEDs chase pattern
            case (led_counter[22:20])
                3'b000: led <= 8'b10000000;
                3'b001: led <= 8'b01000000;
                3'b010: led <= 8'b00100000;
                3'b011: led <= 8'b00010000;
                3'b100: led <= 8'b00001000;
                3'b101: led <= 8'b00000100;
                3'b110: led <= 8'b00000010;
                3'b111: led <= 8'b00000001;
            endcase
        end else begin
            // Active processing pattern
            led[7] <= led_counter[23];                       // Heartbeat (slow blink)
            led[6] <= (pc_current != 32'h00000000);         // PC active
            led[5] <= (ALUOp_ex != 2'b00);                  // ALU operation
            led[4] <= (MemRead_mem | MemWrite_mem);         // Memory access
            led[3] <= RegWrite_wb & (rd_wb != 5'b0);        // Register write
            led[2:0] <= instruction_type;                   // Instruction type
        end
    end
end

// Debug display (register values after completion)
always @(posedge clk) begin
    if (program_complete && led_counter[23:0] == 24'h0) begin
        $display("=== PROGRAM COMPLETE ===");
        $display("Final register values:");
        $display("x3 = %0d (expected: 10)", $signed(RF.registers[3]));
        $display("x4 = %0d (expected: 4)",  $signed(RF.registers[4]));
        $display("x5 = %0d (expected: 3)",  $signed(RF.registers[5]));
        $display("x6 = %0d (expected: 7)",  $signed(RF.registers[6]));
        $display("x7 = %0d (expected: 56)", $signed(RF.registers[7]));
        
        if (RF.registers[3] == 32'd10 && RF.registers[4] == 32'd4 && 
            RF.registers[5] == 32'd3 && RF.registers[6] == 32'd7 && 
            RF.registers[7] == 32'd56) begin
            $display("✓ ARITHMETIC TEST PASSED!");
        end else begin
            $display("✗ ARITHMETIC TEST FAILED!");
        end
    end
end

endmodule