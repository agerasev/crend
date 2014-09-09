module main;

import std.stdio;

import api;
import frame;
import renderer;

import util.size;

import example.mandelbrot;

//no console: -L/subsystem:windows

/**
	Are needed to be here:
	1. Mandelbrot and Julia sets
	2. Nova fractal
	3. Burning ship
	4. Dragon
*/

void main(string[] args) {
	API.init();

	Frame frame = new Frame();
	frame.size = Size(800,600);

	Renderer renderer = new Mandelbrot();
	frame.renderer = renderer;

	frame.open();
	delete frame;
	delete renderer;
	
	API.quit();
}