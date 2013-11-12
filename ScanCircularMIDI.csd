<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
nchnls = 2
sr = 44100
ksmps = 128
0dbfs = 1

#define MATRIX		 #"circularstring-128"#

#define ATTACK		 #	17	#
#define DECAY		 #	18	#
#define SUSTAIN	 #	19	#
#define RELEASE 	 #	20	#

#define FILTER 	 #	21	# 
#define RESONANCE	 #	22	#

#define SUBSINE      #   23   #

#define CENTERING	 #   24   #
#define DAMPING	 #   25   #
#define STEREOOFFSET #   26   #
#define RATE 		 #   1   #


;Profiles
gipos     ftgen 1, 0, 128  ,  10, 1
gifnvel   ftgen 6, 0, 128  ,  -7, 0, 128, 0.1
gifnmass  ftgen 2, 0, 128  ,  -7, 1, 128, 1
gifnstif  ftgen 3, 0, 16384, -23, $MATRIX.
gifncentr ftgen 4, 0, 128  ,  -7, 1, 128, 2
gifndamp  ftgen 5, 0, 128  ,  -7, 1, 128, 1
gifntraj  ftgen 7, 0, 128, -5, .001, 128, 128.
gifnsine  ftgen 8, 0, 8192, 10, 1

turnon 2;Reverb instrument


#include "smartBalance.udo"


gkatt init .005
gkdec init .005
gksus init 1
gkrel init .002

gksin init .5
gkcentr init .1
gkdamp init -.01
gkstof init 0
gkfco init 100000
gkrez init .2
gkrate init .007

ctrlinit 1, $ATTACK, 3
ctrlinit 1, $DECAY, 3
ctrlinit 1, $SUSTAIN,  127
ctrlinit 1, $RELEASE,  1

ctrlinit 1, $SUBSINE, 64
ctrlinit 1, $CENTERING, 2
ctrlinit 1, $DAMPING, 0
ctrlinit 1, $STEREOOFFSET, 0
ctrlinit 1, $RATE, 64

ctrlinit 1, $FILTER, 64
ctrlinit 1, $RESONANCE, 10

			instr 1
	

		;ADSR;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		gkatt midic7 $ATTACK , .0051 , 2
		
		gkdec midic7 $DECAY , .0051 ,2 
		gksus midic7 $SUSTAIN , .0051 ,1
		gkrel midic7 $RELEASE ,  .002 , 2
		;;FUNAMENTAL;;VOL;;;;;;;;;;;;;
		gksin midic7 $SUBSINE , 0  , 1
		;;CENTERING;;SCALING;;;;;;;;;;;;;;
		gkcentr midic7 $CENTERING, 0 , .10
		;;;DAMPING;;SCALING;;;;;;;;;;;;;;;;
		gkdamp midic7	$DAMPING , -.11 , 0
		;;Stereo;;Offset;;;;;;;;;;;;;;;;;;;;;;
		gkstof midic7 	$STEREOOFFSET , 0 , .1
		;FILTER;;;;;;;;;;;;;;;;;;;;;;;;;;
		gkfco midic7 $FILTER , 100 , 10000 , gifntraj
		gkrez midic7 $RESONANCE , 0 , .7
		;;;;;Rate;;;;;;;;;;;;;;;;;;;;;;;;;
		gkrate midic7	$RATE , .001 , .04

ain			= 0 
;MIDI;VEL;to;SCAN;
istif ampmidi 1;
imass ampmidi 2  ;
;;MIDI;;VEL;;To VOLUME;
iamp ampmidi ampdb(75)/32767;
;MIDI;PCH;to;SCAN;
kcps cpsmidib 2  ;
;;I;RATE;;CONVERSION;;;;;
islevi = i (gksus*.8+.2);
;VOLUME;ADSR;;;;A;;;;;;;;;D;;;;;;;;;S;;;;;;;;;R;;;;;;
iatt = i (gkatt)
idec =  i (gkdec)
islev = i (gksus)
irel = i (gkrel)
aenv mxadsr iatt+.02, idec+.01, islev+.01, irel+.01 ;;
a2 oscil iamp, kcps, gifnsine;

irate = i(gkrate)

kmass = 1
kstif = 0.1


ileft = 0
iright = 1
kpos = 0
kstrngth = 0
ain = 0
idisp = 0
id = 22

scanu gipos, irate, gifnvel, gifnmass, \
gifnstif, gifncentr, gifndamp, kmass,  \
kstif, gkcentr, gkdamp, ileft, iright,\
kpos, kstrngth, ain, idisp, id 
a1	scans	iamp, kcps,gifntraj, id,   4   
a1 smartBalance a1, a2, iatt+.2
id2 = 23
scanu gipos, irate, gifnvel, gifnmass, \
gifnstif, gifncentr, gifndamp, kmass,  \
kstif, gkcentr+gkstof, gkdamp, ileft, iright,\
kpos, kstrngth, ain, idisp, id2
a3	scans	iamp, kcps,gifntraj, id2,   4   
a3 smartBalance a3, a2, iatt+.2
asine upsamp gksin; 
aoutleft = a1*aenv + a2*aenv*asine
aoutright = a3*aenv + a2*aenv*asine
gaoutleft moogvcf2 aoutleft, gkfco, gkrez;
gaoutright moogvcf2 aoutright, gkfco, gkrez;
	outs		gaoutleft,gaoutright;
;	outs a2, a2
	endin
	
	instr 2
	
	arevL, arevR reverbsc gaoutleft,gaoutright, .3, 18000	
  kthresh = 0
  kloknee = 40
  khiknee = 60
  kratio  = 2
  katt    = 0.1
  krel    = .5
  ilook   = .02
arevL compress arevL, gaoutleft, kthresh, kloknee, khiknee, kratio, katt, krel, ilook	
arevR compress arevR, gaoutright, kthresh, kloknee, khiknee, kratio, katt, krel, ilook	

	outs arevL, arevR
	endin 
	
</CsInstruments>
<CsScore>
;;TURNON;;
f0 360000;
</CsScore>
</CsoundSynthesizer>


<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>61</y>
 <width>376</width>
 <height>739</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>0</r>
  <g>0</g>
  <b>0</b>
 </bgcolor>
 <bsbObject version="2" type="BSBGraph">
  <objectName/>
  <x>13</x>
  <y>41</y>
  <width>350</width>
  <height>150</height>
  <uuid>{afc8d171-527a-414e-9e61-2c4bc287c940}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <all>true</all>
 </bsbObject>
 <bsbObject version="2" type="BSBScope">
  <objectName/>
  <x>8</x>
  <y>202</y>
  <width>350</width>
  <height>150</height>
  <uuid>{e92234d7-572f-465a-b43d-93054ed93f26}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <value>-255.00000000</value>
  <type>scope</type>
  <zoomx>2.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <mode>0.00000000</mode>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: 0 61 376 739
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView background {0, 0, 0}
ioGraph {13, 41} {350, 150} table 0.000000 1.000000 
ioGraph {8, 202} {350, 150} scope 2.000000 -255 
</MacGUI>
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="74" y="261" width="655" height="346" visible="true" loopStart="-2.14748e+09" loopEnd="0">f 8 0 16384 -23 "string-128" 
f 88 0 16384 -23 "cylinder-128,8" 
f 888 0 16384 -23 "grid-128,8" 
f 8888 0 16384 -23 "torus-128,8" </EventPanel>
