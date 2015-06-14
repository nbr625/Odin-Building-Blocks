# Exercise from Odin-Project - http://www.theodinproject.com/ruby-programming/building-blocks

## Takes a string and encrypts the message by shifting the placement of the individual characters
## by the number indicated on the second argument, "shift". The focus of this approach was to be as
## pithy and clear as possible. That is the sort of style that I deign "beautiful".
## A historical treat:Julius Ceasar used this encryption to send war missives along, in case they
## were to be intercepted. 
## Enjoy!

def caesar_cipher(text, shift)
	alphabet = "abcdefghijklmnopqrstuvwxyz" # No ñ's, I am afraid. Lo siento!
	encrypted_string = ""
	text.split("").each do |char| #char here represents short for character. I opologize if that insults your intelligence.
		if "\"\',.:;?!&'1234567890@%$ ".include?(char) # Hopefully, that covers everything.
			encrypted_string << char
		else
			encrypted_char = alphabet[(alphabet.index(char.downcase) + shift) % 26]
			if char == char.upcase
				encrypted_string << encrypted_char.upcase
			else
				encrypted_string << encrypted_char
			end

		end
		
	end
	return encrypted_string.strip #trim down those edges nicely
end

print caesar_cipher("Winter has come", 4)