module example.mandelbrot;

import renderer;

import util.color;
import util.complex;
import std.math;

import util.oper;

@system class Mandelbrot : Renderer {
	private:
	ulong iterations = 0x100;
	double perZoomIterations = 64.0f;
	real infinity = 4.0;

	override protected color trace(creal z, creal s, creal dz) const {

		z = z + s*dz;

	    ulong depth = 0;
		ulong iters = iterations + cast(ulong)(perZoomIterations*(log10(s.re)^^2));
		creal p = 0.0 + 0.0i;
	    
        for(depth = 0; depth < iters; depth++)
        {
            if(divergence( p = p*p + z ))
            {
                break;
            }
        }
        
	    if(depth < iters)
	    {
	
	        p = p*p + z; depth++;    // a couple of extra iterations helps
	        p = p*p + z; depth++;    // decrease the size of the error term.
	        double md = abs(p);
	        double mu = depth - (log(log(md)))/log(2.0);
	
	        return blend(0.006*mu,level03);
	    }
	    return color(0.0,0.0,0.0);
	}
	
	bool divergence(creal z) const {
	    if(abs2(z) > infinity)
	    {
	        return true;
	    }
	    return false;
	}
	
	static color blend(double c, color[] lev) {
	    int plc = cast(int)floor(c*6.0);
	    double dev = c*6.0 - cast(double)plc;
	    plc = mod(plc,6);
	    
	    switch(plc) {
	    case 0:
	        return interpolate(lev[0],lev[1],dev);
	    case 1:
	        return interpolate(lev[1],lev[2],dev);
	    case 2:
	        return interpolate(lev[2],lev[3],dev);
	    case 3:
	        return interpolate(lev[3],lev[4],dev);
	    case 4:
	        return interpolate(lev[4],lev[5],dev);
	    case 5:
	        return interpolate(lev[5],lev[0],dev);
	    default:
	        return color(1.0,1.0,1.0);
	    }
	}
	
	static color interpolate(color c0, color c1, double fp) {
	    double 	a = (1.0 - fp)*(1.0 - fp)*(1.0 - fp), 
	    		b = 3.0*(1.0 - fp)*(1.0 - fp)*fp, 
	    		c = 3.0*fp*fp*(1.0 - fp), 
	    		d = fp*fp*fp;
	    return color(
	    	c0.r*a + c0.r*b + c1.r*c + c1.r*d,
	    	c0.g*a + c0.g*b + c1.g*c + c1.g*d,
	    	c0.b*a + c0.b*b + c1.b*c + c1.b*d
	    );
	}
	
	static color level01[] =
	    [
	        color(0.0,0.0,0.25),
	        color(0.3,0.3,0.12),
	        color(0.6,0.6,0.0),
	        color(1.0,1.0,0.0),
	        color(0.6,0.6,0.0),
	        color(0.3,0.3,0.12)
	    ];
	
	
	static color level02[] =
	    [
	        color(0.0,0.0,0.0),
	        color(0.5,0.0,0.0),
	        color(1.0,0.0,0.0),
	        color(1.0,0.5,0.0),
	        color(1.0,1.0,0.0),
	        color(0.5,0.5,0.0)
	    ];
	
	
	static color level03[] =
	    [
	        color(0.0,0.0,0.0),
	        color(0.0,0.0,1.0),
	        color(0.5,0.5,1.0),
	        color(1.0,1.0,1.0),
	        color(0.5,0.5,1.0),
	        color(0.0,0.0,1.0)
	    ];
}