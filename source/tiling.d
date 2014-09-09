module tiling;

import derelict.opengl3.gl;

import util.tile;
import util.size;
import util.color;
import util.oper;

@system class Tiling {
	private:
	
	Tile[] tile;
	uint tileSize = 0x10;
	
	uint currentTile = 0;
	
	float[] pointBuffer;
	float[] colorBuffer;
	
	private Size _size;
	
	public:	
	
	this() {
		
	}
	~this() {
		pointBuffer.length = 0;
		colorBuffer.length = 0;
		tile.length = 0;
	}
	
	@property Size size() {
		return _size;
	}
	@property void size(Size res) {
		_size = res;
		
		fillBuffers();
		buildTiling();
		
		currentTile = 0;
	}

	public void rewind() {
		currentTile = 0;
	}
	
	public Tile current() {
		return tile[currentTile];
	}
	
	public void next() {
		currentTile++;
	}
	
	public bool end() {
		if(currentTile < tile.length) {
			return false;
		}
		return true;
	}
	
	void paint(int x, int y, color c) {
		uint pos = 3*((tile[currentTile].y + y)*_size.w + (tile[currentTile].x + x));
		colorBuffer[pos] = c.r;
		colorBuffer[pos + 1] = c.g;
		colorBuffer[pos + 2] = c.b;
	}

	void fill() {
		Tile til = tile[currentTile];
		//til.average = color(1,0,1);
		for(uint iy = tile[currentTile].y; iy < tile[currentTile].y + tile[currentTile].h; ++iy) {
			for(uint ix = tile[currentTile].x; ix < tile[currentTile].x + tile[currentTile].w; ++ix) {
				uint pos = 3*(iy*_size.w + ix);
				colorBuffer[pos] = til.average.r;
				colorBuffer[pos + 1] = til.average.g;
				colorBuffer[pos + 2] = til.average.b;
			}
		}
	}

	@property void fillColor (color c) {
		tile[currentTile].average = c;
	}

	@property bool filled() {
		return tile[currentTile].monochrome;
	}

	@property void filled(bool f) {
		tile[currentTile].monochrome = f;
	}

	@system void flush() {
		float[] newBuffer;
		newBuffer.length = 3*current.w*current.h;
		//Gauss
		import std.math;
		double c = 2.4;
		double[3] d = [1.0, exp(-c), exp(-c*2)];
		@system void flushPix(bool warn)(int x, int y) {
			double weight = 0.0;
			color col = color(0,0,0);
			for(int iy = y-1; iy < y+2; ++iy) {
				static if(warn) {
					if(current.y + iy < 0 || current.y + iy >= _size.h) {
						continue;
					}
				}
				for(int ix = x-1; ix < x+2; ++ix) {
					static if(warn) {
						if(current.x + ix < 0 || current.x + ix >= _size.w) {
							continue;
						}
					}
					double w = d[abs(x-ix) + abs(y-iy)];
					uint pos = 3*(_size.w*(current.y + iy) + (current.x + ix));
					col = col + w*color(colorBuffer[pos],colorBuffer[pos+1],colorBuffer[pos+2]);
					weight += w;
				}
			}
			col = col/weight;
			uint pos = 3*(current.w*y + x);
			newBuffer[pos] = col.r;
			newBuffer[pos+1] = col.g;
			newBuffer[pos+2] = col.b;
		}
		for(int iy = 0; iy < current.h; ++iy) {
			for(int ix = 0; ix < current.w; ++ix) {
				flushPix!(true)(ix,iy);
			}
		}
		for(int iy = current.y; iy < current.y + current.h; ++iy) {
			for(int ix = current.x; ix < current.x + current.w; ++ix) {
				uint rpos = 3*(current.w*(iy-current.y) + (ix-current.x));
				uint apos = 3*(_size.w*iy + ix);
				colorBuffer[apos] = newBuffer[rpos];
			}
		}
		newBuffer.length = 0;
	}
	
	void flip() {
		glDrawArrays( GL_POINTS, 0, _size.w*_size.h );
	}
	
	private:
	void buildTiling() {
	    tile.length = 0;
	
	    int fx = 2*(div(_size.w - tileSize,2*tileSize) + 1) + 1;
	    int fy = 2*(div(_size.h - tileSize,2*tileSize) + 1) + 1;
	    int fn = fx*fy;

	    tile.length = fn;
	
	    int i = 0;
	    Tile fb;
	    fb.x = _size.w/2 - tileSize/2;
	    fb.y = _size.h/2 - tileSize/2;
	    fb.w = tileSize;
	    fb.h = tileSize;
	    tile[i++] = fb.correct(_size.w,_size.h);
	
	    for(int ig = 1; ; ig++)
	    {
	        fb.x += tileSize;
	        addTile(fb,i);
	        for(int j = 0; j < 2*ig-1; j++)
	        {
	            fb.y -= tileSize;
	            addTile(fb,i);
	        }
	        for(int j = 0; j < 2*ig; j++)
	        {
	            fb.x -= tileSize;
	            addTile(fb,i);
	        }
	        for(int j = 0; j < 2*ig; j++)
	        {
	            fb.y += tileSize;
	            addTile(fb,i);
	        }
	        for(int j = 0; j < 2*ig; j++)
	        {
	            fb.x += tileSize;
	            addTile(fb,i);
	        }
	        if(ig > max(fx,fy))
	        {
	            break;
	        }
	    }
	    tile.length = i;
	}
	
	bool addTile(const ref Tile rect, ref int i) {
	    Tile corr = rect.correct(_size.w,_size.h);
	    if(!corr.empty())
	    {
	        tile[i++] = corr;
	        return true;
	    }
	    return false;
	}
	
	void fillBuffers() {
		import std.algorithm;
		colorBuffer.length = 3*_size.w*_size.h;
		fill(colorBuffer,0.0f);
		pointBuffer.length = 2*_size.w*_size.h;
		for(int iy = 0; iy < _size.h; iy++) {
			for(int ix = 0; ix < _size.w; ix++) {
				uint pos = 2*(iy*_size.w+ix);
				pointBuffer[pos] = ix;
				pointBuffer[pos+1] = iy;
			}
		}
		glVertexPointer( 2, GL_FLOAT, 0, pointBuffer.ptr );
	    glColorPointer( 3, GL_FLOAT, 0, colorBuffer.ptr );
	}
}