#python script to compare baseline output with current output
import re
import difflib

#extract blocks of data
def extract_block(data):
    # The `re.DOTALL` flag allows '.' to match newline characters.
    # The non-greedy quantifier `*?` ensures the shortest possible match.
    blocks = [] #initialize list to hold the blocks
    #regex patterns to identify tags
    start_pattern = r'<[^>]+>'
    end_pattern = r'<\/[^>]+>'
    pattern = re.compile(f"{start_pattern}(.*?){end_pattern}", re.DOTALL)
    
    matches = pattern.findall(data)
    for match in matches:
        blocks.append(match.strip())
    return blocks

#compare blocks of data and print changed lines 

def comp(block_list1, block_list2): 

    #local helper function to split lines in the blocks
    def split_line_helper(block_list):
        split_lines = []
        for i in block_list:
            i = i.strip().splitlines()
            split_lines.append(i)
        return split_lines
    
    base_split = [item for sublist in split_line_helper(block_list1) for item in sublist]
    current_split = [item for sublist in split_line_helper(block_list2) for item in sublist]
    
    #use difflib to generate the differences
    d = difflib.Differ()
    diff = d.compare(base_split, current_split)

    return diff   
    

#Function Calls

#Get file names as input from the user
base_file = input("Enter baseline filename wth extension and full path - ")
current_file = input("Enter current output filename wth extension and full path - ")


#Read log files and save to variable
with open(base_file, encoding='utf-16-le') as f:
    baseline = f.read()

with open(current_file, encoding='utf-16-le') as f:
    current = f.read()

#extract blocks
baseline_blocks = extract_block(baseline)
current_blocks = extract_block(current)

#compare
diff = comp(baseline_blocks, current_blocks)

#save ouptput to a file. The file gets overwritten every time this script runs.
with open("analysis.txt", 'w') as f:

    for line in diff:
        f.write(line + '\n')

#how to read the output?
'''
+ : Line was added.
- : Line was removed.
? : shows what was changed. ^^ underneath certain characters show the where changes happened. It also shows which characters were added and which were removed.
View the line above '?' symbol. That particular line was changed.

For unchanged lines, no symbols will be added as a prefix. If you get the output as it is, consider no changes were found.
'''