<Qucs Schematic 0.0.18>
<Properties>
  <View=106,1,3747,2875,0.317328,0,0>
  <Grid=10,10,0>
  <DataSet=case_01_goodFIxture.dat>
  <DataDisplay=case_01_goodFIxture.dpl>
  <OpenDisplay=0>
  <Script=case_01_goodFIxture.m>
  <RunScript=0>
  <showFrame=0>
  <FrameText0=Title>
  <FrameText1=Drawn By:>
  <FrameText2=Date:>
  <FrameText3=Revision:>
</Properties>
<Symbol>
</Symbol>
<Components>
  <.SP SP1 1 170 50 0 82 0 0 "lin" 1 "20 MHz" 1 "50 GHz" 1 "2500" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <MLIN MS2 0 580 870 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <Pac P3 0 500 900 18 -26 0 1 "3" 1 "Z_port" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <Pac P4 0 660 900 18 -26 0 1 "4" 1 "Z_port" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 500 930 0 0 0 0>
  <GND * 0 660 930 0 0 0 0>
  <GND * 0 160 320 0 0 0 0>
  <TLIN Line1 0 350 260 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <R R1 0 430 350 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 430 380 0 0 0 0>
  <TLIN Line2 0 430 290 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line3 0 260 260 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <MLIN MS3 0 570 260 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <Pac P5 0 160 290 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <Pac P6 0 650 290 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 650 320 0 0 0 0>
  <Eqn Eqn9 0 590 990 -24 15 0 0 "dBS33=dB(S[3,3])" 1 "yes" 0>
  <Eqn Eqn2 1 880 470 -24 15 0 0 "dBS11=dB(S[1,1])" 1 "dBS21=dB(S[2,1])" 1 "yes" 0>
  <GND * 0 1360 340 0 0 0 0>
  <TLIN Line7 0 1550 280 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <R R3 0 1630 370 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 1630 400 0 0 0 0>
  <TLIN Line8 0 1630 310 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line9 0 1460 280 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P10 0 1360 310 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <R R4 0 2000 370 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 2000 400 0 0 0 0>
  <TLIN Line10 0 2000 310 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line11 0 2150 280 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line12 0 2250 280 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P9 0 2340 310 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 2340 340 0 0 0 0>
  <MLIN MS5 0 1770 280 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS6 0 1950 280 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS7 0 1470 690 -26 15 0 0 "Sub_fixture" 1 "w_DUT1_A_m" 1 "Len_DUT1_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS8 0 1400 1080 -26 15 0 0 "Sub_fixture" 1 "w_DUT2_A_m" 1 "Len_DUT2_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS9 0 1530 1080 -26 15 0 0 "Sub_fixture" 1 "w_DUT2_B_m" 1 "Len_DUT2_B_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS10 0 1640 1080 -26 15 0 0 "Sub_fixture" 1 "w_DUT2_C_m" 1 "Len_DUT2_C_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS11 0 1520 1480 -26 15 0 0 "Sub_fixture" 1 "w_DUT3_A_m" 1 "Len_DUT3_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <GND * 0 1300 750 0 0 0 0>
  <GND * 0 1640 750 0 0 0 0>
  <Pac P14 0 1640 720 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 1280 1140 0 0 0 0>
  <Pac P15 0 1280 1110 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 1720 1540 0 0 0 0>
  <Pac P18 0 1720 1510 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <Pac P13 0 1300 720 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 1830 1140 0 0 0 0>
  <Pac P16 0 1830 1110 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 1290 1530 0 0 0 0>
  <Pac P17 0 1290 1510 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <Eqn Eqn4 1 270 1180 -24 15 0 0 "Len_via_thru_m=Len_via_thru_mm*1e-3*sqrt(Dk_via)" 1 "Len_coax_m=Len_coax_mm*1e-3*sqrt(Dk_coax)" 1 "Len_via_stub_m=Len_via_stub_mm*1e-3*sqrt(Dk_via)" 1 "Len_lead_m=Len_lead_mm*1e-3*sqrt(Dk_lead)" 1 "w_lead_m=w_lead_mm*0.001" 1 "h_lead_m=w_lead_m/MS_aspectRatio_w_h" 1 "yes" 0>
  <Eqn Eqn11 1 270 1350 -24 15 0 0 "Len_DUT1_A_m=Len_DUT1_A_mm*1e-3*sqrt(Dk_lead)" 1 "w_DUT1_A_m=w_DUT1_A_mm*0.001" 1 "yes" 0>
  <Eqn Eqn13 1 270 1470 -24 15 0 0 "Len_DUT2_A_m=Len_DUT2_A_mm*1e-3*sqrt(Dk_lead)" 1 "w_DUT2_A_m=w_DUT2_A_mm*0.001" 1 "yes" 0>
  <Eqn Eqn15 1 270 1580 -24 15 0 0 "Len_DUT2_B_m=Len_DUT2_B_mm*1e-3*sqrt(Dk_lead)" 1 "w_DUT2_B_m=w_DUT2_B_mm*0.001" 1 "yes" 0>
  <Eqn Eqn17 1 270 1690 -24 15 0 0 "Len_DUT2_C_m=Len_DUT2_C_mm*1e-3*sqrt(Dk_lead)" 1 "w_DUT2_C_m=w_DUT2_C_mm*0.001" 1 "yes" 0>
  <Eqn Eqn18 1 280 1830 -24 15 0 0 "Len_DUT3_A_m=Len_DUT3_A_mm*1e-3*sqrt(Dk_lead)" 1 "w_DUT3_A_m=w_DUT3_A_mm*0.001" 1 "yes" 0>
  <Eqn Eqn8 1 780 880 -24 15 0 0 "Z_port=50" 1 "yes" 0>
  <GND * 0 2290 730 0 0 0 0>
  <TLIN Line13 0 2480 670 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <R R5 0 2560 760 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 2560 790 0 0 0 0>
  <TLIN Line14 0 2560 700 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line15 0 2390 670 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P11 0 2290 700 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 2290 1130 0 0 0 0>
  <TLIN Line22 0 2480 1070 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <R R8 0 2560 1160 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 2560 1190 0 0 0 0>
  <TLIN Line23 0 2560 1100 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line24 0 2390 1070 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P20 0 2290 1100 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <MLIN MS16 0 2700 1070 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <R R6 0 3320 760 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 3320 790 0 0 0 0>
  <TLIN Line16 0 3320 700 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line17 0 3470 670 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line18 0 3570 670 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P12 0 3660 700 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 3660 730 0 0 0 0>
  <MLIN MS13 0 3270 670 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <R R7 0 3320 1160 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 3320 1190 0 0 0 0>
  <TLIN Line19 0 3320 1100 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line20 0 3470 1070 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line21 0 3570 1070 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P19 0 3660 1100 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 3660 1130 0 0 0 0>
  <MLIN MS15 0 3270 1070 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <GND * 1 2300 1610 0 0 0 0>
  <TLIN Line25 1 2490 1550 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <R R9 1 2570 1640 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 1 2570 1670 0 0 0 0>
  <TLIN Line26 1 2570 1580 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line27 1 2400 1550 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P21 1 2300 1580 18 -26 0 1 "1" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <MLIN MS18 1 2710 1550 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <R R10 1 3330 1640 15 -26 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 1 3330 1670 0 0 0 0>
  <TLIN Line28 1 3330 1580 20 -26 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line29 1 3480 1550 -26 20 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line30 1 3580 1550 -26 20 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P22 1 3670 1580 18 -26 0 1 "2" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 1 3670 1610 0 0 0 0>
  <MLIN MS20 1 3280 1550 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS21 0 2880 1070 -26 15 0 0 "Sub_fixture" 1 "w_DUT2_A_m" 1 "Len_DUT2_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS22 0 3010 1070 -26 15 0 0 "Sub_fixture" 1 "w_DUT2_B_m" 1 "Len_DUT2_B_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS23 0 3120 1070 -26 15 0 0 "Sub_fixture" 1 "w_DUT2_C_m" 1 "Len_DUT2_C_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS14 0 3000 670 -26 15 0 0 "Sub_fixture" 1 "w_DUT1_A_m" 1 "Len_DUT1_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS12 0 2700 670 -26 15 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <Eqn coax_feed 1 210 460 -24 15 0 0 "Z0_coax=50" 1 "Len_coax_mm=5" 1 "Dk_coax=2.2" 1 "yes" 0>
  <Eqn viaStub 1 450 460 -24 15 0 0 "Len_via_stub_mm=0.25" 1 "yes" 0>
  <Eqn via 1 320 460 -24 15 0 0 "Z0_via=35" 1 "Len_via_thru_mm=3" 1 "Dk_via=3.8" 1 "yes" 0>
  <Eqn Eqn7 1 590 460 -24 15 0 0 "Len_lead_mm=25" 1 "w_lead_mm=0.15" 1 "Dk_lead=3.8" 1 "Df_lead=0.02" 1 "MS_aspectRatio_w_h=2" 1 "yes" 0>
  <SUBST Sub_fixture 1 590 610 -30 24 0 0 "Dk_lead" 1 "h_lead_m" 1 "17 um" 1 "Df_lead" 1 "0.022e-6" 1 "0" 1>
  <Eqn Eqn10 1 1460 850 -24 15 0 0 "Len_DUT1_A_mm=10" 1 "w_DUT1_A_mm=0.15" 1 "yes" 0>
  <Eqn Eqn12 1 1370 1260 -24 15 0 0 "Len_DUT2_A_mm=12" 1 "w_DUT2_A_mm=0.15" 1 "yes" 0>
  <Eqn Eqn16 1 1690 1260 -24 15 0 0 "Len_DUT2_C_mm=Len_DUT2_A_mm" 1 "w_DUT2_C_mm=w_DUT2_A_mm" 1 "yes" 0>
  <Eqn Eqn14 1 1510 1260 -24 15 0 0 "Len_DUT2_B_mm=25" 1 "w_DUT2_B_mm=3*w_DUT2_A_mm" 1 "yes" 0>
  <MLIN MS24 1 2990 1550 -26 15 0 0 "Sub_fixture" 1 "w_DUT3_A_m" 1 "Len_DUT3_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <Eqn Eqn19 1 1510 1660 -24 15 0 0 "Len_DUT3_A_mm=100" 1 "w_DUT3_A_mm=0.15" 1 "yes" 0>
  <R R11 0 750 2600 44 -355 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 750 2630 0 0 0 0>
  <TLIN Line31 0 750 2540 16 -293 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line32 0 700 2510 -43 -255 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line33 0 610 2510 1 -216 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <GND * 0 560 2570 0 0 0 0>
  <Pac P23 0 560 2540 1 -266 0 1 "5" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <MLIN MS25 0 810 2510 -22 -260 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <R R12 0 1130 2600 -11 -321 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 1130 2630 0 0 0 0>
  <TLIN Line34 0 1130 2540 31 -255 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <MLIN MS26 0 1080 2510 -66 -263 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <TLIN Line35 0 1180 2510 -93 -253 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line36 0 1260 2510 -88 -293 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P24 0 1320 2540 -73 -245 0 1 "6" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 1320 2570 0 0 0 0>
  <R R13 0 750 2780 41 -666 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 750 2810 0 0 0 0>
  <TLIN Line37 0 750 2720 17 -568 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line38 0 700 2690 -38 -621 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line39 0 610 2690 67 -566 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <GND * 0 560 2750 0 0 0 0>
  <Pac P25 0 560 2720 -189 -590 0 1 "7" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <MLIN MS27 0 810 2690 -15 -562 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <R R14 0 1120 2780 -94 -629 0 1 "1e9" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 0 1120 2810 0 0 0 0>
  <TLIN Line40 0 1120 2720 -20 -551 0 1 "Z0_via" 1 "Len_via_stub_m" 1 "0 dB" 0 "26.85" 0>
  <MLIN MS28 0 1070 2690 -81 -549 0 0 "Sub_fixture" 1 "w_lead_m" 1 "Len_lead_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <TLIN Line41 0 1170 2690 -118 -533 0 0 "Z0_via" 1 "Len_via_thru_m" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line42 0 1250 2690 -154 -525 0 0 "Z0_coax" 1 "Len_coax_m" 1 "0 dB" 0 "26.85" 0>
  <Pac P26 0 1310 2720 -64 -627 0 1 "8" 1 "50" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 0 1310 2750 0 0 0 0>
  <MLIN MS29 0 940 2690 -715 -2 0 0 "Sub_fixture" 1 "w_DUT2_B_m" 1 "Len_DUT2_B_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS30 0 880 2690 -580 -66 0 0 "Sub_fixture" 1 "w_DUT2_A_m" 1 "Len_DUT2_A_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS31 0 1000 2690 -819 63 0 0 "Sub_fixture" 1 "w_DUT2_C_m" 1 "Len_DUT2_C_m" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
