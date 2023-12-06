import std.stdio;
import std.array;
import std.conv;
import std.file;
import std.string;
import std.algorithm.searching;

int[] getNumbersFromSection(ref string section) {
	int[] numbers;
	string[] numberStrings = section.split(' ');
	
	foreach (n; numberStrings) {
		auto m = n.strip();
		if (m.length == 0) {
			continue;
		}
		numbers ~= to!int(m);
	}
	
	return numbers;
}

struct Card {
	int[] matches;
	int score;
};

void main() {

	int totalScore = 0;
	
	Card[] cards;
	
	foreach (line; readText("./day_04_sample.txt").split('\n')) {		
		string[] halves = line.split('|');
		
		// 1. read card number
		int number = -1;
		{
			string prefix = halves[0].split(':')[0];
			
			string numberBuffer = "";
			bool add = false;
			foreach (p; prefix) {
				if (p == ' ') {
					add = true;
				} else if (add) {
					numberBuffer ~= p;
				}
			}
			
			number = to!int(numberBuffer);
		}
		assert(number >= 0);
		
		Card card;
		
		// 2. read winning numbers
		int[] winning;
		{
			string list = halves[0].split(':')[1];
			winning = getNumbersFromSection(list);
		}
		
		// 3. read my numbers
		int[] mine;
		{
			string list = halves[1];
			mine = getNumbersFromSection(list);
		}

		// 4. calculate score
		foreach (myNum; mine) {
			if (!winning.find(myNum).empty) {
				if (card.score == 0) {
					card.score++;
				} else {
					card.score *= 2;
				}
				
				card.matches ~= myNum;
			}
		}
		
		totalScore += card.score;
		cards ~= card;
	}
	
	writefln("Part I: Total score is %d", totalScore);
	
	// part II
	
	Card*[] partTwoCards;
	for (int i = 0; i < cards.length; i++) {
		int index = i;
		foreach (match; cards[i].matches) {
			partTwoCards ~= &cards[index++];
			writefln("copying card %d", index+1);
		}
	}
	
	writefln("Part II: You end up with %d cards", partTwoCards.length);
}