import std.stdio;
import std.array;
import std.file;
import std.conv;
import std.ascii;

ulong rows = 0;
ulong cols = 0;

ulong to1D(ulong x, ulong y) {
	return rows * y + x;
}

void main() {
	
	string[] cells = readText("./day_03.txt").split('\n');
	
	int sum = 0;
	
	rows = cells.length - 1;
	cols = cells[0].length - 1;
	
	// assign all cells
	bool[] visited;
	for (int i = 0; i < cols * rows; i++) {
		visited ~= false;
	}
	
	auto tryVisit = (ulong x, ulong y) {
		if (!visited[to1D(x,y)]) {
			visited[to1D(x,y)] = true;
			return true;
		}
		return false;
	};
	
	auto getPart = (ulong x, ulong y) {
		// check if out of bounds
		if (x < 0 || x > cols ||
			y < 0 || y > rows) {
			writefln("dropping row %d", y);
			return;
		}
		
		// do not visit cells already visited
		if (tryVisit(x,y)) {
		
			// determine part id
			ulong startX = x;
			ulong endX = x;
			
			while (startX > 0 && isDigit(cells[y][startX])) {
				startX--;
			}
			while (endX < cols && isDigit(cells[y][endX])) {
				endX++;
			}
			
			// eww, ugly hacks
			if (startX > 0 || !isDigit(cells[y][startX])) {
				startX++;
			}
			
			// check if any cell between startX and endX was already visited
			for (ulong i = startX; i < endX; i++) {
				if (i != x && visited[to1D(i,y)]) {
					return;
				}
			}
			
			if (endX > startX) {				
				string parse = cells[y][startX..endX];
				int number = to!int(parse);
				sum += number;
			}
			
		}
	};
	
	for (ulong y = 0; y < rows; y++) {
		for (ulong x = 0; x < cols; x++) {
			char cell = cells[y][x];
			
			// determine if symbol
			if (!isDigit(cell) && cell != '.') {				
				// get every neighbour
				getPart(x-1,y-1);
				getPart(x+0,y-1);
				getPart(x+1,y-1);
				
				getPart(x-1,y+0);
				getPart(x+1,y+0);
				
				getPart(x-1,y+1);
				getPart(x+0,y+1);
				getPart(x+1,y+1);
			}
		}
	}
	
	writeln("the sum is ", sum);
}