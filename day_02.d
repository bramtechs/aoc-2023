import std.stdio;
import std.file;
import std.array;
import std.string;
import std.conv;

void main() {	
	int totalRed = 12;
	int totalGreen = 13;
	int totalBlue = 14;
	
	int sum = 0;
	
	foreach (line; readText("./day_02.txt").split('\n')) {
		string title = line.split(':')[0];
		string content = line.split(':')[1];
		
		// 1. determine game id (between ' ' and ':) from title
		int gameId = 0;
		{ 
			string id = "";
			for (long i = title.indexOf(' ') + 1; i < title.length; i++) {
				id ~= line[i];
			}
			gameId = to!int(id);
		}
		writeln(gameId);
		
		// 2. read every set from content
		bool possible = true;
		string[] sets = content.split(';');
		set_loop: foreach (set; sets) {
			// 3. read every hand from each set
			foreach (hand; set.split(',')) {
				hand = hand.strip();
			
				int amount = to!int(hand.split(' ')[0]);
				string color = hand.split(' ')[1];
				writefln("%d cubes of %s", amount, color);
				
				// if a hand contains more cubes than the collection
				// the game is not possible
				switch (color) {
					case "red":
						possible = amount <= totalRed;
						break;
					case "green":
						possible = amount <= totalGreen;
						break;
					case "blue":
						possible = amount <= totalBlue;
						break;
					default:
						assert(0);
				}
				if (!possible) {
					break set_loop;
				}
			}
			
			writeln("---");
		}
		if (possible) {
			writefln("Game %d is possible", gameId);
			sum += gameId;
		}
	}
	
	writefln("sum is %d", sum);
}