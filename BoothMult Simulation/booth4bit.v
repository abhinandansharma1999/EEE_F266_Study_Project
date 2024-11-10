module booth4bit(a, b, p);
    input [3:0] a, b;
    output reg [7:0] p;

    wire z;
	wire [7:0] p1_shift;
	wire [7:0] p1_final [3:0];
	
	assign p1_shift = 8'b0;
	assign z = 1'b0;
	
	partialProduct pp1 (.a(a), .b(b[0]), .p1_shift(p1_shift), .zin(z), .p1_final(p1_final[0]));
	partialProduct pp2 (.a(a), .b(b[1]), .p1_shift(p1_final[0]), .zin(b[0]), .p1_final(p1_final[1]));
	partialProduct pp3 (.a(a), .b(b[2]), .p1_shift(p1_final[1]), .zin(b[1]), .p1_final(p1_final[2]));
	partialProduct pp4 (.a(a), .b(b[3]), .p1_shift(p1_final[2]), .zin(b[2]), .p1_final(p1_final[3]));
	// more modules of partialProduct can be added to multiply numbers with more number of bits

	// output assignments		
	always@(p1_final[3])
	begin
	p[7:0] = p1_final[3];	
	end
endmodule

module partialProduct(a, b, p1_shift, zin, p1_final);
	input [3:0] a;
	input b;
	input [7:0] p1_shift;
	input zin;
	output [7:0] p1_final;
	
	wire cin;
	wire temp;
	wire [3:0] a1;
	wire [3:0] cout;
	wire [7:0] p1_add;
	wire [7:0] p1_con;
	wire [7:0] p1_final;
		
	mux21 m00 (.Y(cin), .D0(1'b0), .D1(1'b1), .S(b));
	compa c00 (.a(a), .b(b), .a1(a1));		
	rippleAdder r00 (.x(p1_shift), .y(a1), .cin(cin), .sum(p1_add), .cout(cout));
	xor (temp, b, zin);
	condition con00 (.p1_add(p1_add), .p1_shift(p1_shift), .temp(temp), .p1_con(p1_con));
	shift s00 (.p1_con(p1_con), .p1_shift(p1_final));
endmodule

module shift(p1_con, p1_shift) ;
	input [7:0]p1_con;
	output [7:0]p1_shift;
	reg [7:0]p1_shift;
	
	always@(p1_con)
	begin
	p1_shift = (p1_con >>> 1);
	p1_shift[7] = p1_shift[6];
	end
endmodule

module rippleAdder(x, y, cin, sum, cout);
	input [7:0] x;
	input [3:0] y;
	input cin;
	output [3:0]cout;
	output [7:0]sum; 
	
	begin 
	assign sum[0] = x[0];
	assign sum[1] = x[1];
	assign sum[2] = x[2];
	assign sum[3] = x[3];
	fullAdder f1(.m(x[4]), .n(y[0]), .cin(cin), .sum(sum[4]), .cout(cout[0]));
	fullAdder f2(.m(x[5]), .n(y[1]), .cin(cout[0]), .sum(sum[5]), .cout(cout[1]));
	fullAdder f3(.m(x[6]), .n(y[2]), .cin(cout[1]), .sum(sum[6]), .cout(cout[2]));
	fullAdder f4(.m(x[7]), .n(y[3]), .cin(cout[2]), .sum(sum[7]), .cout(cout[3]));
	end
endmodule

module fullAdder(m, n, cin, sum, cout);
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

// deciding whether to send a1 or -a1
module compa(a, b, a1);
	input [3:0] a;
	input b;
	output [3:0]a1; 

	mux21 m1 (.Y(a1[0]), .D0(a[0]), .D1(~a[0]), .S(b));
	mux21 m2 (.Y(a1[1]), .D0(a[1]), .D1(~a[1]), .S(b));
	mux21 m3 (.Y(a1[2]), .D0(a[2]), .D1(~a[2]), .S(b));
	mux21 m4 (.Y(a1[3]), .D0(a[3]), .D1(~a[3]), .S(b));
endmodule

module mux21(Y, D0, D1, S);
	output Y;
	input D0, D1, S;
	wire T1, T2, Sbar;

//	assign Y = (S ? D1 : D0);
	and a3 (T1, D1, S);
	and a4 (T2, D0, Sbar);
	not n1 (Sbar, S);
	or o2 (Y, T1, T2);
endmodule

module condition(p1_add, p1_shift, temp, p1_con);
	input [7:0]p1_add;
	input [7:0]p1_shift;
	input temp;
	output [7:0]p1_con;

	mux21 m5 (.Y(p1_con[0]), .D0(p1_shift[0]), .D1(p1_add[0]), .S(temp));
	mux21 m6 (.Y(p1_con[1]), .D0(p1_shift[1]), .D1(p1_add[1]), .S(temp));
	mux21 m7 (.Y(p1_con[2]), .D0(p1_shift[2]), .D1(p1_add[2]), .S(temp));
	mux21 m8 (.Y(p1_con[3]), .D0(p1_shift[3]), .D1(p1_add[3]), .S(temp));
	mux21 m9 (.Y(p1_con[4]), .D0(p1_shift[4]), .D1(p1_add[4]), .S(temp));
	mux21 m10 (.Y(p1_con[5]), .D0(p1_shift[5]), .D1(p1_add[5]), .S(temp));
	mux21 m11 (.Y(p1_con[6]), .D0(p1_shift[6]), .D1(p1_add[6]), .S(temp));
	mux21 m12 (.Y(p1_con[7]), .D0(p1_shift[7]), .D1(p1_add[7]), .S(temp));
endmodule