</Components>
<Wires>
  <500 870 550 870 "" 0 0 0 "">
  <610 870 660 870 "" 0 0 0 "">
  <160 260 230 260 "" 0 0 0 "">
  <290 260 320 260 "" 0 0 0 "">
  <380 260 430 260 "" 0 0 0 "">
  <430 260 540 260 "" 0 0 0 "">
  <600 260 650 260 "" 0 0 0 "">
  <1360 280 1430 280 "" 0 0 0 "">
  <1490 280 1520 280 "" 0 0 0 "">
  <1580 280 1630 280 "" 0 0 0 "">
  <1630 280 1740 280 "" 0 0 0 "">
  <1980 280 2000 280 "" 0 0 0 "">
  <2000 280 2120 280 "" 0 0 0 "">
  <2180 280 2220 280 "" 0 0 0 "">
  <2280 280 2340 280 "" 0 0 0 "">
  <1800 280 1920 280 "" 0 0 0 "">
  <1430 1080 1500 1080 "" 0 0 0 "">
  <1560 1080 1610 1080 "" 0 0 0 "">
  <1300 690 1440 690 "" 0 0 0 "">
  <1500 690 1640 690 "" 0 0 0 "">
  <1280 1080 1370 1080 "" 0 0 0 "">
  <1670 1080 1830 1080 "" 0 0 0 "">
  <1550 1480 1720 1480 "" 0 0 0 "">
  <1290 1480 1490 1480 "" 0 0 0 "">
  <1290 1530 1290 1540 "" 0 0 0 "">
  <2290 670 2360 670 "" 0 0 0 "">
  <2420 670 2450 670 "" 0 0 0 "">
  <2510 670 2560 670 "" 0 0 0 "">
  <2290 1070 2360 1070 "" 0 0 0 "">
  <2420 1070 2450 1070 "" 0 0 0 "">
  <2510 1070 2560 1070 "" 0 0 0 "">
  <2560 1070 2670 1070 "" 0 0 0 "">
  <3300 670 3320 670 "" 0 0 0 "">
  <3320 670 3440 670 "" 0 0 0 "">
  <3500 670 3540 670 "" 0 0 0 "">
  <3600 670 3660 670 "" 0 0 0 "">
  <3300 1070 3320 1070 "" 0 0 0 "">
  <3320 1070 3440 1070 "" 0 0 0 "">
  <3500 1070 3540 1070 "" 0 0 0 "">
  <3600 1070 3660 1070 "" 0 0 0 "">
  <2300 1550 2370 1550 "" 0 0 0 "">
  <2430 1550 2460 1550 "" 0 0 0 "">
  <2520 1550 2570 1550 "" 0 0 0 "">
  <2570 1550 2680 1550 "" 0 0 0 "">
  <3310 1550 3330 1550 "" 0 0 0 "">
  <3330 1550 3450 1550 "" 0 0 0 "">
  <3510 1550 3550 1550 "" 0 0 0 "">
  <3610 1550 3670 1550 "" 0 0 0 "">
  <2910 1070 2980 1070 "" 0 0 0 "">
  <3040 1070 3090 1070 "" 0 0 0 "">
  <2730 1070 2850 1070 "" 0 0 0 "">
  <3240 1070 3250 1070 "" 0 0 0 "">
  <3150 1070 3240 1070 "" 0 0 0 "">
  <2970 670 2980 670 "" 0 0 0 "">
  <2730 670 2970 670 "" 0 0 0 "">
  <2560 670 2670 670 "" 0 0 0 "">
  <3030 670 3240 670 "" 0 0 0 "">
  <3020 1550 3250 1550 "" 0 0 0 "">
  <2740 1550 2960 1550 "" 0 0 0 "">
  <730 2510 750 2510 "" 0 0 0 "">
  <640 2510 670 2510 "" 0 0 0 "">
  <560 2510 580 2510 "" 0 0 0 "">
  <750 2510 780 2510 "" 0 0 0 "">
  <840 2510 1050 2510 "" 0 0 0 "">
  <1110 2510 1130 2510 "" 0 0 0 "">
  <1130 2510 1150 2510 "" 0 0 0 "">
  <1210 2510 1230 2510 "" 0 0 0 "">
  <1290 2510 1320 2510 "" 0 0 0 "">
  <730 2690 750 2690 "" 0 0 0 "">
  <640 2690 670 2690 "" 0 0 0 "">
  <560 2690 580 2690 "" 0 0 0 "">
  <750 2690 780 2690 "" 0 0 0 "">
  <1100 2690 1120 2690 "" 0 0 0 "">
  <1120 2690 1140 2690 "" 0 0 0 "">
  <1200 2690 1220 2690 "" 0 0 0 "">
  <1280 2690 1310 2690 "" 0 0 0 "">
  <840 2690 850 2690 "" 0 0 0 "">
  <1030 2690 1040 2690 "" 0 0 0 "">
