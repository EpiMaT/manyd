function tests = test_sample_gen
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
testCase.TestData.npts = 4;
testCase.TestData.ndim = 2;
end

function testOutputRand(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'rand', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputGrid(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'grid', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputEdgeGrid(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'edgegrid', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputSparse(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'sparse', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputSobol(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'sobol', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputHalton(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'halton', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputIHS(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'ihs', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

function testOutputNiederreiter(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'niederreiter', 0);

verifyTrue(testCase,isequal(size(pts), [npts, ndim]));
end

