module mbooth16bit(a, b, p);
    input [15:0] a, b;
    output reg [31:0] p;

    wire z;
	wire [32:0] p1_shift;
	wire [32:0] p1_final [7:0];
	wire [16:0] a1;
	wire [16:0] a1_not, a1_double, a1_double_not;
	
	assign a1[15:0] = a[15:0];
	assign a1[16] = a[15];	
	assign p1_shift = 33'b0;
	assign z = 1'b0;
	
	a1_variants av1 (.a1(a1), .a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not));
	partialProduct pp1 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[1]), .b0(b[0]), .p1_shift(p1_shift), .zin(z), .p1_final(p1_final[0]));
	partialProduct pp2 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[3]), .b0(b[2]), .p1_shift(p1_final[0]), .zin(b[1]), .p1_final(p1_final[1]));
	partialProduct pp3 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[5]), .b0(b[4]), .p1_shift(p1_final[1]), .zin(b[3]), .p1_final(p1_final[2]));
	partialProduct pp4 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[7]), .b0(b[6]), .p1_shift(p1_final[2]), .zin(b[5]), .p1_final(p1_final[3]));
	partialProduct pp5 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[9]), .b0(b[8]), .p1_shift(p1_final[3]), .zin(b[7]), .p1_final(p1_final[4]));
	partialProduct pp6 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[11]), .b0(b[10]), .p1_shift(p1_final[4]), .zin(b[9]), .p1_final(p1_final[5]));
	partialProduct pp7 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[13]), .b0(b[12]), .p1_shift(p1_final[5]), .zin(b[11]), .p1_final(p1_final[6]));
	partialProduct pp8 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[15]), .b0(b[14]), .p1_shift(p1_final[6]), .zin(b[13]), .p1_final(p1_final[7]));
	// more modules of partialProduct can be added to multiply numbers with more number of bits
	
	always@(p1_final[7])
	begin
	p[31:0] = p1_final[7];	
	end
endmodule

// deciding whether to send a1 or -a1 or 2*a1 or -2*a1 
module a1_variants (a1, a1_not, a1_double, a1_double_not);
	input [16:0] a1;
	output [16:0] a1_not, a1_double, a1_double_not;
	
	assign a1_not = ~a1;
	shift17 s170 (.a1(a1), .a1_double(a1_double));
	assign a1_double_not = ~a1_double;	
endmodule

module partialProduct(a1, a1_not, a1_double, a1_double_not, b1, b0, p1_shift, zin, p1_final);
	input [16:0] a1, a1_not, a1_double, a1_double_not;
	input b0, b1;
	input [32:0] p1_shift;
	input zin;
	output [32:0] p1_final;
	
	wire cin;
	wire cin_con;
	wire [16:0] ain;
	wire [16:0] cout;
	wire [32:0] p1_add;
	wire [32:0] p1_final;
	
	cin_con cc0 (.b1(b1), .b0(b0), .zin(zin), .cin_con(cin_con));
	mux21 m00 (.Y(cin), .D0(1'b0), .D1(1'b1), .S(cin_con));
	a1_con a10 (.a1(a1), .a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b1), .b0(b0), .zin(zin), .ain(ain));		
	rippleAdder r00 (.x(p1_shift), .y(ain), .cin(cin), .sum(p1_add), .cout(cout));
	shift9 s90 (.p1_add(p1_add), .p1_final(p1_final));
endmodule