</Wires>
<Diagrams>
  <Rect 190 1000 240 160 3 #c0c0c0 1 00 1 0 1e+10 5e+10 0 -60 5 0 1 -1 1 1 315 0 225 "" "" "">
	<"dBS33" #0000ff 0 3 0 0 0>
  </Rect>
  <Rect 860 410 240 160 3 #c0c0c0 1 00 1 0 1e+10 5e+10 0 -60 10 0 1 -1 1 1 315 0 225 "Frequency, Hz" "S-Parameter, dB" "">
	<"dBS21" #0000ff 0 3 0 0 0>
	<"dBS11" #ff0000 0 3 0 0 0>
  </Rect>
</Diagrams>
<Paintings>
  <Text 320 210 12 #aa0000 0 "FixtureL">
  <Text 1490 230 12 #aa0000 0 "2x Thru">
  <Text 1320 590 12 #aa0000 0 "DUT1 Short">
  <Text 1310 1000 12 #aa0000 0 "DUT2 Beatty Standard">
  <Text 1330 1410 12 #aa0000 0 "DUT3 Long">
  <Text 2430 1500 12 #aa0000 0 "F-DUT3-F">
  <Text 2340 590 12 #aa0000 0 "F-DUT1-F">
  <Text 2370 1010 12 #aa0000 0 "F-DUT2-F">
  <Text 620 2460 12 #000000 0 "fixture-left">
  <Text 1170 2460 12 #000000 0 "fixture-right">
  <Rectangle 850 2650 180 90 #ff007f 0 1 #c0c0c0 1 0>
  <Text 930 2620 12 #000000 0 "DUT">
</Paintings>
