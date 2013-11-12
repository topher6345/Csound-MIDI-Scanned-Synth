opcode smartBalance , a, aai
a1, a2, iatt xin
a1 dcblock a1
ab balance a1, a2
amix linseg .001, iatt+.0000001, 1 , 1, 1
aout = ab*(amix) + a1*(1-amix)

xout aout
endop