module a1_con (a1, a1_not, a1_double, a1_double_not, b1, b0, zin, ain);
	input [16:0] a1, a1_not, a1_double, a1_double_not;
	input b0, b1, zin;
	output [16:0] ain;
	
	wire [16:0] t1, t2, t4;
	wire t3, t5, t6, t7;
	
	mux21_17 m10 (.Y(t1), .D0(a1_double), .D1(a1_double_not), .S(b1));
	mux21_17 m20 (.Y(t2), .D0(a1), .D1(a1_not), .S(b1));
	xor (t3, b0, zin);
	mux21_17 m30 (.Y(t4), .D0(t1), .D1(t2), .S(t3));
	xor (t5, b0, b1);
	xor (t6, b0, zin);
	or (t7, t5, t6);
	mux21_17 m40 (.Y(ain), .D0(17'b0), .D1(t4), .S(t7));
endmodule
	
// deciding whether cin will be 1 or 0
module cin_con (b1, b0, zin, cin_con);
	input b1, b0, zin;
	output cin_con;
	
	wire t1, t2, b0not, zinnot;

	not (b0not, b0);
	not (zinnot, zin);
	and (t1, b0, zinnot);
	or (t2, b0not, t1);
	and (cin_con, b1, t2);
endmodule

module shift9 (p1_add, p1_final) ;
	input [32:0]p1_add;
	output [32:0]p1_final;
	
	assign p1_final[30:0] = p1_add[32:2];
	assign p1_final[31] = p1_add[32];
	assign p1_final[32] = p1_add[32];
endmodule

module shift17 (a1, a1_double);
	input [16:0] a1;
	output [16:0] a1_double;
	
	assign a1_double[16:1] = a1[15:0];
	assign a1_double[0] = 1'b0;
endmodule

// module of some faster adder can be added here instead of ripple carry adder.
module rippleAdder (x, y, cin, sum, cout);	
	input [32:0] x;
	input [16:0] y;
	input cin;
	output [16:0]cout;
	output [32:0]sum; 
	
	begin 
	assign sum[15:0] = x[15:0];
	fullAdder f1(.m(x[16]), .n(y[0]), .cin(cin), .sum(sum[16]), .cout(cout[0]));
	fullAdder f2(.m(x[17]), .n(y[1]), .cin(cout[0]), .sum(sum[17]), .cout(cout[1]));
	fullAdder f3(.m(x[18]), .n(y[2]), .cin(cout[1]), .sum(sum[18]), .cout(cout[2]));
	fullAdder f4(.m(x[19]), .n(y[3]), .cin(cout[2]), .sum(sum[19]), .cout(cout[3]));
	fullAdder f5(.m(x[20]), .n(y[4]), .cin(cout[3]), .sum(sum[20]), .cout(cout[4]));
	fullAdder f6(.m(x[21]), .n(y[5]), .cin(cout[4]), .sum(sum[21]), .cout(cout[5]));
	fullAdder f7(.m(x[22]), .n(y[6]), .cin(cout[5]), .sum(sum[22]), .cout(cout[6]));
	fullAdder f8(.m(x[23]), .n(y[7]), .cin(cout[6]), .sum(sum[23]), .cout(cout[7]));
	fullAdder f9(.m(x[24]), .n(y[8]), .cin(cout[7]), .sum(sum[24]), .cout(cout[8]));
	fullAdder f10(.m(x[25]), .n(y[9]), .cin(cout[8]), .sum(sum[25]), .cout(cout[9]));
	fullAdder f11(.m(x[26]), .n(y[10]), .cin(cout[9]), .sum(sum[26]), .cout(cout[10]));
	fullAdder f12(.m(x[27]), .n(y[11]), .cin(cout[10]), .sum(sum[27]), .cout(cout[11]));
	fullAdder f13(.m(x[28]), .n(y[12]), .cin(cout[11]), .sum(sum[28]), .cout(cout[12]));
	fullAdder f14(.m(x[29]), .n(y[13]), .cin(cout[12]), .sum(sum[29]), .cout(cout[13]));
	fullAdder f15(.m(x[30]), .n(y[14]), .cin(cout[13]), .sum(sum[30]), .cout(cout[14]));
	fullAdder f16(.m(x[31]), .n(y[15]), .cin(cout[14]), .sum(sum[31]), .cout(cout[15]));
	fullAdder f17(.m(x[32]), .n(y[16]), .cin(cout[15]), .sum(sum[32]), .cout(cout[16]));
	end
endmodule

module fullAdder (m, n, cin, sum, cout);
	input cin, m, n;
	output sum, cout;
	
	assign sum = (m^n^cin);
	assign cout = ((m&n)|(n&cin)|(m&cin));
endmodule
/*
module fullAdder(m, n, cin, sum, cout);
	input cin, m, n;
	output sum, cout;
	wire t1,t2,t3;
	
	xor x2 (t1, m, n);
	xor x3(sum, t1, cin);
	
	and a1 (t2, m, n);
	and a2 (t3, t1, cin);
	or  o1(cout, t1, t2);
endmodule
*/

module mux21(Y, D0, D1, S);	// when inputs to be multiplexed are single bit long
	output Y;
	input D0, D1, S;
	wire T1, T2, Sbar;

//	assign Y = (S ? D1 : D0);
	and a3 (T1, D1, S);
	and a4 (T2, D0, Sbar);
	not n1 (Sbar, S);
	or o2 (Y, T1, T2);
endmodule

module mux21_17 (Y, D0, D1, S);	// when inputs to be multiplexed are of 17 bits
	output [16:0] Y;
	input [16:0] D0, D1;
	input S;
	
	assign Y = (S ? D1 : D0);
endmodule