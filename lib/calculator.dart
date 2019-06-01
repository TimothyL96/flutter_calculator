import 'calculator_tree.dart';
import 'package:flutter/material.dart';

class Calculator {
	double _answer;
	String _display;
	bool _start;

	CalculatorTree calculatorTreeRoot;

	// Symbol
	static const String symbolPlus = "+";
	static const String symbolMinus = "-";
	static const String symbolMultiply = "*";
	static const String symbolDivide = "/";
	static const String symbolBracketOpen = "(";
	static const String symbolBracketClose = ")";

	// Store all possible symbols
	static const List<String> symbolsAll = [
		symbolPlus,
		symbolMinus,
		symbolMultiply,
		symbolDivide,
		symbolBracketOpen,
		symbolBracketClose,
	];

	// All symbols used in arithmetic operations
	static const List<String> symbolsArithmetic = [
		symbolPlus,
		symbolMinus,
		symbolMultiply,
		symbolDivide,
	];

	// Symbols used in arithmetic operations with low priority
	static const List<String> symbolsArithmeticPriorityLow = [
		symbolPlus,
		symbolMinus,
	];

	// Symbols used in arithmetic operations with high priority
	static const List<String> symbolsArithmeticPriorityHigh = [
		symbolMultiply,
		symbolDivide,
	];

	// Open and close bracket symbol
	static const List<String> symbolsBrackets = [
		symbolBracketOpen,
		symbolBracketClose,
	];

	// If character is any of the symbol return true
	bool _isSymbol( String char ) {
		bool isSymbol = false;

		if ( symbolsAll.contains( char ) ) {
			isSymbol = true;
		}

		return isSymbol;
	}

	// Hide display's decimal point if decimal is 0
	String getRoundedDisplayText( ) {
		String displayText = _display;

		if ( _display.contains( "." )
		     && _display
				        .split( "." )
				        .last == 0.toString( ) ) {
			displayText = int.parse( _display
					                         .split( "." )
					                         .first ).toString( );
		}

		return displayText;
	}

	// Get display text
	String getDisplayText( ) {
		return _display;
	}

	// Set display text
	void setDisplayText( String display ) {
		_display = display;
	}

	// Get start flag
	bool getStartFlag( ) {
		return _start;
	}

	// Reset flags with input for start indicator
	void resetVariables( bool start ) {
		_display = "";
		_answer = 0;
		_start = start;
	}

	// If equal button is pressed
	// We process character 1 by 1 to group it
	void preProcessInput( String char ) {
		List<String> characterGroup = new List( ); // Separate symbols and combine consecutive number
		String sameNumber = _display[0];

		if ( !_isSymbol( sameNumber ) && _display.length == 1 ) {
			characterGroup.add( sameNumber );
			sameNumber = "";
		}

		if ( _display.length > 1 && _isSymbol( _display[1] ) ) {
			characterGroup.add( sameNumber );
			sameNumber = "";
		}

		// Go through the string character by character
		for ( var i = 1; i < _display.length; i++ ) {
			String currentChar = _display[i];

			// If character is symbol then add it to character group
			// else it's a number. Therefore append the number in to string
			if ( _isSymbol( currentChar ) &&
			     !(currentChar == symbolMinus && symbolsArithmetic.contains( _display[i - 1] )) ) {
				characterGroup.add( currentChar );
			} else {
				// Append it to the same number buffer
				sameNumber = sameNumber + currentChar;

				// If last character is number or next character is a symbol
				// Add the current buffered number to the characters list
				if ( i == _display.length - 1 || _isSymbol( _display[i + 1] ) ) {
					characterGroup.add( sameNumber );
					sameNumber = "";
				}
			}
		}

		// Generate the calculator tree
		calculatorTreeRoot = _generateCalculatorTree( characterGroup );
		printDebugTree( calculatorTreeRoot );

		// Process the calculator tree
		_answer = _processCharacterGroup( );

		// Convert double to string
		_display = _answer.toString( );

		// Start reset after equal is pressed and result displayed
		_start = true;
	}

	void printDebugTree( CalculatorTree calculatorTree ) {
		debugPrint( "node: " + calculatorTree.node );
		if ( calculatorTree.leftChild != null ) {
			debugPrint( "left child: " );
			printDebugTree( calculatorTree.leftChild );
		}
		if ( calculatorTree.rightChild != null ) {
			debugPrint( "right child: " );
			printDebugTree( calculatorTree.rightChild );
		}
	}

	// Loop through the character group and generate a complete calculator tree
	CalculatorTree _generateCalculatorTree( List<String> characterGroup ) {
		CalculatorTree calculatorTreeCurrent;
		CalculatorTree calculatorTreeRoot;
		bool hasOpenBracket = false;
		List<String> bracketBody = new List( );

		// If only one exist
		if ( characterGroup.length == 1 ) {
			calculatorTreeCurrent =
			new CalculatorTree( characterGroup[0], null, null );
			calculatorTreeRoot = calculatorTreeCurrent;
			return calculatorTreeRoot;
		}

		// Iterate all character groups
		for ( int i = 1; i < characterGroup.length; i++ ) {
			String character = characterGroup[i];

			// First iteration
			if ( calculatorTreeCurrent == null ) {
				calculatorTreeCurrent =
				new CalculatorTree( character, new CalculatorTree( characterGroup[i - 1], null, null ),
						                    new CalculatorTree( characterGroup[i + 1], null, null ) );

				calculatorTreeRoot = calculatorTreeCurrent;
				continue;
			}

			if ( symbolsBrackets.contains( character ) ) {
				if ( character == symbolBracketOpen ) {
					hasOpenBracket = true;
					continue;
				}
				else if ( character == symbolBracketClose ) {
					if ( !hasOpenBracket ) {
						Error( ); // Return error
					} else {
						calculatorTreeCurrent = _generateCalculatorTree( bracketBody );
						hasOpenBracket = false;
						bracketBody.clear( );
					}
				}
			} else if ( hasOpenBracket ) {
				// Append
				bracketBody.add( character );
			}
			else {
				// Symbols will be divided to each value excluding those negative numbers
				if ( symbolsArithmetic.contains( character ) ) {
					// If symbol has priority high
					if ( symbolsArithmeticPriorityHigh.contains( character ) ) {
						calculatorTreeCurrent.rightChild =
						new CalculatorTree( character, new CalculatorTree( characterGroup[i - 1], null, null ),
								                    new CalculatorTree( characterGroup[i + 1], null, null ) );
						calculatorTreeCurrent = calculatorTreeCurrent.rightChild;
					}

					// If symbol has priority low
					else if ( symbolsArithmeticPriorityLow.contains( character ) ) {
						calculatorTreeCurrent = new CalculatorTree(
								character, calculatorTreeRoot,
								new CalculatorTree( characterGroup[i + 1], null, null ) );
						calculatorTreeRoot = calculatorTreeCurrent;
					}
				}
			}
		}

		return calculatorTreeRoot;
	}

	// Main calculation: Process the calculatorTree
	double _processCharacterGroup( ) {
		// TODO process the calculator tree
		return 0.0;
	}
}