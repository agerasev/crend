module example.func;

import std.math;
import util.complex;

import renderer;
import util.color;

/**
	Weak std.complex replaced by util.complex
*/
class Func : Renderer {

	static protected color rainbow(double val) {
		val *= 6.0;
		double grd = val - floor(val);
		int col = cast(int)(val);
		switch(col) {
			case 0: return color( 1.0, grd, 0.0 );
			case 1: return color( 1.0 - grd, 1.0, 0.0 );
			case 2: return color( 0.0, 1.0, grd );
			case 3: return color( 0.0, 1.0 - grd, 1.0 );
			case 4: return color( grd, 0.0, 1.0 );
			case 5: return color( 1.0, 0.0, 1.0 - grd );
			default: return color( 0.0, 0.0, 0.0 );
		}
	}
	
	static protected color bright(color col, double val) {
		if(val <= 1.0) {
			return col*val;
		}
		return (color(1.0,1.0,1.0) - col)*(1.0 - 1.0/val) + col; 
	}
	
	/**
		May be overridden with your painter
	*/
	protected color paint(creal z) const {
		double rho = abs(z);
		double phi = arg(z);
		return bright(rainbow(phi/(2.0*PI)),rho);
	}
	
	/**
		May be overridden with your function
	*/
	protected creal func(creal z) const {
		return z;
	}
	
	override protected color trace(creal c) const {
		return paint(func(c));
	}
}