module smult16bit(a,b,p);
//inputs
input [15:0]a,b;
//outputs
output reg [31:0]p;

//wires
reg w[15:0][15:0];
reg s[15:0][15:0];
reg c[15:0][15:0];

integer i,j,m,n,l,x,g,h;
integer k=16;		//change this and the register sizes accordingly
always@*	
begin

//AND GATES
for (i=0; i<k; i=i+1)
begin
	for (j=0; j<k; j=j+1)
	begin
		w[i][j] = (a[i]&b[j]);	
	end
end

for (i=0; i<(k-1); i=i+1)
begin
	w[i][k-1] = (~w[i][k-1]);	
end

for (j=0; j<(k-1); j=j+1)
begin
	w[k-1][j] = (~w[k-1][j]);	
end

//---------------------------------------------------------------------
//CHANGE OF TERMINOLOGY
for (j=1; j<k; j=j+1)
begin
	s[0][j] = w[0][j];
end

c[0][k-1] = 1;

//---------------------------------------------------------------------
l=1;
for (m=0; m<(k-3); m=m+2)
begin
	i=1;
	j=m; 
	for (n=1 ; n<l; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1; 
		j=j-2;
	end
	s[i][j] = (w[i][j] ^ s[i-1][j+1]);
	c[i][j] = (w[i][j] & s[i-1][j+1]);
	
	g=1;
	h=m+1;
	for (x=1 ; x<l+1; x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));
		g=g+1;
		h=h-2;
	end
	l=l+1;
end

//-----------------------------------------------------------------------
for (m=1; m<(k/2+1); m=m+1)
begin
	i=m;
	j=(k-2); 
	for (n=1 ; n<(k/2); n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1;
		j=j-2;
	end
	
	s[i][j] = (s[i-1][j+1]^w[i][j]);
	c[i][j] = (s[i-1][j+1]&w[i][j]);
	
	g=m;
	h=(k-1);
	s[g][h] = (w[g][h] ^ c[g-1][h] ^ c[g][h-1]);
	c[g][h] = ((w[g][h]&c[g-1][h]) | (w[g][h]&c[g][h-1]) | (c[g-1][h]&c[g][h-1]));
	g=g+1;
	h=h-2;
	
	for (x=1 ; x<(k/2); x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));
		g=g+1;
		h=h-2;
	end
end

//-------------------------------------------------------------------------
l=(k/2-1);
for (m=(k/2+1); m<k; m=m+1)
begin
	i=m;
	j=(k-2); 
	for (n=1 ; n<l+1; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1;
		j=j-2;
	end
	
	g=m;
	h=(k-1);
	s[g][h] = (w[g][h] ^ c[g-1][h] ^ c[g][h-1]);
	c[g][h] = ((w[g][h]&c[g-1][h]) | (w[g][h]&c[g][h-1]) | (c[g-1][h]&c[g][h-1]));
	g=g+1;
	h=h-2;
	
	for (x=1 ; x<l; x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));	
		g=g+1;
		h=h-2;
	end
	l=l-1;
end

//----------------------------------------------------------------------------
//OUTPUT ASSIGNMENTS
p[0] = w[0][0];
for (i=1; i<k; i=i+1)
begin
p[i] = s[i][0];
end

for (i=1; i<k; i=i+1)
begin
p[i+k-1] = s[k-1][i];
end

p[2*k-1] = (c[k-1][k-1]^1);

end
endmodule
