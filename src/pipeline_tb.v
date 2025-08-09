`timescale 1ns / 1ps

module pipeline_tb();

reg clk;
reg rst;

// Instantiate the pipeline core
pipeline_core dut(
    .clk(clk),
    .rst(rst)
);

// Clock generation (100 MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period = 100 MHz
end

// Task to load COE file into instruction memory
task load_coe;
    input [255*8:0] filename;
    begin
        $display("Loading instruction memory from: %s", filename);
        dut.IMEM.load_instructions(filename);
        // Debug: print first 8 instructions
        $display("First 8 instructions loaded:");
        $display("0x00: %h", dut.IMEM.mem[0]);
        $display("0x04: %h", dut.IMEM.mem[1]);
        $display("0x08: %h", dut.IMEM.mem[2]);
        $display("0x0C: %h", dut.IMEM.mem[3]);
        $display("0x10: %h", dut.IMEM.mem[4]);
        $display("0x14: %h", dut.IMEM.mem[5]);
        $display("0x18: %h", dut.IMEM.mem[6]);
        $display("0x1C: %h", dut.IMEM.mem[7]);
    end
endtask

// Task to check arithmetic test results
task check_arith;
    begin
        $display("Checking arithmetic test results...");
        if (dut.RF.registers[3] == 32'd10 && 
            dut.RF.registers[4] == 32'd4 && 
            dut.RF.registers[5] == 32'd3 && 
            dut.RF.registers[6] == 32'd7 && 
            dut.RF.registers[7] == 32'd56) begin
            $display("ARITHMETIC TEST: PASS");
            $display("x3=%d, x4=%d, x5=%d, x6=%d, x7=%d", 
                     dut.RF.registers[3], dut.RF.registers[4], dut.RF.registers[5], 
                     dut.RF.registers[6], dut.RF.registers[7]);
        end else begin
            $display("ARITHMETIC TEST: FAIL");
            $display("Expected: x3=10, x4=4, x5=3, x6=7, x7=56");
            $display("Got: x3=%d, x4=%d, x5=%d, x6=%d, x7=%d", 
                     dut.RF.registers[3], dut.RF.registers[4], dut.RF.registers[5], 
                     dut.RF.registers[6], dut.RF.registers[7]);
        end
    end
endtask

// Task to check sort test results
task check_sort;
    begin
        $display("Checking sort test results...");
        if (dut.DMEM.mem[0] <= dut.DMEM.mem[1] && 
            dut.DMEM.mem[1] <= dut.DMEM.mem[2] && 
            dut.DMEM.mem[2] <= dut.DMEM.mem[3]) begin
            $display("SORT TEST: PASS");
            $display("Sorted data: %d, %d, %d, %d", 
                     dut.DMEM.mem[0], dut.DMEM.mem[1], dut.DMEM.mem[2], dut.DMEM.mem[3]);
        end else begin
            $display("SORT TEST: FAIL");
            $display("Data not properly sorted: %d, %d, %d, %d", 
                     dut.DMEM.mem[0], dut.DMEM.mem[1], dut.DMEM.mem[2], dut.DMEM.mem[3]);
        end
    end
endtask

// Task to check prime test results
task check_prime;
    integer i;
    reg [31:0] expected_primes [0:9];
    reg pass;
    begin
        // Expected first 10 prime numbers
        expected_primes[0] = 2;
        expected_primes[1] = 3;
        expected_primes[2] = 5;
        expected_primes[3] = 7;
        expected_primes[4] = 11;
        expected_primes[5] = 13;
        expected_primes[6] = 17;
        expected_primes[7] = 19;
        expected_primes[8] = 23;
        expected_primes[9] = 29;
        
        $display("Checking prime test results...");
        pass = 1;
        for (i = 0; i < 10; i = i + 1) begin
            if (dut.DMEM.mem[i] != expected_primes[i]) begin
                pass = 0;
            end
        end
        
        if (pass) begin
            $display("PRIME TEST: PASS");
            $display("First 10 primes found correctly");
        end else begin
            $display("PRIME TEST: FAIL");
            $display("Expected primes: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29");
            $display("Found: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d",
                     dut.DMEM.mem[0], dut.DMEM.mem[1], dut.DMEM.mem[2], 
                     dut.DMEM.mem[3], dut.DMEM.mem[4], dut.DMEM.mem[5], 
                     dut.DMEM.mem[6], dut.DMEM.mem[7], dut.DMEM.mem[8], 
                     dut.DMEM.mem[9]);
        end
    end
endtask

// Main test sequence
initial begin
    $display("Starting RISC-V Pipeline Processor Tests");
    $display("========================================");
    
    // Initialize
    rst = 1;
    #20;
    rst = 0;
    #10;
    
    // Test 1: Arithmetic test
    $display("\\nTest 1: Arithmetic Operations");
    $display("-----------------------------");
    load_coe("memory/arith.coe");
    #10;
    
    // Run for 100 cycles
    repeat(100) @(posedge clk);
    check_arith();
    
    // Test 2: Bubble sort test
    $display("\\nTest 2: Bubble Sort Algorithm");
    $display("-----------------------------");
    rst = 1;
    #20;
    rst = 0;
    #10;
    
    load_coe("memory/sort.coe");
    #10;
    
    // Run for 500 cycles
    repeat(500) @(posedge clk);
    check_sort();
    
    // Test 3: Prime detection test
    $display("\\nTest 3: Prime Number Detection");
    $display("------------------------------");
    rst = 1;
    #20;
    rst = 0;
    #10;
    
    load_coe("memory/prime.coe");
    #10;
    
    // Run for 800 cycles
    repeat(800) @(posedge clk);
    check_prime();
    
    $display("\\n========================================");
    $display("All tests completed");
    $display("========================================");
    
    #100;
    $finish;
end



endmodule