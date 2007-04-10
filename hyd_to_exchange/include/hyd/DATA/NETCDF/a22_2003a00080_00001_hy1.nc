CDF       
      time      pressure      latitude      	longitude         string_dimension   (         EXPOCODE      316N200310     Conventions       COARDS/WOCE    WOCE_VERSION      3.0    WOCE_ID       A22    	DATA_TYPE         	WOCE BOT       STATION_NUMBER            80     CAST_NUMBER         1    BOTTOM_DEPTH_METERS         �   BOTTLE_NUMBERS        p     16     15     14     13     12     11     10      9      8      7      6      5      4      3      2      1   BOTTLE_QUALITY_CODES                         Creation_Time         ?Diggs EXBOT-to-NetCDF Code v0.1e: Thu May  4 01:27:50 2006 GMT     ORIGINAL_HEADER       �
BOTTLE,20060503WHPSIOSCD
#code : jjward hyd_to_exchange.pl 
#original files copied from HTML directory: 2006.05.03
#original HYD file: a22_2003ahy.txt   Mon May 23 12:18:22 2005
#original SUM file: a22_2003asu.txt   Wed May  3 18:23:14 2006
     WOCE_BOTTLE_FLAG_DESCRIPTION     �::1 = Bottle information unavailable.:2 = No problems noted.:3 = Leaking.:4 = Did not trip correctly.:5 = Not reported.:6 = Significant discrepancy in measured values between Gerard and Niskin bottles.:7 = Unknown problem.:8 = Pair did not trip correctly. Note that the Niskin bottle can trip at an unplanned depth while the Gerard trips correctly and vice versa.:9 = Samples not drawn from this bottle.:
      "WOCE_WATER_SAMPLE_FLAG_DESCRIPTION       �::1 = Sample for this measurement was drawn from water bottle but analysis not received.:2 = Acceptable measurement.:3 = Questionable measurement.:4 = Bad measurement.:5 = Not reported.:6 = Mean of replicate measurements.:7 = Manual chromatographic peak measurement.:8 = Irregular digital chromatographic peak integration.:9 = Sample not drawn for this measurement from this bottle.:
          '   ctd_raw                	long_name         ctd_raw    units                C_format      %8.1f      WHPO_Variable_Name        CTDRAW        �  "�   pressure               	long_name         	pressure       units         dbar       positive      down       C_format      %8.1f      WHPO_Variable_Name        CTDPRS        �  #   temperature                	long_name         temperature    units         its-90     C_format      %8.4f      WHPO_Variable_Name        CTDTMP        �  #�   salinity               	long_name         	salinity       units         pss-78     C_format      %8.4f      WHPO_Variable_Name        CTDSAL     OBS_QC_VARIABLE       salinity_QC       �  $   salinity_QC                	long_name         salinity_QC_flag       units         woce_flags     C_format      %1d          $�   bottle_salinity                	long_name         bottle_salinity    units         pss-78     C_format      %8.4f      WHPO_Variable_Name        SALNTY     OBS_QC_VARIABLE       bottle_salinity_QC        �  $�   bottle_salinity_QC                 	long_name         bottle_salinity_QC_flag    units         woce_flags     C_format      %1d          %0   oxygen                 	long_name         oxygen     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        CTDOXY     OBS_QC_VARIABLE       
oxygen_QC         �  %P   	oxygen_QC                  	long_name         oxygen_QC_flag     units         woce_flags     C_format      %1d          %�   theta                  	long_name         theta      units         deg c      C_format      %8.4f      WHPO_Variable_Name        THETA         �  %�   bottle_oxygen                  	long_name         bottle_oxygen      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        OXYGEN     OBS_QC_VARIABLE       bottle_oxygen_QC          �  &p   bottle_oxygen_QC               	long_name         bottle_oxygen_QC_flag      units         woce_flags     C_format      %1d          &�   silicate               	long_name         	silicate       units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        SILCAT     OBS_QC_VARIABLE       silicate_QC       �  '   silicate_QC                	long_name         silicate_QC_flag       units         woce_flags     C_format      %1d          '�   nitrate                	long_name         nitrate    units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        NITRAT     OBS_QC_VARIABLE       nitrate_QC        �  '�   
nitrate_QC                 	long_name         nitrate_QC_flag    units         woce_flags     C_format      %1d          (0   nitrite                	long_name         nitrite    units         umol/kg    C_format      %8.2       WHPO_Variable_Name        NITRIT     OBS_QC_VARIABLE       nitrite_QC        �  (P   
nitrite_QC                 	long_name         nitrite_QC_flag    units         woce_flags     C_format      %1d          (�   	phosphate                  	long_name         
phosphate      units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        PHSPHT     OBS_QC_VARIABLE       phosphate_QC          �  (�   phosphate_QC               	long_name         phosphate_QC_flag      units         woce_flags     C_format      %1d          )p   freon_11               	long_name         	freon_11       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-11     OBS_QC_VARIABLE       freon_11_QC       �  )�   freon_11_QC                	long_name         freon_11_QC_flag       units         woce_flags     C_format      %1d          *   freon_12               	long_name         	freon_12       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-12     OBS_QC_VARIABLE       freon_12_QC       �  *0   freon_12_QC                	long_name         freon_12_QC_flag       units         woce_flags     C_format      %1d          *�   	freon_113                  	long_name         
freon_113      units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC113     OBS_QC_VARIABLE       freon_113_QC          �  *�   freon_113_QC               	long_name         freon_113_QC_flag      units         woce_flags     C_format      %1d          +P   carbon_tetrachloride               	long_name         carbon_tetrachloride       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CCL4       OBS_QC_VARIABLE       carbon_tetrachloride_QC       �  +p   carbon_tetrachloride_QC                	long_name         carbon_tetrachloride_QC_flag       units         woce_flags     C_format      %1d          +�   
alkalinity                 	long_name         alkalinity     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        ALKALI     OBS_QC_VARIABLE       alkalinity_QC         �  ,   alkalinity_QC                  	long_name         alkalinity_QC_flag     units         woce_flags     C_format      %1d          ,�   	total_co2                  	long_name         
total_co2      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        TCO2       OBS_QC_VARIABLE       total_co2_QC          �  ,�   total_co2_QC               	long_name         total_co2_QC_flag      units         woce_flags     C_format      %1d          -0   time                	long_name         time       units         "minutes since 1980-01-01 00:00:00      data_min       ��   data_max       ��   C_format      %10d            -P   latitude               	long_name         	latitude       units         
degrees_N      data_min      Bn   data_max      Bn   C_format      %9.4f           -T   	longitude                  	long_name         
longitude      units         
degrees_E      data_min      �I   data_max      �I   C_format      %9.4f           -\   	woce_date                   	long_name         
WOCE date      units         yyyymmdd UTC       data_min      K��D   data_max      K��D   C_format      %8d         -d   	woce_time                   	long_name         
WOCE time      units         	hhmm UTC       data_min      D�@    data_max      D�@    C_format      %4d         -h   station                	long_name         STATION    units         unspecified    C_format      %s        (  -l   cast               	long_name         CAST       units         unspecified    C_format      %s        (  -�@ffffff@9�����@I�����@R������@X������@^�33333@b������@i�����@oI�����@r�33333@y	�����@Ffffff@�_33333@�m�����@�"fffff@�33333@ffffff@9�����@I�����@R������@X������@^�33333@b������@i�����@oI�����@r�33333@y	�����@Ffffff@�_33333@�m�����@�"fffff@�33333@,A��e��@-�-@,���O�;@-�N;�5�@,�oiDg8@*�$tS��@)�vȴ9X@(�F�]d@%��U�=@"�|�Q@�(��@u�Xy=�@�$xG@���'RT@jd��7�@�����@@�A�7K�@@�O�M@AG���+@A�ߤ?��@A���s�@A�U�=�@A��s�@A�MjO@A�!�R�<@A���+j�@A�?|�h@A�)^�	@A}�H˒@A|1&�y@Az���>B@Ay��                @@���)_@@��!�.I@AK��s�@A��ݗ�+@A���҈�@A�s����@A�-V@A��c�	@A�/��w@A���+j�@A�����>@A��PH@A}�!�R�@A{�A [�@Az�<64@AyA [�                @p�33333@o#33333@jl�����@fs33333@e      @e	�����@e�����@d�     @cI�����@b�fffff@d�     @h������@k�fffff@n������@p�����@pvfffff                @,A���'R@-�
�L/�@,�ڹ�Y�@-�xF�]@,��\)@*�H��@)��g��@(�J�L�@%{�l�C�@"�:�~� @�F
�L0@G��#��@s�E���@�䎊q�@"3���@�d��8@p`     @n������@j�����@fc33333@e)�����@eL�����@effffff@e6fffff@b�fffff@b<�����@e<�����@ifffff@l�     @nY�����@o������@p�                     ?�ffffff?��
=p��@z�G�@������@ffffff@=p��
>@p��
=q@p��
=q@%8Q��@)�fffff@+�Q�@)��\)@(�Q�@&��G�{@&�\(�@&�\(�                ?�(�\)?�
=p��
@z�G�@#k��Q�@(      @+��Q�@-�Q��@0\(�\@4Ǯz�H@7�\(�@78Q��@5\(�\@3�(�\@2������@2(�\)@1Ǯz�H                ?�z�G�{?�������?���Q�?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{                        ?�G�z�H?���Q�?��G�z�?�������?�      ?��
=p��?�z�G�?�Q��R?��\(�?�      ?�      ?��\(�?��\(�?�      ?�333333?��
=p��                @�+I�@��$�/@z�G�@vȴ9X@9XbM�@(�\)@����m@ O�;dZ?����S��?��
=p�?�dZ�1?�-V�@�+I�@�j~��#@+I�^@�hr�!                ?���n��?�|�hr�?����l�D?�������?�/��v�?��/��w?�hr� �?�E����?����n�?��x���?��hr�!?홙����?�n��O�;?���l�D?�����+?�1&�y                ?�I�^5?ȴ9XbN?�\(��?��-V?��1&�?��+I�?����+?�9XbM�?���E��?�bM���?��+J?����E�?���
=p�?����l�?��
=p��?����l�                @      @~��"��?�bM���?�$�/��?�V�u?��/��w?�V�u?�\(�\?�hr� Ĝ?�V�u?�333333?��\(�@-V@�vȴ9X@I�^5@@�1&�y                @������@�������@�������@�<�����@�I     @�G33333@�=33333��8     @�/33333@��������8     @�fffff@������@�	�����@�fffff@�33333        	   	     @�[33333@��     @�]     @��     @��     @��     @��33333@��33333@�     @������@�33333@�fffff@��33333@�񙙙��@�������@��33333                 ��@C�\(��Q{�*0U21��  �    80                                    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     