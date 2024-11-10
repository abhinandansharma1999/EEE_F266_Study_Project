module booth16bit(a, b, p);
    input [15:0] a, b;
    output reg [31:0] p;

    wire z;
	wire [31:0] p1_shift;
	wire [31:0] p1_final [15:0];
	
	assign p1_shift = 32'b0;
	assign z = 1'b0;
	
	partialProduct pp00 (.a(a), .b(b[0]), .p1_shift(p1_shift), .zin(z), .p1_final(p1_final[0]));
	partialProduct pp01 (.a(a), .b(b[1]), .p1_shift(p1_final[0]), .zin(b[0]), .p1_final(p1_final[1]));
	partialProduct pp02 (.a(a), .b(b[2]), .p1_shift(p1_final[1]), .zin(b[1]), .p1_final(p1_final[2]));
	partialProduct pp03 (.a(a), .b(b[3]), .p1_shift(p1_final[2]), .zin(b[2]), .p1_final(p1_final[3]));
	partialProduct pp04 (.a(a), .b(b[4]), .p1_shift(p1_final[3]), .zin(b[3]), .p1_final(p1_final[4]));
	partialProduct pp05 (.a(a), .b(b[5]), .p1_shift(p1_final[4]), .zin(b[4]), .p1_final(p1_final[5]));
	partialProduct pp06 (.a(a), .b(b[6]), .p1_shift(p1_final[5]), .zin(b[5]), .p1_final(p1_final[6]));
	partialProduct pp07 (.a(a), .b(b[7]), .p1_shift(p1_final[6]), .zin(b[6]), .p1_final(p1_final[7]));
	partialProduct pp08 (.a(a), .b(b[8]), .p1_shift(p1_final[7]), .zin(b[7]), .p1_final(p1_final[8]));
	partialProduct pp09 (.a(a), .b(b[9]), .p1_shift(p1_final[8]), .zin(b[8]), .p1_final(p1_final[9]));
	partialProduct pp10 (.a(a), .b(b[10]), .p1_shift(p1_final[9]), .zin(b[9]), .p1_final(p1_final[10]));
	partialProduct pp11 (.a(a), .b(b[11]), .p1_shift(p1_final[10]), .zin(b[10]), .p1_final(p1_final[11]));
	partialProduct pp12 (.a(a), .b(b[12]), .p1_shift(p1_final[11]), .zin(b[11]), .p1_final(p1_final[12]));
	partialProduct pp13 (.a(a), .b(b[13]), .p1_shift(p1_final[12]), .zin(b[12]), .p1_final(p1_final[13]));
	partialProduct pp14 (.a(a), .b(b[14]), .p1_shift(p1_final[13]), .zin(b[13]), .p1_final(p1_final[14]));
	partialProduct pp15 (.a(a), .b(b[15]), .p1_shift(p1_final[14]), .zin(b[14]), .p1_final(p1_final[15]));
	// more modules of partialProduct can be added to multiply numbers with more number of bits

	always@(p1_final[15])
	begin
	p[31:0] = p1_final[15];	
	end
endmodule

module partialProduct(a, b, p1_shift, zin, p1_final);
	input [15:0] a;
	input b;
	input [31:0] p1_shift;
	input zin;
	output [31:0] p1_final;
	
	wire cin;
	wire temp;
	wire [15:0] a1;
	wire cout;
	wire [31:0] p1_add;
	wire [31:0] p1_con;
	wire [31:0] p1_final;
	
	mux21 m0 (.Y(cin), .D0(1'b0), .D1(1'b1), .S(b));
	compa c0 (.a(a), .b(b), .a1(a1));
	
	rippleAdder r0 (.x(p1_shift), .y(a1), .cin(cin), .sum(p1_add), .cout(cout));

	xor (temp, b, zin);
	
	condition con0 (.p1_add(p1_add), .p1_shift(p1_shift), .temp(temp), .p1_con(p1_con));
	shift s0 (.p1_con(p1_con), .p1_shift(p1_final));
endmodule

module shift(p1_con, p1_shift) ;
	input [31:0]p1_con;
	output [31:0]p1_shift;
	reg [31:0]p1_shift;
	
	always@(p1_con)
	begin
	p1_shift = (p1_con >>> 1);
	p1_shift[31] = p1_shift[30];
	end
endmodule

