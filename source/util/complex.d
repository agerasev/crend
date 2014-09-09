module util.complex;

import std.math;

@system creal exp(creal arg) {
	return std.math.exp(arg.re)*expi(arg.im);
}

@system creal sin(creal arg) {
	arg *= 1.0i;
	return (exp(arg) - exp(-arg))/2.0i;
}

@system creal cos(creal arg) {
	arg *= 1.0i;
	return (exp(arg) + exp(-arg))/2.0;
}

@system creal sinh(creal arg) {
	return (exp(arg) - exp(-arg))/2.0;
}

@system creal cosh(creal arg) {
	return (exp(arg) + exp(-arg))/2.0;
}

@system real abs2(creal c) {
	return c.re*c.re + c.im*c.im;
}

@system real arg(creal c) {
	real a = atan2(c.im,c.re);
	if(a < 0.0) {
		a += 2.0*PI;
	}
	return a;
}

@system creal conj(creal c) {
	return c.re - 1.0i*c.im;
}