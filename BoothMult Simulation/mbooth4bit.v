module mbooth4bit(a, b, p);
    input [3:0] a, b;
    output reg [7:0] p;

    wire z;
	wire [8:0] p1_shift;
	wire [8:0] p1_final [1:0];
	wire [4:0] a1;
	wire [4:0] a1_not, a1_double, a1_double_not;
	
	assign a1[3:0] = a[3:0];
	assign a1[4] = a[3];	
	assign p1_shift = 9'b0;
	assign z = 1'b0;
	
	a1_variants av1 (.a1(a1), .a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not));
	partialProduct pp1 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[1]), .b0(b[0]), .p1_shift(p1_shift), .zin(z), .p1_final(p1_final[0]));
	partialProduct pp2 (.a1(a1),.a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b[3]), .b0(b[2]), .p1_shift(p1_final[0]), .zin(b[1]), .p1_final(p1_final[1]));
	// more modules of partialProduct can be added to multiply numbers with more number of bits
	
	always@(p1_final[1])
	begin
	p[7:0] = p1_final[1];	
	end
endmodule

// finding a1, -a1, 2*a1, -2*a1
module a1_variants (a1, a1_not, a1_double, a1_double_not);
	input [4:0] a1;
	output [4:0] a1_not, a1_double, a1_double_not;
	
	assign a1_not = ~a1;
	shift5 s50 (.a1(a1), .a1_double(a1_double));
	assign a1_double_not = ~a1_double;	
endmodule

module partialProduct(a1, a1_not, a1_double, a1_double_not, b1, b0, p1_shift, zin, p1_final);
	input [4:0] a1, a1_not, a1_double, a1_double_not;
	input b0, b1;
	input [8:0] p1_shift;
	input zin;
	output [8:0] p1_final;
	
	wire cin;
	wire cin_con;
	wire [4:0] ain;
	wire [4:0] cout;
	wire [8:0] p1_add;
	wire [8:0] p1_final;
	
	cin_con cc0 (.b1(b1), .b0(b0), .zin(zin), .cin_con(cin_con));
	mux21 m00 (.Y(cin), .D0(1'b0), .D1(1'b1), .S(cin_con));
	a1_con a10 (.a1(a1), .a1_not(a1_not), .a1_double(a1_double), .a1_double_not(a1_double_not), .b1(b1), .b0(b0), .zin(zin), .ain(ain));		
	rippleAdder r00 (.x(p1_shift), .y(ain), .cin(cin), .sum(p1_add), .cout(cout));
	shift9 s90 (.p1_add(p1_add), .p1_final(p1_final));
endmodule

// deciding whether to send a1 or -a1 or 2*a1 or -2*a1
module a1_con (a1, a1_not, a1_double, a1_double_not, b1, b0, zin, ain);
	input [4:0] a1, a1_not, a1_double, a1_double_not;
	input b0, b1, zin;
	output [4:0] ain;
	
	wire [4:0] t1, t2, t4;
	wire t3, t5, t6, t7;
	
	mux21_5 m10 (.Y(t1), .D0(a1_double), .D1(a1_double_not), .S(b1));
	mux21_5 m20 (.Y(t2), .D0(a1), .D1(a1_not), .S(b1));
	xor (t3, b0, zin);
	mux21_5 m30 (.Y(t4), .D0(t1), .D1(t2), .S(t3));
	xor (t5, b0, b1);
	xor (t6, b0, zin);
	or (t7, t5, t6);
	mux21_5 m40 (.Y(ain), .D0(5'b0), .D1(t4), .S(t7));
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
	input [8:0]p1_add;
	output [8:0]p1_final;
	
	assign p1_final[6:0] = p1_add[8:2];
	assign p1_final[7] = p1_add[8];
	assign p1_final[8] = p1_add[8];
endmodule

module shift5 (a1, a1_double);
	input [4:0] a1;
	output [4:0] a1_double;
	
	assign a1_double[4:1] = a1[3:0];
	assign a1_double[0] = 1'b0;
endmodule

// module of some faster adder can be added here instead of ripple carry adder.
module rippleAdder (x, y, cin, sum, cout);
	input [8:0] x;
	input [4:0] y;
	input cin;
	output [4:0]cout;
	output [8:0]sum; 
	
	begin 
	assign sum[0] = x[0];
	assign sum[1] = x[1];
	assign sum[2] = x[2];
	assign sum[3] = x[3];
	fullAdder f1(.m(x[4]), .n(y[0]), .cin(cin), .sum(sum[4]), .cout(cout[0]));
	fullAdder f2(.m(x[5]), .n(y[1]), .cin(cout[0]), .sum(sum[5]), .cout(cout[1]));
	fullAdder f3(.m(x[6]), .n(y[2]), .cin(cout[1]), .sum(sum[6]), .cout(cout[2]));
	fullAdder f4(.m(x[7]), .n(y[3]), .cin(cout[2]), .sum(sum[7]), .cout(cout[3]));
	fullAdder f5(.m(x[8]), .n(y[4]), .cin(cout[3]), .sum(sum[8]), .cout(cout[4]));
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

module mux21_5 (Y, D0, D1, S);		// when inputs to be multiplexed are of 5 bits
	output [4:0] Y;
	input [4:0] D0, D1;
	input S;
	
	assign Y = (S ? D1 : D0);
endmodule