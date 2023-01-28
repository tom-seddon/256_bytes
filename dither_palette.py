#!/usr/bin/python3

##########################################################################
##########################################################################

def brightness(colour):
    assert colour>=0 and colour<8

    brightness=0
    if colour&1: brightness|=2
    if colour&2: brightness|=4
    if colour&4: brightness|=1

    return brightness

##########################################################################
##########################################################################

def colour(brightness):
    assert brightness>=0 and brightness<8

    colour=0
    if brightness&1: colour|=4
    if brightness&2: colour|=1
    if brightness&4: colour|=2

    return colour

##########################################################################
##########################################################################

def mode2_lpixel(i):
    assert i>=0 and i<16
    return ((i&1)<<1|(i&2)<<2|(i&4)<<3|(i&8)<<4)

##########################################################################
##########################################################################

def mode2_pixel(l,r):
    return mode2_lpixel(l)|mode2_lpixel(r)>>1

##########################################################################
##########################################################################

def main():
    indexes=[]
    for i in range(15): indexes.append([])
    
    for a in range(8):
        for b in range(a+1):
            indexes[a+b].append((colour(a),colour(b)))

    for i in range(len(indexes)):
        # two the same colour? prefer that one.
        if len(indexes[i])>1:
            for j in range(len(indexes[i])):
                if indexes[i][j][0]==indexes[i][j][1]:
                    indexes[i]=[indexes[i][j]]
                    break

        # prefer one that doesn't use black
        if len(indexes[i])>1:
            for j in range(len(indexes[i])):
                if indexes[i][j][0]==0 or indexes[i][j][1]==0: continue
                indexes[i]=[indexes[i][j]]
                break

        assert len(indexes[i])==1

    for i in range(15):
        print('.byte $%02x'%(mode2_pixel(indexes[i][0][0],indexes[i][0][1])))
    
##########################################################################
##########################################################################

if __name__=='__main__': main()
