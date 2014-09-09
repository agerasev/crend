module example.sierpinski;

import derelict.opengl3.gl;

import renderer;

import util.color;

class Sierpinski : Renderer {
	
	private:
	int maxDepth = 6;
	
	private bool carpet(uint depth, cdouble lb, cdouble ds, cdouble c) const {
		depth += 1;
		
		if(depth > maxDepth) {
			return true;
		}
		
		ds /= 3.0;
		
		int x = cast(int)((c.re - lb.re)/ds.re);
		int y = cast(int)((c.im - lb.im)/ds.im);
		
		if(x == 1 && y == 1) {
			return false;
		}
		if(x < 0 || y < 0 || x > 2 || y > 2) {
			return false;
		}
		
		return carpet(depth,lb + 1.0*x*ds.re + 1.0i*y*ds.im,ds,c);
	}
	override protected color trace(creal c) const {
		if(carpet(0,-1.0 - 1.0i, 2.0 + 2.0i,c)) {
			return color(1.0,1.0,1.0);
		}
		return color(0.0,0.0,0.0);
	}
	
}