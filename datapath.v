module datapath(clk,readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads
		,writenum,write,sximm8,sximm5, mdata, PC,C,Z_out);

input clk;
input [15:0] sximm8, sximm5, mdata;
input [7:0] PC;
input write, loada, loadb, asel, bsel, loadc, loads;
input [2:0] readnum, writenum;
input [1:0] shift, ALUop, vsel;
output [15:0] C;
output [2:0] Z_out; 
wire [2:0] Z;
wire [15:0] data_in, data_out, aout, bout, sout, Bin, Ain, ALUout;


vMux4 MUX4(C,{8'b00000000, PC}, sximm8,mdata ,vsel,data_in); 

regfile REGFILE(data_in,writenum,write,readnum,clk,data_out);

vRegLoadEnable RA(clk,loada,data_out,aout);

vRegLoadEnable RB(clk,loadb,data_out,bout);

shifter SHIFT(bout,shift,sout); 

vMux2 MUX2b(sout,sximm5,bsel,Bin);

vMux2 MUX2a(aout,16'b0000000000000000,asel,Ain);

ALU alu(Ain, Bin, ALUop,ALUout, Z); //zZ, zN, zO

vRegLoadEnable RC(clk,loadc,ALUout,C);

vRegLoadEnable #(3) RStatus(clk,loads,Z,Z_out);

endmodule

//Mux that takes 4 inputs with a 2 bit select and defaults to 16 bit wid input an outputs if not specified.
//Output is assigned to module 
module vMux4(a0,a1,a2, a3, select,out);
input [15:0] a3, a2, a1,a0; //Inputs 
input [1:0] select;
output [15:0] out;
reg [15:0] outTemp; 
always@(*) begin
case(select)
2'b00: outTemp=a0;
2'b01: outTemp=a1;
2'b10: outTemp=a2;
2'b11: outTemp=a3;
endcase
end

assign out = outTemp;
endmodule

module vMux2(a0,a1, select,out);
input [15:0] a1,a0; //Inputs 
input select;
output [15:0] out;
reg [15:0] outTemp; 
always@(*) begin
case(select)
0: outTemp=a0;
1: outTemp=a1;

endcase
end

assign out = outTemp;
endmodule
