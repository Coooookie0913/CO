#该python程序非本人开发，可以实现将MIPS程序text1.asm 转化成rom.txt并自动加载进cpu电路文件P3_v2.circ的ROM元件中，并生成新的电路文件P3_v2_remake.circ
#使用虚拟机里python3然后CTRL+D，然后cd到python文件所在文件夹，输入python3 -u <filename>.py 即可执行python文件。
import os
import re
command = "java -jar Mars4_5.jar text1.asm nc mc CompactTextAtZero a dump .text HexText rom.txt"
os.system(command)
content = open("rom.txt").read()
current = open("P3_v2.circ", encoding="utf-8").read()
current = re.sub(r'addr/data: 5 32([\s\S]*)</a>', "addr/data: 5 32\n" + content + "</a>", cur)
with open("P3_v2_remake.circ", "w", encoding="utf-8") as file:
    file.write(cur)
