module renderer;

import derelict.sdl2.sdl;
import derelict.opengl3.gl;

import util.color;
import util.tile;
import util.oper;
import util.size;

import tiling;

@system class Renderer {
	private:
	Tiling tiling;
	
	int definition;
	int minDefinition = -3;
	int maxDefinition = 0;
	bool flushed = false;

	int optimLevel = -1;
	float optimEps = 1.0/3e2;

	private Size _size;
	
	private uint renderTime = 0x20;
	
	creal dev = 0.0 + 0.0i;
	creal zoom = 3.0 + 0.0i;
	
	public:	
	
	this() {
		tiling = new Tiling();
	}
	~this() {
		delete tiling;
	}
	
	@property Size size() const {
		return _size;
	}
	@property void size(Size res) {
		_size = res;
		tiling.size = res;
		reset();
	}

	@property creal scale() const {
		return zoom;
	}
	@property void scale(creal z) {
		zoom = z;
		reset();
	}

	@property creal translation() const {
		return dev;
	}
	@property void translation(creal d) {
		dev = d;
		reset();
	}

	private void reset() {
		definition = minDefinition;
		tiling.rewind();
		flushed = false;
	}

	/**
		this method is your complex function
	*/
	protected color trace(creal z) const {
		return color(0,0,0);
	}
	protected color trace(creal z, creal s, creal dz) const {
		return trace(z + s*dz);
	}
	
	public final void render() {
		uint btime = SDL_GetTicks();
		while(SDL_GetTicks() - btime < renderTime) {
			if(definition <= maxDefinition) {
				if(!tiling.end()) {
					switchMode(tiling.current());
					tiling.next();
				} else {
					definition++;
					tiling.rewind();
				}
			}/* else if(!flushed) {
				if(!tiling.end()) {
					tiling.flush();
					tiling.next();
				} else {
					flushed = true;
					tiling.rewind();
				}
			}*/
		}
	}
	
	public final void flip() {
		tiling.flip();
	}
	
	private void switchMode(Tile rect) {
		if(definition < 0) {
			fillTile!(-1)(rect);
		} else
		if(definition > 0) {
			fillTile!(1)(rect);
		} else {
			fillTile!(0)(rect);
		}
	}
	
	private void fillTile(int mode)(Tile rect) {
		alias def = definition;
		int dx = 1, dy = 1;
		real ddx, ddy;


		static if(mode < 0) {
			dx = 1<<(-def);
			dy = 1<<(-def);
			if(def == minDefinition) {
				tiling.filled = false;
			}
		} else
		static if(mode > 0){
			ddx = 1.0/(1<<def);
			ddy = 1.0/(1<<def);
		}

		//if filled
		if(tiling.filled) {
			tiling.fill;
			return;
		}

		creal _mul = zoom/_size.h;

		color average = color(0,0,0);
		uint colors = 0;
		bool filled = true;

		for(int ix = 0; ix < rect.w; ix+=dx) {
			for(int iy = 0; iy < rect.h; iy+=dy) {

				creal _dev = cast(real)(rect.x + ix - _size.w/2.0L) + 1.0Li*cast(real)(rect.y + iy - _size.h/2.0L);

				static if(mode > 0) {
					color c = color(0.0f,0.0f,0.0f);
					for(real idx = -0.5L; idx < 0.5L; idx+=ddx) {
						for(real idy = -0.5L; idy < 0.5L; idy+=ddy) {
							c += trace(dev, _mul, _dev + cast(real)idx + 1.0Li*cast(real)idy);
						}
					}
					c /= cast(real)(1<<(2*def));
					tiling.paint(ix, iy, c);
				} else
				static if(mode < 0) {
					color c = trace(dev, _mul, _dev + 1.0L*((dx>>1) - 0.5L) + 1.0Li*((dy>>1) - 0.5L));
					for(int idx = 0; idx < min(dx,rect.w-ix); idx++) {
						for(int idy = 0; idy < min(dy,rect.h-iy); idy++) {
							tiling.paint(ix + idx, iy + idy, c);
						}
					}
					if(def == optimLevel && filled) {
						average = average + c;
						colors++;
						color dc = c - average/colors;
						if(dc*dc > optimEps*optimEps) {
							filled = false;
						}
					}
				} else {
					tiling.paint(ix, iy, trace(dev,_mul,_dev));
				}
			}
		}

		if(def == optimLevel && filled) {
			tiling.filled = true;
			tiling.fillColor = average/colors;
		}
	}
}