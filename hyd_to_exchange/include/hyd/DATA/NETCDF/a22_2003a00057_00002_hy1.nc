CDF       
      time      pressure      latitude      	longitude         string_dimension   (         EXPOCODE      316N200310     Conventions       COARDS/WOCE    WOCE_VERSION      3.0    WOCE_ID       A22    	DATA_TYPE         	WOCE BOT       STATION_NUMBER            57     CAST_NUMBER         2    BOTTOM_DEPTH_METERS         a   BOTTLE_NUMBERS              3      2      1      BOTTLE_QUALITY_CODES              Creation_Time         ?Diggs EXBOT-to-NetCDF Code v0.1e: Thu May  4 01:27:49 2006 GMT     ORIGINAL_HEADER       �
BOTTLE,20060503WHPSIOSCD
#code : jjward hyd_to_exchange.pl 
#original files copied from HTML directory: 2006.05.03
#original HYD file: a22_2003ahy.txt   Mon May 23 12:18:22 2005
#original SUM file: a22_2003asu.txt   Wed May  3 18:23:14 2006
     WOCE_BOTTLE_FLAG_DESCRIPTION     �::1 = Bottle information unavailable.:2 = No problems noted.:3 = Leaking.:4 = Did not trip correctly.:5 = Not reported.:6 = Significant discrepancy in measured values between Gerard and Niskin bottles.:7 = Unknown problem.:8 = Pair did not trip correctly. Note that the Niskin bottle can trip at an unplanned depth while the Gerard trips correctly and vice versa.:9 = Samples not drawn from this bottle.:
      "WOCE_WATER_SAMPLE_FLAG_DESCRIPTION       �::1 = Sample for this measurement was drawn from water bottle but analysis not received.:2 = Acceptable measurement.:3 = Questionable measurement.:4 = Bad measurement.:5 = Not reported.:6 = Mean of replicate measurements.:7 = Manual chromatographic peak measurement.:8 = Irregular digital chromatographic peak integration.:9 = Sample not drawn for this measurement from this bottle.:
          '   ctd_raw                	long_name         ctd_raw    units                C_format      %8.1f      WHPO_Variable_Name        CTDRAW          "    pressure               	long_name         	pressure       units         dbar       positive      down       C_format      %8.1f      WHPO_Variable_Name        CTDPRS          "8   temperature                	long_name         temperature    units         its-90     C_format      %8.4f      WHPO_Variable_Name        CTDTMP          "P   salinity               	long_name         	salinity       units         pss-78     C_format      %8.4f      WHPO_Variable_Name        CTDSAL     OBS_QC_VARIABLE       salinity_QC         "h   salinity_QC                	long_name         salinity_QC_flag       units         woce_flags     C_format      %1d         "�   bottle_salinity                	long_name         bottle_salinity    units         pss-78     C_format      %8.4f      WHPO_Variable_Name        SALNTY     OBS_QC_VARIABLE       bottle_salinity_QC          "�   bottle_salinity_QC                 	long_name         bottle_salinity_QC_flag    units         woce_flags     C_format      %1d         "�   oxygen                 	long_name         oxygen     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        CTDOXY     OBS_QC_VARIABLE       
oxygen_QC           "�   	oxygen_QC                  	long_name         oxygen_QC_flag     units         woce_flags     C_format      %1d         "�   theta                  	long_name         theta      units         deg c      C_format      %8.4f      WHPO_Variable_Name        THETA           "�   bottle_oxygen                  	long_name         bottle_oxygen      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        OXYGEN     OBS_QC_VARIABLE       bottle_oxygen_QC            "�   bottle_oxygen_QC               	long_name         bottle_oxygen_QC_flag      units         woce_flags     C_format      %1d         "�   silicate               	long_name         	silicate       units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        SILCAT     OBS_QC_VARIABLE       silicate_QC         #    silicate_QC                	long_name         silicate_QC_flag       units         woce_flags     C_format      %1d         #   nitrate                	long_name         nitrate    units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        NITRAT     OBS_QC_VARIABLE       nitrate_QC          #    
nitrate_QC                 	long_name         nitrate_QC_flag    units         woce_flags     C_format      %1d         #8   nitrite                	long_name         nitrite    units         umol/kg    C_format      %8.2       WHPO_Variable_Name        NITRIT     OBS_QC_VARIABLE       nitrite_QC          #@   
nitrite_QC                 	long_name         nitrite_QC_flag    units         woce_flags     C_format      %1d         #X   	phosphate                  	long_name         
phosphate      units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        PHSPHT     OBS_QC_VARIABLE       phosphate_QC            #`   phosphate_QC               	long_name         phosphate_QC_flag      units         woce_flags     C_format      %1d         #x   freon_11               	long_name         	freon_11       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-11     OBS_QC_VARIABLE       freon_11_QC         #�   freon_11_QC                	long_name         freon_11_QC_flag       units         woce_flags     C_format      %1d         #�   freon_12               	long_name         	freon_12       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-12     OBS_QC_VARIABLE       freon_12_QC         #�   freon_12_QC                	long_name         freon_12_QC_flag       units         woce_flags     C_format      %1d         #�   	freon_113                  	long_name         
freon_113      units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC113     OBS_QC_VARIABLE       freon_113_QC            #�   freon_113_QC               	long_name         freon_113_QC_flag      units         woce_flags     C_format      %1d         #�   carbon_tetrachloride               	long_name         carbon_tetrachloride       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CCL4       OBS_QC_VARIABLE       carbon_tetrachloride_QC         #�   carbon_tetrachloride_QC                	long_name         carbon_tetrachloride_QC_flag       units         woce_flags     C_format      %1d         #�   
alkalinity                 	long_name         alkalinity     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        ALKALI     OBS_QC_VARIABLE       alkalinity_QC           $    alkalinity_QC                  	long_name         alkalinity_QC_flag     units         woce_flags     C_format      %1d         $   	total_co2                  	long_name         
total_co2      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        TCO2       OBS_QC_VARIABLE       total_co2_QC            $    total_co2_QC               	long_name         total_co2_QC_flag      units         woce_flags     C_format      %1d         $8   time                	long_name         time       units         "minutes since 1980-01-01 00:00:00      data_min       �jd   data_max       �jd   C_format      %10d            $@   latitude               	long_name         	latitude       units         
degrees_N      data_min      B��   data_max      B��   C_format      %9.4f           $D   	longitude                  	long_name         
longitude      units         
degrees_E      data_min      �j   data_max      �j   C_format      %9.4f           $L   	woce_date                   	long_name         
WOCE date      units         yyyymmdd UTC       data_min      K��B   data_max      K��B   C_format      %8d         $T   	woce_time                   	long_name         
WOCE time      units         	hhmm UTC       data_min      D��    data_max      D��    C_format      %4d         $X   station                	long_name         STATION    units         unspecified    C_format      %s        (  $\   cast               	long_name         CAST       units         unspecified    C_format      %s        (  $�@������@�
�ffff@���3333@������@�
�ffff@���3333@Ov_خ@=p��
>@QN;�5�@Aq��oiD@AqN;�5�@Aq&�x��   ���8     @AqJ���E@Aq7KƧ�   �@p`     @pL�����@pH        �?����@�?�V�Ϫ͞?�,<�쿲@q�     @pd�����@pY�����   �@A!G�z�@A�33333@B\(�   �@38Q��@3k��Q�@3���R   �                           �?��\(�?�G�z�H?�G�z�H   ���8     ��8     ��8        ���8     ��8     ��8        ���8     ��8     ��8        ���8     ��8     ��8      	 	 	���8     ��8     ��8      	 	 	�@�33333@�33333@�        � �jd@@^�����P�O�;d1��  �    57                                    2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         