#!/usr/bin/python3
import sys,os,argparse

# https://en.wikipedia.org/wiki/Piano_key_frequencies
def get_key_hz(n): return (2**((n-49)/12))*440

def get_sn_value(hz): return int(125000/hz+.5)

key_names=['A','A#','B','C','C#','D','D#','E','F','F#','G','G#']

def get_key_name(n):
    assert n>=1 and n<=88
    octave=(n+8)//12
    key=(n-1)%12
    return '%s%d'%(key_names[key],octave)

def main2(options):
    print('_:=[]')
    for note in options.notes:
        hz=get_key_hz(note)
        print('_..=[$%04x] ; %d %s = %.4f Hz'%(get_sn_value(hz),
                                            note,
                                            get_key_name(note),
                                            hz))

def main(argv):
    p=argparse.ArgumentParser()

    p.add_argument('--all',action='store_true',help='''just print all notes''')
    p.add_argument('notes',metavar='NOTE',nargs='+',type=int,help='''piano key number''')

    main2(p.parse_args(argv))
    
    # for note in range(40,53):
    #     print('%s: %f'%(get_key_name(note),get_key_hz(note)))
    
    # notes=[
    #     261.6256,
    #     311.1270,
    #     349.2282,
    #     369.9944,
    #     391.9954,
    #     466.1638,
    #     493.8833,
    #     523.2511,
    # ]

    # for hz in notes:
    #     n=125000/hz
    #     print('%.4f: $%04x (%.3f)'%(hz,int(n),n))

if __name__=='__main__': main(sys.argv[1:])
