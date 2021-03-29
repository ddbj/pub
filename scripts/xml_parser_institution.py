#!/usr/local/bin python

from xml.etree import ElementTree
import csv

file = "input_xml_for_wikibase/institution_master_kakenhi.xml"

tree = ElementTree.parse(file)
root = tree.getroot()

num = 0
f_tsv = open("institution_master_kakenhi.csv", mode="w", newline="", encoding="utf-8")

tsv_writer = csv.writer(f_tsv, delimiter=",")
tsv_writer.writerows([["#nii_code", "mext_code", "jsps_code", "name_ja", "name_en", "name_yomi"]])

for institution_table in root.iter("institution_table"):
	if "end_date" not in institution_table.attrib:
	
		for institution in institution_table.findall('institution'):
			institution_list = []
			code_list =[]
			for code in institution.findall("code"):
				code_list.append(code.text)
			
			if len(code_list) < 3:
				for i in range(len(code_list), 3):
					code_list.append("")
			institution_list += code_list
			
			for name in institution.findall("name"):
				institution_list.append(name.text)
			for name_yomi in institution.findall("name_yomi"):
				institution_list.append(name_yomi.text)
		
		
			tsv_writer = csv.writer(f_tsv, delimiter=",")
			tsv_writer.writerows([institution_list])

#		print(section1_list, section2_list, section3_list)
