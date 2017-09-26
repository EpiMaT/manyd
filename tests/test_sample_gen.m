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

pts = sample_gen(npts, ndim, 'rand');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputGrid(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'grid');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputEdgeGrid(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'edgegrid');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputSparse(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'sparse');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputSobol(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'sobol');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputHalton(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'halton');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputIHS(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'ihs');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

function testOutputNiederreiter(testCase)
import manyd.sample_gen

npts = testCase.TestData.npts;
ndim = testCase.TestData.ndim;

pts = sample_gen(npts, ndim, 'niederreiter');

verifyTrue(testCase, isequal(size(pts), [npts, ndim]));
end

