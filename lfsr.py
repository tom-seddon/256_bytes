#!/usr/bin/python3
import sys,argparse,collections
#https://en.wikipedia.org/wiki/Linear-feedback_shift_register

##########################################################################

Candidate=collections.namedtuple('Candidate','xor_mask results')

def main2(options):
    # Galois LFSR

    # Find candidate XOR masks: ones that correctly cycle through all
    # 255 values.
    candidates=[]
    for xor_mask in range(256):
        # Actual start state is irrelevant - any valid sequence will
        # visit all values.
        start_state=1
        seen=[False]*256
        results=[]
        state=start_state
        n=0
        while not seen[state]:
            results.append(state)
            seen[state]=True
            msb=state&0x80
            state=(state<<1)&0xff
            if msb!=0: state^=xor_mask
            n+=1

        if n==255:
            candidates.append(Candidate(xor_mask=xor_mask,results=results))

    for c in candidates:
        print('Xor mask: $%02x'%(c.xor_mask))
        print('  Results: %s'%c.results)
    
##########################################################################


def main(argv):
    main2(None)

##########################################################################

if __name__=='__main__': main(sys.argv[1:])
