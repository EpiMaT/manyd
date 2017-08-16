function tests = test_tenspoly
tests = functiontests(localfunctions);
end

function testFixedAddition(testCase)
import manyd.tenspoly

p1def.basis = 'mono';
p1def.deg = [0 0; 1 0; 0 1; 1 1];
p1def.coef = 1:4;
p1 = tenspoly(p1def); % 1 + 2x + 3y + 4xy

p2def.basis = 'mono';
p2def.deg = {0:2,0:1};
p2def.coef = 1;
p2 = tenspoly(p2def); % 1 + x + y + xy + x^2 + x^2 y

p3 = p1+p2;
p4 = p2+p1;

% 2 + 3x + 4y + 5xy + x^2 + x^2 y
adef.basis = 'mono';
adef.deg = [0 0; 1 0; 0 1; 1 1; 2 0; 2 1];
adef.coef = [2 3 4 5 1 1];

a = tenspoly(adef);

verifyTrue(testCase,p3 == a)
verifyTrue(testCase,p4 == a)
end

function testLegendreMult(testCase)
import manyd.tenspoly
% 4 dimensional legendre polys
adef.basis = 'leg';
adef.deg = {1:2; 1; 0:1; 0};
adef.coef = 2;
a = tenspoly(adef);     

bdef.basis = 'leg';
bdef.deg = {1; 1:2; 1; 0:1};
bdef.coef = 3;
b = tenspoly(bdef);


% Commutativity
axb = a * b;
axb2 = b * a;

verifyTrue(testCase,axb == axb2)

% Commutativity and w/ change of basis

axb.convert('mono');
axb2.convert('mono');

am = a.convert('mono');
bm = b.convert('mono');
amb = am * bm;
amb2 = bm * am;

verifyTrue(testCase,axb == amb)
verifyTrue(testCase,axb2 == amb2)
end

function testDerivative(testCase)
import manyd.tenspoly
p1def.basis = 'mono';
p1def.deg = {0:1,0:2};
p1def.coef = 1;
p1 = tenspoly(p1def); % 1 + x + y + xy + y^2 + x y^2

dp1 = p1.derivative(2);

ans1.basis = 'mono';
ans1.deg = {0:1,0:1};
ans1.coef = [1 2 1 2];
p2 = tenspoly(ans1); % 1 + x + 2y + 2xy
verifyTrue(testCase,dp1 == p2)

% do quick check of pprint!
% FIXME break this out into its own test _with more_
str_p2 = p2.pprint;
str_dp1 = dp1.pprint;
verifyTrue(testCase,strcmp(str_p2,str_dp1))


end