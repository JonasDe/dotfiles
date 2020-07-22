import random
import sys
chars = "qwertyuiop[]\\nm,./`1234567890-=~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?`"

def make_word(size, charstring):
    count = len(chars)
    word = ""
    for i in range(size):
        char = random.randint(0,count-1)
        word+=charstring[char]
    return word
doc = ""

if len(sys.argv) < 1:
    print("Must pass amount of words as int")

for i in range(int(sys.argv[1])):
    wordsize = random.randint(2, 10)
    doc += make_word(wordsize, chars) + " "

print(doc)



