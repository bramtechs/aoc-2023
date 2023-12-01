import std.stdio;
import std.file;
import std.array;
import std.ascii;
import std.conv;
import std.typecons : Flag, Yes, No;
import std.algorithm.searching;
	
const string[] digitWords = [
	"one", "two", "three", "four", "five",
	"six", "seven", "eight", "nine"		
];
const string[] replacements = [
	"o1e", "t2o", "t3e", "f4r", "f5e", "s6x",
	"s7n", "e8t", "n9e"
];

int calculateLine(string line, bool secondPart) {
	if (secondPart) {
	
		// replace spelled out digits with digits
		string buffer = "";
		for (int i = 0; i < line.length; i++) {
			char c = line[i];
			
			if (isDigit(c)) {
				continue;
			}
			
			buffer ~= c;
			
			for (int j = 0; j < digitWords.length; j++) {
				auto word = digitWords[j];
				if (!buffer.find(word).empty) {
					auto old = line;
					line = line.replaceFirst(word, replacements[j]);
					if (old != line) { // awful
						buffer = "";
						i = 0;
					}
				}
			}
		}
	}
	
	// get the first digit
	int prefix = 0;
	foreach (char c; line) {
		if (isDigit(c)) {
			prefix = to!(int)(c) - 48;
			break;
		}
	}

	// get first digit from the back
	int suffix = 0;
	foreach_reverse (char c; line) {
		if (isDigit(c)) {
			suffix = to!(int)(c) - 48;
			break;
		}
	}

	return (prefix * 10) + suffix;
}

void calculate(string content, bool secondPart) {

	int sum = 0;
	auto lines = content.split("\n");
	foreach(string line; lines) {
		if (line.empty) {
			continue;
		}

		sum += calculateLine(line, secondPart);
	}
	
	auto title = secondPart ? "Part II":"Part I";
	writeln(title, ": sum is: ", sum);
}

int pair(int p, int s) {
	return (p * 10) + s;
}

void test() {
	assert(pair(1,8) == calculateLine("one23pxdgrsbsonegfive8", true));
	assert(pair(7,2) == calculateLine("ssevenhcltwoseven2cxrmxxcr", true));
	assert(pair(7,2) == calculateLine("797ninetwotwo", true));
	assert(pair(8,8) == calculateLine("z8", true));
	assert(pair(8,3) == calculateLine("eighthree", true));
	assert(pair(1,9) == calculateLine("qbxmone9twoninesljzz", true));
}

void main() {	
	test();
	string content = readText("./day_01.txt");
	calculate(content, false);
	calculate(content, true);
}