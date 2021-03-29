#!/usr/local/bin python

from xml.etree import ElementTree
import csv

file = "review_section_master_kakenhi.xml"

tree = ElementTree.parse(file)
root = tree.getroot()

num = 0
f_tsv = open("review_section_master_kakenhi.csv", mode="w", newline="", encoding="utf-8")

tsv_writer = csv.writer(f_tsv, delimiter=",")
tsv_writer.writerows([["#nii_code", "mext_code", "name_ja", "name_en", \
		"nii_code", "mext_code", "name_ja", "name_en", \
		"nii_code", "mext_code", "name_ja", "name_en"]])

for review_section_table in root.iter("review_section_table"):
	for review_section1 in review_section_table.findall("review_section"):
		section1_list = []
		for code in review_section1.findall("code"):
			section1_list.append(code.text)	
		for name in review_section1.findall("name"):
			section1_list.append(name.text)

		for review_section2 in review_section1.findall('review_section'):
			section2_list = []
			for code in review_section2.findall("code"):
				section2_list.append(code.text)	
			for name in review_section2.findall("name"):
				section2_list.append(name.text)

			for review_section3 in review_section2.findall('review_section'):
				section3_list = []
				for code in review_section3.findall("code"):
					section3_list.append(code.text)	
				for name in review_section3.findall("name"):
					section3_list.append(name.text)
				
				tsv_writer = csv.writer(f_tsv, delimiter=",")
				tsv_writer.writerows([section1_list + section2_list + section3_list])

				print(section1_list, section2_list, section3_list)
	


