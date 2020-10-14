
file1 = open("Data/align.fasta", "r")

list1 = []
for line in file1:
    line = line.strip()
    list1.append(line)
print(list1)

list2 = []
for i in range(0, len(list1)):
    if list1[i][0] == ">":
        list2.append(list1[i])
        seq = ""
        for j in range(i + 1, len(list1)):
            if list1[j][0] != ">":
                seq = seq + list1[j]
            else:
                break
        list2.append(seq)

print(list2)