module rippleAdder(x, y, cin, sum, cout);
	input [31:0] x;
	input [15:0] y;
	input cin;
	output cout;
	output [31:0]sum; 
	
	wire [15:0] c;
	
	begin 
	assign sum[0] = x[0];
	assign sum[1] = x[1];
	assign sum[2] = x[2];
	assign sum[3] = x[3];
	assign sum[4] = x[4];
	assign sum[5] = x[5];
	assign sum[6] = x[6];
	assign sum[7] = x[7];
	assign sum[8] = x[8];
	assign sum[9] = x[9];
	assign sum[10] = x[10];
	assign sum[11] = x[11];
	assign sum[12] = x[12];
	assign sum[13] = x[13];
	assign sum[14] = x[14];
	assign sum[15] = x[15];

	fullAdder f1(.m(x[16]), .n(y[0]), .cin(cin), .sum(sum[16]), .cout(c[0]));
	fullAdder f2(.m(x[17]), .n(y[1]), .cin(c[0]), .sum(sum[17]), .cout(c[1]));
	fullAdder f3(.m(x[18]), .n(y[2]), .cin(c[1]), .sum(sum[18]), .cout(c[2]));
	fullAdder f4(.m(x[19]), .n(y[3]), .cin(c[2]), .sum(sum[19]), .cout(c[3]));
	fullAdder f5(.m(x[20]), .n(y[4]), .cin(c[3]), .sum(sum[20]), .cout(c[4]));
	fullAdder f6(.m(x[21]), .n(y[5]), .cin(c[4]), .sum(sum[21]), .cout(c[5]));
	fullAdder f7(.m(x[22]), .n(y[6]), .cin(c[5]), .sum(sum[22]), .cout(c[6]));
	fullAdder f8(.m(x[23]), .n(y[7]), .cin(c[6]), .sum(sum[23]), .cout(c[7]));
	fullAdder f9(.m(x[24]), .n(y[8]), .cin(c[7]), .sum(sum[24]), .cout(c[8]));
	fullAdder f10(.m(x[25]), .n(y[9]), .cin(c[8]), .sum(sum[25]), .cout(c[9]));
	fullAdder f11(.m(x[26]), .n(y[10]), .cin(c[9]), .sum(sum[26]), .cout(c[10]));
	fullAdder f12(.m(x[27]), .n(y[11]), .cin(c[10]), .sum(sum[27]), .cout(c[11]));
	fullAdder f13(.m(x[28]), .n(y[12]), .cin(c[11]), .sum(sum[28]), .cout(c[12]));
	fullAdder f14(.m(x[29]), .n(y[13]), .cin(c[12]), .sum(sum[29]), .cout(c[13]));
	fullAdder f15(.m(x[30]), .n(y[14]), .cin(c[13]), .sum(sum[30]), .cout(c[14]));
	fullAdder f16(.m(x[31]), .n(y[15]), .cin(c[14]), .sum(sum[31]), .cout(c[15]));
	
	assign cout = c[15];
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
	input [15:0] a;
	input b;
	output [15:0]a1; 
	
	mux21_16 m16 (.Y(a1), .D0(a), .D1(~a), .S(b));

/*	mux21 m00 (.Y(a1[0]), .D0(a[0]), .D1(~a[0]), .S(b));
	mux21 m01 (.Y(a1[1]), .D0(a[1]), .D1(~a[1]), .S(b));
	mux21 m02 (.Y(a1[2]), .D0(a[2]), .D1(~a[2]), .S(b));
	mux21 m03 (.Y(a1[3]), .D0(a[3]), .D1(~a[3]), .S(b));
	mux21 m04 (.Y(a1[4]), .D0(a[4]), .D1(~a[4]), .S(b));
	mux21 m05 (.Y(a1[5]), .D0(a[5]), .D1(~a[5]), .S(b));
	mux21 m06 (.Y(a1[6]), .D0(a[6]), .D1(~a[6]), .S(b));
	mux21 m07 (.Y(a1[7]), .D0(a[7]), .D1(~a[7]), .S(b));
	mux21 m08 (.Y(a1[8]), .D0(a[8]), .D1(~a[8]), .S(b));
	mux21 m09 (.Y(a1[9]), .D0(a[9]), .D1(~a[9]), .S(b));
	mux21 m10 (.Y(a1[10]), .D0(a[10]), .D1(~a[10]), .S(b));
	mux21 m11 (.Y(a1[11]), .D0(a[11]), .D1(~a[11]), .S(b));
	mux21 m12 (.Y(a1[12]), .D0(a[12]), .D1(~a[12]), .S(b));
	mux21 m13 (.Y(a1[13]), .D0(a[13]), .D1(~a[13]), .S(b));
	mux21 m14 (.Y(a1[14]), .D0(a[14]), .D1(~a[14]), .S(b));
	mux21 m15 (.Y(a1[15]), .D0(a[15]), .D1(~a[15]), .S(b));
*/	
endmodule

module mux21_16 (Y, D0, D1, S);
	output [15:0] Y;
	input [15:0] D0, D1;
	input S;
	
	assign Y = (S ? D1 : D0);

/*	wire T1, T2, Sbar;
	and a3 (T1, D1, S);
	and a4 (T2, D0, Sbar);
	not n1 (Sbar, S);
	or o2 (Y, T1, T2);
*/	
endmodule

