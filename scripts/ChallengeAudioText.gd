extends Node

class_name ChallengeAudioText

"""
The font selected for the editor must have Cherokee glyphs
to edit this file! Try using "FreeMono".
"""

const chr_xnumbers:Array = [ "ᏃᏘ", "ᏍᎪᎯᏥᏆ", "ᏔᎵᏥᏆ", "ᏦᎢᏥᏆ", "ᏅᎩᏥᏆ", "ᎯᏍᎩᏥᏆ", "ᏑᏓᎵᏥᏆ", "ᎦᎵᏉᏥᏆ", "ᏁᎳᏥᏆ", "ᏐᏁᎳᏥᏆ" ];
const chr_ynumbers:Array = [ "ᏃᏘ", "ᏍᎪᎯ", "ᏔᎵᏍᎪᎯ", "ᏦᏍᎪᎯ", "ᏅᎩᏍᎪᎯ", "ᎯᏍᎩᏍᎪᎯ", "ᏑᏓᎵᏍᎪᎯ", "ᎦᎵᏆᏍᎪᎯ", "ᏁᎳᏍᎪᎯ", "ᏐᏁᎳᏍᎪᎯ"]
const chr_znumbers:Array = [ "ᏃᏘ", "ᏌᏊ", "ᏔᎵ", "ᏦᎢ", "ᏅᎩ", "ᎯᏍᎩ", "ᏑᏓᎵ", "ᎦᎵᏉᎩ", "ᏣᏁᎳ", "ᏐᏁᎳ", "ᏍᎪᎯ", "ᏌᏚ", "ᏔᎵᏚ", "ᏦᎦᏚ", "ᏂᎦᏚ", "ᏍᎩᎦᏚ", "ᏓᎳᏚ", "ᎦᎵᏆᏚ", "ᏁᎳᏚ", "ᏐᏁᎳᏚ" ]

static func getAudioSequence(number:int)->Array:	
	var list:Array=[]
	#		// 100 -> 900
	for ix in range(9, 0, -1):
		if ix * 100 > number:
			continue
		number -= ix * 100
		list.append(str(ix * 100))
	
	# 20 -> 90
	for ix in range(9, 1, -1):
		if ix * 10 > number:
			continue		
		number -= ix * 10;
		if number > 0:
			list.append(str(ix * 10) + "_");
		else:
			list.append(str(ix * 10))
			
	# 1 -> 19
	for ix in range(19, 0, -1):
		if ix > number:
			continue
		number -= ix
		list.append(str(ix));
	return list;

static func getCardinal(number:int)->String:
	var written:String = ""
	# 100 -> 900
	for ix in range(chr_xnumbers.size()-1, 0, -1):
		if ix * 100 > number:
			continue
		written += " " + chr_xnumbers[ix]
		number -= ix * 100
	#// 20 -> 90
	
	for ix in range(chr_ynumbers.size() - 1, 1, -1):
		if (ix * 10 > number):
			continue;
		
		written += " " + chr_ynumbers[ix]
		number -= ix * 10
	
	# 1 -> 19
	for ix in range(chr_znumbers.size(), 0, -1):
		if (ix > number):
			continue
		if written.ends_with("Ꭿ"):
			written = written.left(written.length()-1) + " "
		written += chr_znumbers[ix]
		number -= ix
		
	if written.empty():
		written = chr_znumbers[0]
		
	return written
