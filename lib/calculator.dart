class Calculator {
	double _answer;
	String _display;
	bool _start;

	// If character is any of the symbol return true
	bool _isSymbol( String char ) {
		bool isSymbol = false;

		if ( char == "+" || char == "-" || char == "*" || char == "/" || char == "(" || char == ")" ) {
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
	// We process character 1 by 1 and do recursive call instead of using a tree method
	void equalPressed( String char ) {
		List<String> characterGroup = new List( ); // Separate symbols and combine same number
		String sameNumber = "";

		// Go through the string character by character
		for ( var i = 0; i < _display.length; i++ ) {
			String currentChar = _display[i];

			// If character is symbol then add it to character group
			// else it's a number. Therefore append the number in to string
			if ( _isSymbol( currentChar ) ) {
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

		// Process the character group
		_answer = _processCharacterGroup( characterGroup );

		// Convert double to string
		_display = _answer.toString( );

		// Start reset after equal is pressed and result displayed
		_start = true;
	}

	// Main logic
	double _processCharacterGroup( List<String> characterGroup ) {
		// TODO
		return 0.0;
	}
}