module mux21_32 (Y, D0, D1, S);
	output [31:0] Y;
	input [31:0] D0, D1;
	input S;
	
	assign Y = (S ? D1 : D0);

/*	wire T1, T2, Sbar;
	and a3 (T1, D1, S);
	and a4 (T2, D0, Sbar);
	not n1 (Sbar, S);
	or o2 (Y, T1, T2);
*/	
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
	input [31:0]p1_add;
	input [31:0]p1_shift;
	input temp;
	output [31:0]p1_con;

	mux21_32 m32 (.Y(p1_con), .D0(p1_shift), .D1(p1_add), .S(temp));

/*	mux21 m20 (.Y(p1_con[0]), .D0(p1_shift[0]), .D1(p1_add[0]), .S(temp));
	mux21 m21 (.Y(p1_con[1]), .D0(p1_shift[1]), .D1(p1_add[1]), .S(temp));
	mux21 m22 (.Y(p1_con[2]), .D0(p1_shift[2]), .D1(p1_add[2]), .S(temp));
	mux21 m23 (.Y(p1_con[3]), .D0(p1_shift[3]), .D1(p1_add[3]), .S(temp));
	mux21 m24 (.Y(p1_con[4]), .D0(p1_shift[4]), .D1(p1_add[4]), .S(temp));
	mux21 m25 (.Y(p1_con[5]), .D0(p1_shift[5]), .D1(p1_add[5]), .S(temp));
	mux21 m26 (.Y(p1_con[6]), .D0(p1_shift[6]), .D1(p1_add[6]), .S(temp));
	mux21 m27 (.Y(p1_con[7]), .D0(p1_shift[7]), .D1(p1_add[7]), .S(temp));
	mux21 m28 (.Y(p1_con[8]), .D0(p1_shift[8]), .D1(p1_add[8]), .S(temp));
	mux21 m29 (.Y(p1_con[9]), .D0(p1_shift[9]), .D1(p1_add[9]), .S(temp));
	mux21 m30 (.Y(p1_con[10]), .D0(p1_shift[10]), .D1(p1_add[10]), .S(temp));
	mux21 m31 (.Y(p1_con[11]), .D0(p1_shift[11]), .D1(p1_add[11]), .S(temp));
	mux21 m32 (.Y(p1_con[12]), .D0(p1_shift[12]), .D1(p1_add[12]), .S(temp));
	mux21 m33 (.Y(p1_con[13]), .D0(p1_shift[13]), .D1(p1_add[13]), .S(temp));
	mux21 m34 (.Y(p1_con[14]), .D0(p1_shift[14]), .D1(p1_add[14]), .S(temp));
	mux21 m35 (.Y(p1_con[15]), .D0(p1_shift[15]), .D1(p1_add[15]), .S(temp));
	mux21 m36 (.Y(p1_con[16]), .D0(p1_shift[16]), .D1(p1_add[16]), .S(temp));
	mux21 m37 (.Y(p1_con[17]), .D0(p1_shift[17]), .D1(p1_add[17]), .S(temp));
	mux21 m38 (.Y(p1_con[18]), .D0(p1_shift[18]), .D1(p1_add[18]), .S(temp));
	mux21 m39 (.Y(p1_con[19]), .D0(p1_shift[19]), .D1(p1_add[19]), .S(temp));
	mux21 m40 (.Y(p1_con[20]), .D0(p1_shift[20]), .D1(p1_add[20]), .S(temp));
	mux21 m41 (.Y(p1_con[21]), .D0(p1_shift[21]), .D1(p1_add[21]), .S(temp));
	mux21 m42 (.Y(p1_con[22]), .D0(p1_shift[22]), .D1(p1_add[22]), .S(temp));
	mux21 m43 (.Y(p1_con[23]), .D0(p1_shift[23]), .D1(p1_add[23]), .S(temp));
	mux21 m44 (.Y(p1_con[24]), .D0(p1_shift[24]), .D1(p1_add[24]), .S(temp));
	mux21 m45 (.Y(p1_con[25]), .D0(p1_shift[25]), .D1(p1_add[25]), .S(temp));
	mux21 m46 (.Y(p1_con[26]), .D0(p1_shift[26]), .D1(p1_add[26]), .S(temp));
	mux21 m47 (.Y(p1_con[27]), .D0(p1_shift[27]), .D1(p1_add[27]), .S(temp));
	mux21 m48 (.Y(p1_con[28]), .D0(p1_shift[28]), .D1(p1_add[28]), .S(temp));
	mux21 m49 (.Y(p1_con[29]), .D0(p1_shift[29]), .D1(p1_add[29]), .S(temp));
	mux21 m50 (.Y(p1_con[30]), .D0(p1_shift[30]), .D1(p1_add[30]), .S(temp));
	mux21 m51 (.Y(p1_con[31]), .D0(p1_shift[31]), .D1(p1_add[31]), .S(temp));
*/
endmodule



